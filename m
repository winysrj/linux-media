Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47801 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937141AbdEWRkN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 13:40:13 -0400
Subject: Re: [PATCH v3 2/2] v4l: async: Match parent devices
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kbingham@kernel.org>
References: <cover.33d4457de9c9f4e5285e7b1d18a8a92345c438d3.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6154c8f092e1cb4f5286c1f11f4a846c821b53d6.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170523130222.GE29527@valkosipuli.retiisi.org.uk>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f56ce770-c7cc-1613-194f-e5f9a944dc4e@ideasonboard.com>
Date: Tue, 23 May 2017 18:40:08 +0100
MIME-Version: 1.0
In-Reply-To: <20170523130222.GE29527@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/05/17 14:02, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Mon, May 22, 2017 at 06:36:38PM +0100, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Devices supporting multiple endpoints on a single device node must set
>> their subdevice fwnode to the endpoint to allow distinct comparisons.
>>
>> Adapt the match_fwnode call to compare against the provided fwnodes
>> first, but also to search for a comparison against the parent fwnode.
>>
>> This allows notifiers to pass the endpoint for comparison and still
>> support existing subdevices which store their default parent device
>> node.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>> v2:
>>  - Added documentation comments
>>  - simplified the OF match by adding match_fwnode_of()
>>
>> v3:
>>  - Fix comments
>>  - Fix sd_parent, and asd_parent usage
>>
>>  drivers/media/v4l2-core/v4l2-async.c | 36 ++++++++++++++++++++++++-----
>>  1 file changed, 31 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>> index cbd919d4edd2..12c0707851fd 100644
>> --- a/drivers/media/v4l2-core/v4l2-async.c
>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>> @@ -41,14 +41,40 @@ static bool match_devname(struct v4l2_subdev *sd,
>>  	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
>>  }
>>  
>> +/*
>> + * Check whether the two device_node pointers refer to the same OF node. We
>> + * can't compare pointers directly as they can differ if overlays have been
>> + * applied.
>> + */
>> +static bool match_fwnode_of(struct fwnode_handle *a, struct fwnode_handle *b)
>> +{
>> +	return !of_node_cmp(of_node_full_name(to_of_node(a)),
>> +			    of_node_full_name(to_of_node(b)));
>> +}
>> +
>> +/*
>> + * As a measure to support drivers which have not been converted to use
>> + * endpoint matching, we also find the parent devices for cross-matching.
>> + *
>> + * When all devices use endpoint matching, this code can be simplified, and the
>> + * parent comparisons can be removed.
>> + */
>>  static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>>  {
>> -	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
>> -		return sd->fwnode == asd->match.fwnode.fwnode;
>> +	struct fwnode_handle *asd_fwnode = asd->match.fwnode.fwnode;
>> +	struct fwnode_handle *sd_parent, *asd_parent;
>> +
>> +	sd_parent = fwnode_graph_get_port_parent(sd->fwnode);
>> +	asd_parent = fwnode_graph_get_port_parent(asd_fwnode);
>> +
>> +	if (!is_of_node(sd->fwnode) || !is_of_node(asd_fwnode))
>> +		return sd->fwnode == asd_fwnode ||
>> +		       sd_parent == asd_fwnode ||
>> +		       sd->fwnode == asd_parent;
>>  
>> -	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
>> -			    of_node_full_name(
>> -				    to_of_node(asd->match.fwnode.fwnode)));
>> +	return match_fwnode_of(sd->fwnode, asd_fwnode) ||
>> +	       match_fwnode_of(sd_parent, asd_fwnode) ||
>> +	       match_fwnode_of(sd->fwnode, asd_parent);
>>  }
>>  
>>  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> 
> Would this become easier to read if you handled all matching in what is
> called match_fwnode_of() above, also for non-OF fwnodes? Essentially you'd
> have what used to be match_fwnode() there, and new match_fwnode() would call
> that function with all the three combinations.
> 


> I'd call the other function __match_fwnode() for instance.
> 


Yes - Took me a moment to understand what you meant here - but yes it's leaner +
cleaner:


/*
 * As a measure to support drivers which have not been converted to use
 * endpoint matching, we also find the parent devices for cross-matching.
 *
 * When all devices use endpoint matching, this code can be simplified, and the
 * parent comparisons can be removed.
 */

static bool __match_fwnode(struct fwnode_handle *a, struct fwnode_handle *b)
{
	if (is_of_node(a) || is_of_node(b))
		return !of_node_cmp(of_node_full_name(to_of_node(a)),
				    of_node_full_name(to_of_node(b)));
	else
		return a == b;
}

static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
{
	struct fwnode_handle *asd_fwnode = asd->match.fwnode.fwnode;
	struct fwnode_handle *sd_parent, *asd_parent;

	sd_parent = fwnode_graph_get_port_parent(sd->fwnode);
	asd_parent = fwnode_graph_get_port_parent(asd_fwnode);

	return __match_fwnode(sd->fwnode, asd_fwnode) ||
	       __match_fwnode(sd_parent, asd_fwnode) ||
	       __match_fwnode(sd->fwnode, asd_parent);
}
