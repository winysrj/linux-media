Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52933 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbcFRJFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 05:05:30 -0400
Subject: Re: tchellRe: [19/38] ARM: dts: imx6-sabrelite: add video capture
 ports and connections
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Gary Bisson <gary.bisson@boundarydevices.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
 <20160616083231.GA6548@t450s.lan> <20160617151814.GA16378@t450s.lan>
 <576448DE.1040002@mentor.com>
Cc: linux-media@vger.kernel.org, Jack Mitchell <ml@embed.me.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57650ED5.4030705@xs4all.nl>
Date: Sat, 18 Jun 2016 11:05:25 +0200
MIME-Version: 1.0
In-Reply-To: <576448DE.1040002@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2016 09:00 PM, Steve Longerbeam wrote:
> 
> 
> On 06/17/2016 08:18 AM, Gary Bisson wrote:
>> Steve, All,
>>
>> On Thu, Jun 16, 2016 at 10:32:31AM +0200, Gary Bisson wrote:
>>> Steve, All,
>>>
>>> On Tue, Jun 14, 2016 at 03:49:15PM -0700, Steve Longerbeam wrote:
>>>> Defines the host video capture device node and an OV5642 camera sensor
>>>> node on i2c2. The host capture device connects to the OV5642 via the
>>>> parallel-bus mux input on the ipu1_csi0_mux.
>>>>
>>>> Note there is a pin conflict with GPIO6. This pin functions as a power
>>>> input pin to the OV5642, but ENET requires it to wake-up the ARM cores
>>>> on normal RX and TX packet done events (see 6261c4c8). So by default,
>>>> capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
>>>> Ethernet will still work just not quite as well.
>>> Actually the following patch fixes this issue and has already been
>>> applied on Shawn's tree:
>>> https://patchwork.kernel.org/patch/9153523/
>>>
>>> Also, this follow-up patch declared the HW workaround for SabreLite:
>>> https://patchwork.kernel.org/patch/9153525/
>>>
>>> So ideally, once those two patches land on your base tree, you could get
>>> rid of the #define and remove the HW workaround declaration.
>>>
>>> Finally, I'll test the series on Sabre-Lite this week.
>> I've applied this series on top of Shawn tree (for-next branch) in order
>> not to worry about the GPIO6 workaround.
>>
>> Although the camera seems to get enumerated properly, I can't seem to
>> get anything from it. See log:
>> http://pastebin.com/xnw1ujUq
> 
> Hi Gary, the driver does not implement vidioc_cropcap, it has
> switched to the new selection APIs and v4l2src should be using
> vidioc_g_selection instead of vidioc_cropcap.

The v4l2 core should emulate cropcap on top of the selection API,
so this should work (except for the known 4.7 regression, hopefully
that fix will be merged soon).

The only remaining need for cropcap would be to fill in the pixelaspect
ratio if the pixels aren't square.

Regards,

	Hans

> 
>>
>> In your cover letter, you said that you have not run through
>> v4l2-compliance. How have you tested the capture?
> 
> I use v4l2-ctl, and have used v4l2src in the past, but that was before
> switching to the selection APIs. Try the attached hack that adds
> vidioc_cropcap back in, and see how far you get on SabreLite with
> v4l2src. I tried  the following on SabreAuto:
> 
> gst-launch-1.0 v4l2src io_mode=4 ! 
> "video/x-raw,format=RGB16,width=640,height=480" ! fbdevsink
> 
>>
>> Also, why isn't the OV5640 MIPI camera declared on the SabreLite device
>> tree?
> 
> See Jack Mitchell's patch at http://ix.io/TTg. Thanks Jack! I will work on
> incorporating it.
> 
> 
> Steve
> 
> 
