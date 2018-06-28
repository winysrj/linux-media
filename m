Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:57195 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966209AbeF1OXX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 10:23:23 -0400
Subject: Re: [PATCH] [RFC] em28xx: Fix dual transport stream use
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Brad Love <brad@nextdimension.cc>
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
References: <1530128483-31662-1-git-send-email-brad@nextdimension.cc>
 <20180628061005.3f068122@coco.lan>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <d5172173-8404-580c-08fb-b2cd836bd243@nextdimension.cc>
Date: Thu, 28 Jun 2018 09:23:21 -0500
MIME-Version: 1.0
In-Reply-To: <20180628061005.3f068122@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


On 2018-06-28 04:10, Mauro Carvalho Chehab wrote:
> Em Wed, 27 Jun 2018 14:41:22 -0500
> Brad Love <brad@nextdimension.cc> escreveu:
>
>> When dual transport stream support was added the call to set
>> alt mode on the USB interface was moved to em28xx_dvb_init.
>> This was reported to break streaming for a device, so the
>> call was re-added to em28xx_start_streaming.
>>
>> Commit 509f89652f83 ("media: em28xx: fix a regression with HVR-950")
>>
>> This regression fix however broke dual transport stream support.
>> When a tuner starts streaming it sets alt mode on the USB interface.
>> The problem is both tuners share the same USB interface, so when
>> the second tuner becomes active and sets alt mode on the interface
>> it kills streaming on the other port.
>>
>> It was suggested add a refcount somewhere and only set alt mode if
>> no tuners are currently active on the interface. This requires
>> sharing some state amongst both tuner devices, with appropriate
>> locking.
>>
>> What I've done here is the following:
>> - Add a usage_count pointer to struct em28xx
>> - Share usage_count between both em28xx devices
>> - Only set alt mode if usage_count is zero
>> - Increment usage_count when each tuner becomes active
>> - Decrement usage_count when a tuner becomes idle
>>
>> With usage_count in the main em28xx struct, locking is handled as
>> follows:
>> - if a secondary tuner exists, lock dev->dev_next->lock
>> - if no secondary tuner exists, lock dev->lock
>>
>> By using the above scheme a single tuner device, will lock itself,
>> the first tuner in a dual tuner device will lock the second tuner,
>> and the second tuner in a dual tuner device will lock itself aka
>> the second tuner instance.
>>
>> This is a perhaps a little hacky, which is why I've added the RFC.
>> A quick solution was required though, so I don't fix a couple
>> newer Hauppauge devices, just to break a lot of older ones.
> Hi Brad,
>
> I didn't look at the patches, just at the description. IMHO,
> the proposed approach won't work.
>
> I suspect that it will require a redesign of the alternate setting
> logic, but we have to handle first with the regressions.
>
> So, I'll break this into two separate issues
>
> 1) HVR-950 x dual mode tuners regression
>
> HVR-950 uses a model of em28xx chipset that doesn't support dual=20
> tuners (em2884 - I think) and has a tuner defined for analog TV.=20
>
> Even on chipsets that supports dual tuners, most of the designs=20
> come with just one.
>
> An easier fix would be check if the device supports dual tuner.
> That could be done either by checking dev->chip_id of via an
> extra bit at em28xx cards struct:
> 	unsigned int has_dual_tuners:1;
> that would indicate if the device has dual tuners.
>
> Then, decide where the alternate settings logic will happen.
>
> That would allow a simple patch that will fix regressions with
> single tuner devices while keeping Digital TV support for dual
> tuners working.
>
> A fix like that should be easy to do and to backport to older
> Kernels.
>
> IMHO, we should do it as a first approach to solve the issue,
> and send with c/c to -stable.
>
> 2) Fixing the alt logic to better support dual-streaming devices
>
> After thinking about the code changes to support dual tuner devices,
> I suspect that something was missing there for the dual tuner
> devices.
>
> On a single tuner device, the alternate should be set considering
> those scenarios (enumerated from less bandwidth to high bandwidth):
>
> 	0) Device is not streaming
> 	1) FM mode - just em28xx-audio sets the hardware to stream
> 	   audio via ALSA.
> 	2) Digital TV
> 	3) Webcam, Analog TV or Capture stream - I'll call it ATV below
> 	   for simplicity.
>
> For all scenarios, the alternate is chosen to be the closest one to
> the required bandwidth, in order to reduce latency. Still, the latency
> can be somewhat painful on em28xx-based cameras.
>
> It should be noticed that, for ATV, userspace can start streaming audio=

> video in any order, e. g. it can start streaming audio, then switch
> to TV and start streaming video. It can also do the reverse: start
> streaming video, and then start audio. The current logic was designed
> and tested to support this.
>
> I'm not sure if em28xx can support the secondary tuner on all
> three different modes. If it can, with 2 tuners, that expands to 16
> different combinations:
>
> 	=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D
> 	tuner 0  tuner 1
> 	=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D
> 	none     none
> 	none     FM
> 	none     DTV
> 	none     ATV
> 	FM       none
> 	FM       FM
> 	FM       DTV
> 	FM       ATV
> 	DTV      none
> 	DTV      FM
> 	DTV      DTV
> 	DTV      ATV
> 	ATV      none
> 	ATV      FM
> 	ATV      DTV
> 	ATV      ATV
> 	=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D
>
> Worse than that, when one tuner is active and another one starts to be
> used, it may need to change the alternate, with affects the first tuner=
=2E
> Not sure what happens with the pending URBs if the alternate is changed=

> at runtime. If this is not allowed, the driver will need to cancel all
> pending URBs, switch the alternate and re-submit URBs for the first
> active tuner.
>
> The logic should also consider the case where both tuners are streamed
> and one stops. Perhaps it could just keep it using the dual-tuner
> alternate until both stops.
>
> In any case, for proper alternate setting, I'm expecting to see a patch=

> that would touch em28xx-dvb, em28xx-audio and em28xx-v4l2, as
> whatever logic it needs, it has to consider all supported combinations.=

>
> Such patch would likely be too complex for -stable.
>
> Thanks,
> Mauro

Thanks for the in depth comments. I'm fully aware that my quick hack was
likely not acceptable, but I have to provide builds that support DualHD
as well as older (far more DualHD than older, but still) Hauppauge
hardware, so I needed something to handle the regression asap. I won't
be able to do an extensive driver wide audit of the alt mode setting
until August due to travel.

Both Isoc and Bulk DualHD models are reported working perfectly fine in
dvb, without setting alt mode in em28xx_start_streaming and only setting
it once in em28xx_dvb_init. Whereas the em28xx-video driver sets alt
mode to 0 on close, neither em28xx-audio nor em28xx-dvb do so, perhaps
this is why DualHD maintain operation? I was tempted to only set alt
mode in em28xx_start_streaming if dev->board->has_dual_ts is false, but
I was not sure if there were some cases where an Isoc DualHD would fail
if alt mode were not set in em28xx_start_streaming.

Cheers,

Brad
