Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35510 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbdECHnk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 03:43:40 -0400
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
References: <20161228183036.GA13139@amd> <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd> <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd> <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <db549a81-0c1f-3ff0-6293-050ec2e0af84@iki.fi>
Date: Wed, 3 May 2017 10:43:37 +0300
MIME-Version: 1.0
In-Reply-To: <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On 03/04/17 15:03, Sakari Ailus wrote:
> Hi Pavel,
> 
> On Thu, Mar 02, 2017 at 01:38:48PM +0100, Pavel Machek wrote:
>> Hi!
>>
>>>> Ok, how about this one?
>>>> omap3isp: add rest of CSI1 support
>>>>     
>>>> CSI1 needs one more bit to be set up. Do just that.
>>>>     
>>>> It is not as straightforward as I'd like, see the comments in the code
>>>> for explanation.
>> ...
>>>> +	if (isp->phy_type == ISP_PHY_TYPE_3430) {
>>>> +		struct media_pad *pad;
>>>> +		struct v4l2_subdev *sensor;
>>>> +		const struct isp_ccp2_cfg *buscfg;
>>>> +
>>>> +		pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
>>>> +		sensor = media_entity_to_v4l2_subdev(pad->entity);
>>>> +		/* Struct isp_bus_cfg has union inside */
>>>> +		buscfg = &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
>>>> +
>>>> +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
>>>> +					ISP_INTERFACE_CCP2B_PHY1,
>>>> +					enable, !!buscfg->phy_layer,
>>>> +					buscfg->strobe_clk_pol);
>>>
>>> You should do this through omap3isp_csiphy_acquire(), and not call
>>> csiphy_routing_cfg_3430() directly from here.
>>
>> Well, unfortunately omap3isp_csiphy_acquire() does have csi2
>> assumptions hard-coded :-(.
>>
>> This will probably fail.
>>
>> 	        rval = omap3isp_csi2_reset(phy->csi2);
>> 	        if (rval < 0)
>> 		                goto done;
> 
> Could you try to two patches I've applied on the ccp2 branch (I'll remove
> them if there are issues).
> 
> That's compile tested for now only.
> 

I've updated the CCP2 patches here on top of the latest fwnode patches:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ccp2>

No even compile testing this time though. I'm afraid I haven't had the
time to otherwise to work on the CCP2 support, so there are no other
changes besides the rebase.

I intend to send a pull request for the fwnode patches once we have the
next rc1 in media tree so then we can have the patches on plain media
tree master branch.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
