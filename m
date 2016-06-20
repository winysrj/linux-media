Return-path: <linux-media-owner@vger.kernel.org>
Received: from eumx.net ([91.82.101.43]:39546 "EHLO owm.eumx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbcFTKOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 06:14:55 -0400
Subject: Re: [19/38] ARM: dts: imx6-sabrelite: add video capture ports and
 connections
To: Gary Bisson <gary.bisson@boundarydevices.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
 <20160616083231.GA6548@t450s.lan> <20160617151814.GA16378@t450s.lan>
 <57644915.3010006@gmail.com> <20160620093351.GA24310@t450s.lan>
Cc: linux-media@vger.kernel.org
From: Jack Mitchell <ml@embed.me.uk>
Message-ID: <d9bd2b49-e36b-6082-e31a-99d6c8c70b2c@embed.me.uk>
Date: Mon, 20 Jun 2016 10:44:44 +0100
MIME-Version: 1.0
In-Reply-To: <20160620093351.GA24310@t450s.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 20/06/16 10:33, Gary Bisson wrote:
> Steve, Jack, All,
>
> On Fri, Jun 17, 2016 at 12:01:41PM -0700, Steve Longerbeam wrote:
>>
>> On 06/17/2016 08:18 AM, Gary Bisson wrote:
>>> Steve, All,
>>>
>>> On Thu, Jun 16, 2016 at 10:32:31AM +0200, Gary Bisson wrote:
>>>> Steve, All,
>>>>
>>>> On Tue, Jun 14, 2016 at 03:49:15PM -0700, Steve Longerbeam wrote:
>>>>> Defines the host video capture device node and an OV5642 camera sensor
>>>>> node on i2c2. The host capture device connects to the OV5642 via the
>>>>> parallel-bus mux input on the ipu1_csi0_mux.
>>>>>
>>>>> Note there is a pin conflict with GPIO6. This pin functions as a power
>>>>> input pin to the OV5642, but ENET requires it to wake-up the ARM cores
>>>>> on normal RX and TX packet done events (see 6261c4c8). So by default,
>>>>> capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
>>>>> Ethernet will still work just not quite as well.
>>>> Actually the following patch fixes this issue and has already been
>>>> applied on Shawn's tree:
>>>> https://patchwork.kernel.org/patch/9153523/
>>>>
>>>> Also, this follow-up patch declared the HW workaround for SabreLite:
>>>> https://patchwork.kernel.org/patch/9153525/
>>>>
>>>> So ideally, once those two patches land on your base tree, you could get
>>>> rid of the #define and remove the HW workaround declaration.
>>>>
>>>> Finally, I'll test the series on Sabre-Lite this week.
>>> I've applied this series on top of Shawn tree (for-next branch) in order
>>> not to worry about the GPIO6 workaround.
>>>
>>> Although the camera seems to get enumerated properly, I can't seem to
>>> get anything from it. See log:
>>> http://pastebin.com/xnw1ujUq
>>
>> Hi Gary, the driver does not implement vidioc_cropcap, it has
>> switched to the new selection APIs and v4l2src should be using
>> vidioc_g_selection instead of vidioc_cropcap.
>
> I confirm this was the issue, your patch fixes it.
>
>>> In your cover letter, you said that you have not run through
>>> v4l2-compliance. How have you tested the capture?
>>
>> I use v4l2-ctl, and have used v4l2src in the past, but that was before
>> switching to the selection APIs. Try the attached hack that adds
>> vidioc_cropcap back in, and see how far you get on SabreLite with
>> v4l2src. I tried  the following on SabreAuto:
>>
>> gst-launch-1.0 v4l2src io_mode=4 !
>> "video/x-raw,format=RGB16,width=640,height=480" ! fbdevsink
>
> I confirm that works with OV5642 on SabreLite:
> Tested-by: Gary Bisson <gary.bisson@boundarydevices.com>
>
>>> Also, why isn't the OV5640 MIPI camera declared on the SabreLite device
>>> tree?
>>
>> See Jack Mitchell's patch at http://ix.io/TTg. Thanks Jack! I will work on
>> incorporating it.

Hi Gary,

>
> I've tried that patch have a some comments:
> - When applied, no capture shows up any more, instead I have two m2m
>   v4l2 devices [1].
> - OV5640 Mipi is assigned the same address as OV5642, therefore both

Yes, I only have one device attached in my scenario.

>   can't work at the same time right now. There's a register in the
>   camera that allows to modify its I2C address, see this patch [2].
> - How is the mclk working in this patch? It should be using the PWM3

As mentioned I have an eCon sensor board [1] which generates it's own 
clock on the board and as such I don't need the PWM signal, just the two 
GPIOs.

>   output to generate a ~22MHz clock. I would expect the use of a
>   pwm-clock node [3].
>
> Also another remark on both OV5642 and OV5640 patches, is it recommended
> to use 0x80000000 pin muxing value? This leaves it to the bootloader to

I also wondered about this, but didn't know if the pinmux driver did 
this based on the define name? I tried it both ways and it worked so I 
just left it as it was.

Cheers,
Jack.

[1] https://www.e-consystems.com/iMX6-MIPI-Camera-Board.asp

> properly setup the I/O. It sounds safer to properly set them up in the
> device tree in my opinion in order not to be dependent on the bootloader.
>
> All the above remarks said, thanks for this work on i.MX camera support,
> that feature will be highly appreciated.
>
> Regards,
> Gary
>
> [1] http://pastebin.com/i5MrhB1h
> [2] https://github.com/boundarydevices/linux-imx6/commit/f915806d
> [3] http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/clock/pwm-clock.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
