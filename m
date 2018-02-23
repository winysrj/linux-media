Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:38596 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbeBWSW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 13:22:59 -0500
Received: by mail-pg0-f44.google.com with SMTP id l24so3661192pgc.5
        for <linux-media@vger.kernel.org>; Fri, 23 Feb 2018 10:22:59 -0800 (PST)
Subject: Re: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback
 decide if no remote is error
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
 <3283028.CgXzGkPyKt@avalon> <1519379812.7712.1.camel@pengutronix.de>
 <2571855.0gglA1aPyk@avalon> <1519384577.7712.4.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9c938a67-ab51-440b-65f5-26c03176cb8c@gmail.com>
Date: Fri, 23 Feb 2018 10:22:56 -0800
MIME-Version: 1.0
In-Reply-To: <1519384577.7712.4.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,


On 02/23/2018 03:16 AM, Philipp Zabel wrote:
> Hi Laurent,
>
> On Fri, 2018-02-23 at 12:05 +0200, Laurent Pinchart wrote:
>> Hi Philipp,
>>
>> On Friday, 23 February 2018 11:56:52 EET Philipp Zabel wrote:
>>> On Fri, 2018-02-23 at 11:29 +0200, Laurent Pinchart wrote:
>>>> On Thursday, 22 February 2018 03:39:37 EET Steve Longerbeam wrote:
>>>>> For some subdevices, a fwnode endpoint that has no connection to a
>>>>> remote endpoint may not be an error. Let the parse_endpoint callback
>>>> make that decision in v4l2_async_notifier_fwnode_parse_endpoint(). If
>>>>> the callback indicates that is not an error, skip adding the asd to the
>>>>> notifier and return 0.
>>>>>
>>>>> For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
>>>>> (omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
>>>>> unavailable remote fwnodes to maintain the previous behavior.
>>>> I'm not sure this should be a per-driver decision.
>>>>
>>>> Generally speaking, if an endpoint node has no remote-endpoint property,
>>>> the endpoint node is not needed. I've always considered such an endpoint
>>>> node as invalid. The OF graphs DT bindings are however not clear on this
>>>> subject.
>>> Documentation/devicetree/bindings/graph.txt says:
>>>
>>>    Each endpoint should contain a 'remote-endpoint' phandle property
>>>    that points to the corresponding endpoint in the port of the remote
>>>    device.
>>>
>>> ("should", not "must").
>> The DT bindings documentation has historically used "should" to mean "must" in
>> many places :-( That was a big mistake.
> Maybe I could have worded that better? The intention was to let "should"
> be read as a strong suggestion, like "it is recommended", but not as a
> requirement.
>
>>> Later, the remote-node property explicitly lists the remote-endpoint
>>> property as optional.
>> I've seen that too, and that's why I mentioned that the documentation isn't
>> clear on the subject.
> Do you have a suggestion how to improve the documentation? I thought
> listing the remote-endpoint property under a header called "Optional
> endpoint properties" was pretty clear.
>
>> This could also be achieved by adding the endpoints in the board DT files. See
>> for instance the hdmi@fead0000 node in arch/arm64/boot/dts/renesas/
>> r8a7795.dtsi and how it gets extended in arch/arm64/boot/dts/renesas/r8a7795-
>> salvator-x.dts. On the other hand, I also have empty endpoints in the
>> display@feb00000 node of arch/arm64/boot/dts/renesas/r8a7795.dtsi.
> Right, that would be possible.

Yes, I think this is doable in the specific case of the video mux device.

For example on the i.MX6 SabreAuto reference boards, only the parallel
bus mux input is connected to a device (to adv7180). The MIPI CSI-2 mux
input is left unconnected.

So probably the right approach is to not define any endpoint nodes under the
unused mux input ports.

The video-mux driver will need to be modified to enumerate ports, instead of
endpoints, to determine its number of mux inputs.

I will start looking into this change for v2.

The trick would be to do this while still remaining compatible with old
DTB's in the wild with unconnected endpoints. Unfortunately that might
not be possible, unless we were to let v4l2-core ignore empty endpoints.


>
>> I think we should first decide what we want to do going forward (allowing for
>> empty endpoints or not), clarify the documentation, and then update the code.
>> In any case I don't think it should be a per-device decision.
> There are device trees in the wild that have those empty endpoints, so I
> don't think retroactively declaring the remote-endpoint property
> required is a good idea.
>
> Is there any driver that currently benefits from throwing an error on
> empty endpoints in any way? I'd prefer to just let the core ignore empty
> endpoints for all drivers.

I tend to agree that, given the fuzziness of the DT binding docs regarding
unconnected endpoints, v4l2-core should ignore them.

In v2 I can modify this patch to ignore empty endpoints without error and
continue with endpoint parsing rather than pass the empty endpoint to the
caller's parse_endpoint callback.

Or this patch can be dropped altogether. It won't be needed for i.MX6 after
making the change described above, but again if this patch is dropped it 
will
break b/w compatibility with old i.MX6 DTB's.


Steve
