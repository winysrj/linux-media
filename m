Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:22954 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753596AbdHUTDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 15:03:15 -0400
Subject: Re: [PATCH] device property: preserve usecount for node passed to
 of_fwnode_graph_get_port_parent()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
References: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
 <282c50da-8927-d1fc-27e5-39b75f3ba564@linux.intel.com>
 <20170821140443.GA32709@bigcity.dyn.berto.se>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <8e5d0f0b-de07-c25e-a6f9-cb2109e67cbe@linux.intel.com>
Date: Mon, 21 Aug 2017 22:03:02 +0300
MIME-Version: 1.0
In-Reply-To: <20170821140443.GA32709@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Niklas Söderlund wrote:
> Hi Sakari,
>
> On 2017-08-21 16:30:17 +0300, Sakari Ailus wrote:
>> Hi Niklas,
>>
>> Niklas Söderlund wrote:
>>> Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
>>> node being passed to of_fwnode_graph_get_port_parent(). Preserve the
>>> usecount just like it is done in of_graph_get_port_parent().
>>
>> The of_fwnode_graph_get_port_parent() is called by
>> fwnode_graph_get_port_parent() which obtains the port node through
>> fwnode_get_parent(). If you take a reference here, calling
>> fwnode_graph_get_port_parent() will end up incrementing the port node's use
>> count. In other words, my understanding is that dropping the reference to
>> the port node isn't a problem but intended behaviour here.
>
> I'm not sure but I don't think the usecount will be incremented, without
> this patch I think it's decremented by one instead. Lets look at the
> code starting with fwnode_graph_get_port_parent().
>
> struct fwnode_handle *
> fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
> {
>         struct fwnode_handle *port, *parent;
>
> Increment usecount by 1
>
>         port = fwnode_get_parent(endpoint);
>         parent = fwnode_call_ptr_op(port, graph_get_port_parent);
>
> Decrement usecount by 1
>
>         fwnode_handle_put(port); << Usecount -1

Here it is; this is the one I missed.

I spotted something else, too. Look at of_graph_get_port_parent(); it 
appears to decrement the use count of the node passed to it, too:

struct device_node *of_graph_get_port_parent(struct device_node *node)
{
         unsigned int depth;

         /* Walk 3 levels up only if there is 'ports' node. */
         for (depth = 3; depth && node; depth--) {
                 node = of_get_next_parent(node);
                 if (depth == 2 && of_node_cmp(node->name, "ports"))
                         break;
         }
         return node;
}
EXPORT_SYMBOL(of_graph_get_port_parent);

I think you'd need to of_node_get(node) first. I think it'd be good to 
address this at the same time.

One could claim the original design principle has truly been adopted in 
the fwnode variant of the function. X-)

On your original patch --- could you replace of_get_next_parent() by 
of_get_parent()? In that case it won't drop the reference to the parent, 
i.e. does what's required.

>
>         return parent;
> }
>
> Here it looks like the counting is correct and balanced. But without
> this patch it's in this function 'fwnode_handle_put(port)' which
> triggers the error which this patch aims to fix. Lets look at
> of_fwnode_graph_get_port_parent() which in my case is what is called by
> the fwnode_call_ptr_op().
>
> static struct fwnode_handle *
> of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
> {
>         struct device_node *np;
>
> Here in of_get_next_parent() the usecount is decremented by 1 and the
> parents usecount is incremented by 1. So for our node node which passed
> in from fwnode_graph_get_port_parent() (where it's named 'port') will be
> decremented by 1.
>
>         /* Get the parent of the port */
>         np = of_get_next_parent(to_of_node(fwnode));
>         if (!np)
>                 return NULL;
>
>         /* Is this the "ports" node? If not, it's the port parent. */
>         if (of_node_cmp(np->name, "ports"))
>                 return of_fwnode_handle(np);
>
>         return of_fwnode_handle(of_get_next_parent(np));
> }
>
> So unless I miss something I do think this patch is needed to restore
> balance to the usecount of the node being passed to
> of_fwnode_graph_get_port_parent(). Or maybe I have misunderstood
> something?
>
>>
>> I wonder if I miss something.
>
> I also wonder what I missed :-)
>
>>
>>>
>>> Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>> ---
>>>  drivers/of/property.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/of/property.c b/drivers/of/property.c
>>> index 067f9fab7b77c794..637dcb4833e2af60 100644
>>> --- a/drivers/of/property.c
>>> +++ b/drivers/of/property.c
>>> @@ -922,6 +922,12 @@ of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
>>>  {
>>>  	struct device_node *np;
>>>
>>> +	/*
>>> +	 * Preserve usecount for passed in node as of_get_next_parent()
>>> +	 * will do of_node_put() on it.
>>> +	 */
>>> +	of_node_get(to_of_node(fwnode));
>>> +
>>>  	/* Get the parent of the port */
>>>  	np = of_get_next_parent(to_of_node(fwnode));
>>>  	if (!np)
>>>
>>
>>
>> --
>> Sakari Ailus
>> sakari.ailus@linux.intel.com
>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
