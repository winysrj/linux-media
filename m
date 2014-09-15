Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43768 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaIOON4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 10:13:56 -0400
Received: by mail-oa0-f43.google.com with SMTP id m19so2577577oag.2
        for <linux-media@vger.kernel.org>; Mon, 15 Sep 2014 07:13:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410442019.4011.63.camel@paszta.hi.pengutronix.de>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>
 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
 <1407153257.3979.30.camel@paszta.hi.pengutronix.de> <CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com>
 <53FDE9E1.2000108@mentor.com> <CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>
 <540F26E5.50609@gmail.com> <1410284421.3353.47.camel@paszta.hi.pengutronix.de>
 <5410F80F.5060803@mentor.com> <1410442019.4011.63.camel@paszta.hi.pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 15 Sep 2014 16:13:39 +0200
Message-ID: <CAL8zT=ix-Vf2s5Lu8+niAKzdZ19TwsyTMmv8Cqt0Friqd4sYZw@mail.gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-09-11 15:26 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Steve,
>
> Am Mittwoch, den 10.09.2014, 18:17 -0700 schrieb Steve Longerbeam:
> [...]
>> On 09/09/2014 10:40 AM, Philipp Zabel wrote:
> [...]
>> >  I have in the meantime started to
>> > implement everything that has a source or destination selector in the
>> > Frame Synchronization Unit (FSU) as media entity. I wonder which of
>> > these parts should reasonably be unified into a single entity:
> [...]
>> >     SMFC0
>> >     SMFC1
>> >     SMFC2
>> >     SMFC3
>>
>> I don't really see the need for an SMFC entity. The SMFC control can
>> be integrated into the CSI subdev.
>
> Granted, this is currently is a theoretical question, but could we
> handle a single MIPI link that carries two or more virtual channels with
> different MIPI IDs this way?
>
>> >     IC preprocessor (input to VF and ENC, if I understood correctly)
>> >     IC viewfinder task (scaling, csc)
>> >     IC encoding task
>> >     IC post processing task
>>
>> I see either three different IC subdev entities (IC prpenc, IC prpvf,
>> IC pp), or a single IC entity with three sink pads for each IC task.
>
> The former could work, the latter won't allow to have pre and post
> processing on separate pipelines.
>
>> >     IRT viewfinder task (rotation)
>> >     IRT encoding task
>> >     IRT post processing task
>>
>> well, the IRT is really just a submodule enable bit, I see no need
>> for an IRT subdev, in fact IRT has already been folded into ipu-ic.c
>> as a simple submodule enable/disable. Rotation support can be
>> implemented as part of the IC entities.
>
> My current understanding is that the IRT is strictly a mem2mem device
> using its own DMA channels, which can be channel-linked to the IC (and
> other blocks) in various ways.
>
>> >     VDIC (deinterlacing, combining)
>>
>> I am thinking VDIC support can be part of the IC prpvf entity (well,
>> combining is not really on my radar, I haven't given that much thought).
>>
>> >     (and probably some entry for DP/DC/DMFC for the direct
>> >      viewfinder path)
>>
>> Ugh, I've been ignoring that path as well. Freescale's BSP releases
>> and sample code from their SDK's have no example code for the
>> direct-to-DP/DC/DMFC camera viewfinder path, so given the quality
>> of the imx TRM, this could be a challenge to implement. Have you
>> gotten this path to work?
>
> Not yet, no.
>
>> > I suppose the SMFC channels need to be separate because they can belong
>> > to different pipelines (and each entity can only belong to one).
>>
>> I see the chosen SMFC channel as an internal decision by the
>> CSI subdev.
>
> Can we handle multiple outputs from a single CSI this way?
>
>> > The three IC task entities could probably be combined with their
>> > corresponding IRT task entity somehow, but that would be at the cost of
>> > not being able to tell the kernel whether to rotate before or after
>> > scaling, which might be useful when handling chroma subsampled formats.
>>
>> I'm fairly sure IC rotation must always occur _after_ scaling. I.e.
>> raw frames are first passed through IC prpenc/prpvf/pp for scaling/CSC,
>> then EOF completion of that task is hardware linked to IRT.
>
> There could be good reasons to do the rotation on the input side, for
> example when upscaling or when the output is 4:2:2 subsampled. At least
> the FSU registers suggest that channel linking the rotator before the IC
> is possible. This probably won't be useful for the capture path in most
> cases, but it might be for rotated playback.
>
>> > I have put my current state up here:
>> >
>> > git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media
>> >
>> > So far I've captured video through the SMFC on a Nitrogen6X board with
>> > OV5652 parallel camera with this.
>>
>> Thanks Phillip, I'll take a look! Sounds like a good place to start.
>> I assume this is with the video mux entity and CSI driver? I.e. no
>> IC entity support yet for scaling, CSC, or rotation.
>
> Yes, exactly.

I have tried both of your branches (Steve and Philip) and they both
are interesting.
I easily added adv76xx devices to Steve's work, but there is no media
controller support, as you previously said.
I cannot get adv7611 working on Philip's branch. I tried to do the
same as your "add OV5642 parallel camera" commit, but I don't see a
link between csi and adv even though I asked for it in DT (I removed
not useful stuff in the following paste) :

&i2c2 {
    hdmiin1: adv7611@4c {
            port {
                    hdmi0_out: endpoint@1 {
                            reg = <1>;
                            remote_endpoint = <&csi0_from_adv7611>;
                    };
    };
};

&csi0 {
        csi0_from_adv7611: endpoint {
                remote_endpoint = <&hdmi0_out>;
        };
};

Is there something specific that needs to be done in order to get the
link on boot ?

Even if this is still WIP, this is great, it helps me a lot :) !
Thanks,
JM
