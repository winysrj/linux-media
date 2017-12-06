Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57412 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbdLFQgH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 11:36:07 -0500
Subject: Re: [RFC 1/1] v4l: async: Use endpoint node, not device node, for
 fwnode match
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, jmondi <jacopo@jmondi.org>
References: <20171204210302.24707-1-sakari.ailus@linux.intel.com>
 <20171206155748.GF31989@bigcity.dyn.berto.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <6bfbf573-da70-1c4b-7b2e-081ca3791525@ideasonboard.com>
Date: Wed, 6 Dec 2017 16:36:02 +0000
MIME-Version: 1.0
In-Reply-To: <20171206155748.GF31989@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 06/12/17 15:57, Niklas Söderlund wrote:
> CC Jacopo, Kieran
> 
> Hi Sakari,
> 
> Thanks for your patch.
> 
> On 2017-12-04 23:03:02 +0200, Sakari Ailus wrote:
>> V4L2 async framework can use both device's fwnode and endpoints's fwnode
>> for matching the async sub-device with the sub-device. In order to proceed
>> moving towards endpoint matching assign the endpoint to the async
>> sub-device.
> 
> Endpoint matching I think is the way to go forward. It will solve a set 
> of problems that exists today. So I think this a good step in the right 
> direction.
> 
>>
>> As most async sub-device drivers (and the related hardware) only supports
>> a single endpoint, use the first endpoint found. This works for all
>> current drivers --- we only ever supported a single async sub-device per
>> device to begin with.
> 
> This assumption is not true, the adv748x exposes multiple subdevice from 
> a single device node in DT and registers them using different endpoints.  
> Now the only user of the adv748x driver I know of is the rcar-csi2 
> driver which is not yet upstream so this can be consider a special case.

Quite - but the match parent patch still hasn't got upstream yet either - so
it's still not supported.

I'd love to know if there are other devices with an ADV748x out there though!

<snip>


> Here the adv7612 driver would register a subdevice using the endpoint 
> 'hdmi-in@4c/ports/port@0/endpoint' while the rcar-vin driver which uses 
> the async parsing helpers would register a notifier looking for 
> 'hdmi-in@4c/ports/port@2/endpoint'.
> 
> Something like Kieran's '[PATCH v5] v4l2-async: Match parent devices' 
> would be needed in addition to this patch. I tried Kieran's patch 
> together with this and it did not solve the problem upstream. I did make 
> a hack on-top of Kieran's patch to add a comparison 'sd_parent == 
> asd_parent' in match_fwnode() which got rcar-gen2 working again, but I'm 
> not sure if that will have other side effects.

Matching parent == parent will have the side effect that all devices with
multiple endpoints, will discover all endpoints successfully match on both
device comparisons.

Thus, this in effect will completely undo all endpoint matching efforts.


<snip>

Regards

Kieran
