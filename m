Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41133
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750923AbdIIVUV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 17:20:21 -0400
Date: Sat, 9 Sep 2017 18:20:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Soeren Moch <smoch@web.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20170909181123.392cfbb0@vento.lan>
In-Reply-To: <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
        <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
        <20170827073040.6e96d79a@vento.lan>
        <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 9 Sep 2017 14:52:18 +0200
Soeren Moch <smoch@web.de> escreveu:

> Hi Mauro,
> 
> sorry for the late reply, unfortunately your email was filtered out as spam.

I'll focus talking about saa716x/av7110 here, as this is out of of
scope of the documentation patches.

> 
> On 27.08.2017 12:30, Mauro Carvalho Chehab wrote:
> > Em Fri, 21 Jul 2017 22:44:42 +0200
> > Soeren Moch <smoch@web.de> escreveu:
> >  
> >> Hi Mauro,
> >>
> >> On 20.07.2017 07:49:36 -0300, Mauro Carvalho Chehab wrote:  
> >>> Hi Soeren,
> >>>
> >>> Em Sun, 16 Jul 2017 20:34:23 +0200
> >>> Soeren Moch <smoch@xxxxxx> escreveu:
> >>>    
> >>>> This is a driver for DVB cards based on the SAA7160/62 PCIe bridges from
> >>>> Philips/NXP. The most important of these cards, at least for me, is the
> >>>> TechnoTrend S2-6400, a high-definition full-featured DVB-S2 card, the
> >>>> successor of the famous ttpci decoder cards. Other supported cards are:
> >>>> Avermedia H788
> >>>> Avermedia HC82 Express-54
> >>>> KNC One Dual S2
> >>>> KWorld DVB-T PE310
> >>>> Technisat SkyStar 2 eXpress HD
> >>>> Twinhan/Azurewave VP-1028
> >>>> Twinhan/Azurewave VP-3071
> >>>> Twinhan/Azurewave VP-6002
> >>>> Twinhan/Azurewave VP-6090
> >>>>
> >>>> The driver is taken from [1] with adaptations for current mainline,
> >>>> converted to git and moved to drivers/staging/media. See TODO for
> >>>> required cleanups (from my point of view, maybe more to come from
> >>>> additional code review by other developers). I added myself as driver
> >>>> maintainer to document my commitment to further development to get this
> >>>> out of staging, help from others welcome.
> >>>>
> >>>> This driver was licensed "GPL" from the beginning. S2-6400 firmware is
> >>>> available at [2].
> >>>>
> >>>> I want to preserve the development history of the driver, since this
> >>>> is mainly work of Andreas Regel, Manu Abraham, and Oliver Endriss.
> >>>> Unfortunately Andreas seems not to take care of this driver anymore, he
> >>>> also did not answer my requests to integrate patches for newer kernel
> >>>> versions. So I send this upstream.
> >>>>
> >>>> With all the history this is a 280 part patch series, so I send this as
> >>>> pull request. Of course I can also send this as 'git send-email' series
> >>>> if desired.    
> >>> Even on staging, reviewing a 280 patch series take a while ;)
> >>>
> >>> As the patches that make it build with current upstream are at the
> >>> end of the series, you need to be sure that the saa716x Makefile
> >>> won't be included until those fixes get applied. It seems you took
> >>> care of it already, with is good!
> >>>
> >>>
> >>> The hole idea of adding a driver to staging is that it will be moved
> >>> some day out of staging. That's why a TODO and an entry at MAINTAINERS
> >>> is required.
> >>>
> >>> By looking at the saa716x_ff_main:
> >>>
> >>>       
> >> https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/media/saa716x/saa716x_ff_main.c  
> >>> I'm seeing that the main problem of this driver is that it still use
> >>> the API from the legacy ttpci driver, e. g. DVB audio, video and osd APIs.
> >>>
> >>> Those APIs were deprecated because they duplicate a functionality
> >>> provided by the V4L2 API, and are obscure, because they're not
> >>> properly documented. Also, no other driver uses it upstream.
> >>>
> >>> So, it was agreed several years ago that new full featured drivers
> >>> should use the V4L2 API for audio/video codecs.
> >>>
> >>> We have a some drivers that use V4L2 for MPEG audio/video decoding
> >>> and encoding. The best examples are ivtv and cx18 (as both are for
> >>> PCI devices). Currently, none of those drivers support the DVB
> >>> API, though, as they're used only on analog TV devices.
> >>>
> >>> It was also agreed that setup pipelines on more complex DVB
> >>> devices should use the media controller API (MC API).
> >>>
> >>> Yet, we don't have, currently, any full featured drivers upstream
> >>> (except for the legacy one).
> >>>
> >>> So, if we're willing to apply this driver, you should be committed
> >>> to do implement the media APIs properly, porting from DVB
> >>> audio/video/osd to V4L2 and MC APIs.
> >>>
> >>> That should also reflect its TODO:
> >>>
> >>>       
> >> https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/media/saa716x/TODO
> >>
> >> Thanks for your feedback. I understand all your concerns about the legacy
> >> API and your request to convert this to v4l2. For me the whole story looks
> >> a little bit different, though.
> >>
> >> The only application which makes use of the decoder part of this saa716x_ff
> >> driver is VDR (Video Disk Recorder by Klaus Schmidinger, [1] [2]) - if
> >> anybody else knows about a different use-case, please speak up!
> >> In fact the high-definition version of VDR (vdr-2.x) was co-developed with
> >> the S2-6400 hardware and this saa716x_ff driver. So it is no surprise, that
> >> this driver utilizes the - now legacy - DVB API of the ttpci cards, since
> >> VDR was originally developed with this API in mind. The missing API
> >> documentation, besides of course not being ideal, is therefore no real
> >> problem here, since driver and application are closely tied together.
> >>
> >> The S2-6400 card (the only hardware which saa716x_ff supports) only has
> >> two simple hardware interfaces for the decoder part, a transport stream
> >> interface for the video/audio decoder, and a DVB API command interface
> >> for osd. There is no real separate DVB audio interface, audio TS packets
> >> are simply multiplexed into the video TS stream.
> >>
> >> Because there are no complicated hardware interfaces or, e.g., configurable
> >> processing pipelines, I think a media controller driver is not applicable
> >> for this hardware, but a v4l2 API would be possible for the video part.  
> > The media controller is now implemented by the DVB core. So, it costs
> > about nothing to make it work for the DVB part of the board.  
> 
> OK, then I will add this this to the TODO list.

Thanks!

> 
> >  
> >> For
> >> the osd part instead I'm not really sure how to convert this. The DVB osd
> >> API contains several commands for window and palette management,
> >> pixel/line/block drawing, and even text rendering. Typical plane/framebuffer
> >> based overlay APIs are a very bad match for this command-based hardware
> >> interface. And a full-blown GPU driver only for menu overlays would be quite
> >> a big effort, especially as we do not need a standard command-to-image
> >> processing, but a gpu-command to dvb-osd-command conversion. Even now with
> >> the osd API command processing implemented in the S2-6400 hardware, the
> >> overlay is relatively slow, this could only become worse with an additional
> >> translation layer. But let's assume that is all solvable technically.  
> > If I remember well, when we discussed about the OSD API, one of the
> > original developers said that it could be deprecated, as other APIs
> > replaced it. I didn't double-checked it personally, as there's no
> > documentation for such API, and I don't have any FF hardware.
> >
> > Yet, if the other APIs are a poor match for DVB OSD API, we could revisit
> > the decision of deprecating this particular API. The main reason for
> > deprecating this API (besides the comment) is that there's no documentation,
> > and nobody was interested on solving the documentation issues for it.  
> 
> Maybe another topic for my TODO. But, would that really be helpful?
> The only providers of that API (ttpci and saa716x_ff) and the only user
> of it (vdr) apparently know how it is supposed to work.

The problem with audio/video/osg DVB API is that it seems that nobody
seems to know how this work, except by a couple of persons that used to
work at Convergence between 1999 to 2003, as this was never fully 
documented, nor nobody else was able to write a driver or any other
userspace application along all those years.

> You explicitly
> want to discourage new driver and application implementations. 

Me? It is just the opposite: sticking with a poorly documented API
that almost nobody knows seems to be what discouraged new drivers
and applications.

> For me
> adding new documentation would guide programmers to the opposite
> direction.
> I also see the conflict, for you this driver is new, as it should be
> merged now, for me it is seven years old. So if this driver will be
> merged, this would not change the "deprecated" status of the API. I'm
> pretty sure, there will never be another incarnation of a similar type
> of FF card.

I see your point.

> >> The real problem is not my commitment to convert the DVB video/osd API to
> >> v4l2. I would do it, although this means huge additional effort. My real
> >> concern about your request is, with converted DVB APIs in this saa716x_ff
> >> driver, VDR would not be able to use this driver. So the only known use-case
> >> would not work anymore, so the whole effort to mainline this driver would
> >> not make sense for me.  
> > If support for Linux core APIs will be added for FF, applications can
> > start using it. I would be interested on adding support for it on
> > Kaffeine, if I can get one such hardware in hands and someone solve
> > the driver API issues.  
> 
> With linux core APIs for FF you probably mean some new
> API combination as successor of the audio/video/osd API.
> The S2-6400 unfortunately directly implements the old API
> in hardware and is therefore the worst possible match for
> such new driver generation.

It sounds weird that the API is directly implemented in hardware.
I can't tell much, though, as I didn't see the code yet.

> For the new API I asked in the other thread [1].

Basically, for a simple FF card that has its own HDMI output and don't
have ways to customize its pipelines (e. g. it is not a nowadays DVB
embedded hardware), you could use DVB frontend/demux APIs + V4L2 API + OSD.

The V4L2 API has enough to control video codecs. There are some examples
about how to do that for ivtv and cx18 drivers. Also, nowadays, several
HDMI drivers got written for it (with both HDMI capture and output).

The V4L2 API has support for lots of HDMI features, including the
ones needed to detect the attached monitor and parse EDID information.

The only missing feature with that is OSD. 

V4L2 currently doesn't have support yet for OSD. It shouldn't be hard
to add support for OSD on it, via V4L2 controls, but, provided that
it gets documented and makes sense for more complex FF hardware, I don't
see why not use the DVB OSD API for such purpose.

> I bought my card at dvbshop.net. It was offered there until several
> month ago and seems to be sold out now.

If you're willing to do the right thing with the driver, I'll try to buy
one and see how to add support for it on Kaffeine with the proper APIs.

> > One alternative we could do would be to add the proper APIs for the
> > driver and keep for a couple of Kernel versions, in staging, a module
> > that would provide backward compatibility to the legacy APIs. This way,
> > applications will have some time to add support for the new API.
> >
> > If you're willing to do that, I can merge the patches.  
> 
> Here I do not understand what you expect me to do. The audio/video/osd
> devices are closely tied together (as frontend/demux/dvr are for the
> input side). The S2-6400 card expects an transport stream with audio and
> video packets to be written to that video device (the audio device is
> not used) and commands  for overlay text/graphics over the osd device.

There are two options here:

1) if the hardware itself allows to direct a filtered MPEG-TS to the demod,
   by hardware, instead of reading it from /dev/dvb/.../dvr and writing it
   to /dev/dvb.../video, you could use the Media Controller to
   direct the video PID to the video decoder hardware directly;

   The V4L2 driver device node (let's say, /dev/video0) will just
   implement the HDMI output.

2) if there's no hardware pipelines between the demux and the decoders,
   userspace will read video from .../dvr and write it to a /dev/video0
   capture device node, implemented by a mem2mem V4L2 driver.

   The mem2mem output device node (let's say, /dev/video1) will control
   the HDMI output.

> The osd part you considered to keep as-is. There is no general video
> output possible as over a DRM device, there is no GPU processing
> possible, and there is no API for video decoding as in a general v4l2
> decoder device. This card's decoder only implements exactly the DVB
> video and osd devices in hardware (well, card firmware I guess, as
> hobbyist programmer I have no access to that), with this somewhat
> strange mix of audio and video (for the card it is not strange, as audio
> and video are always mux'ed in DVB streams).
> 
> >> I agree that new drivers should use modern APIs in the general case. But
> >> for this driver the legacy DVB decoder API is a hard requirement for me,
> >> as described. So I hope you will dispense with the v4l2 conversion for
> >> this special case. I'm pretty sure that there will be no new hardware
> >> and therefore no new driver with this legacy API, this saa716x_ff driver
> >> also has a 7-year development history, in this sense it is not really new
> >> and one could also think of it as some sort of legacy code.  
> > FF hardware is still common on embedded devices. Sooner or later support
> > for them will be added upstream, and applications that support it
> > will appear.  
> 
> Yes, I would really like to get the same functionality as with S2-6400
> on modern SoCs (i.MX6Q, Allwinner H5, meson-gxbb Amlogic S905,...)
> with modern APIs, in an uniform way, see the other thread.

They likely need a lot more, as modern SoC may have lots of IP
blocks to control (multiple inputs, scalers, mpeg encoding, etc). By
adding MC support, the gaps can be fulfilled.

> The goal with this driver submission is not to attract new users
> (this will probably not happen, since the S2-6400 seems to be only
> available second-hand nowadays) or to encourage application
> developers to support this hardware (it was specifically designed
> for vdr). My goal is to maintain this driver in mainline to ease
> access for existing users, who want to use this driver with new
> kernel versions. I got several such requests. An additional side
> effect would be to bring support for other hardware (in which
> I'm not interested personally) with the saa716x bridge to mainline.
> I already received patches from other users to support more
> cards in response to this pull request (not on linux-media-mailing-list).
> 
> So I hope you will pull this driver without too many change requests.
> 
> >  
> >> If it helps, I can offer to also take maintainership for the saa7146/ttpci
> >> drivers, I still have such card in productive use. This way I could at
> >> least maintain the DVB decoder API code together, as we cannot get rid
> >> of it.  
> > Drivers added to staging has a limited lifetime: either they fix
> > the issues or they're removed on some newer Kernel version.  
> 
> That's clear.
> 
> Regards,
> Soeren
> 
> [1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg118598.html
> 
> >> If you got any better idea how to solve this "legacy issue" in a different
> >> way, I'm glad to help.
> >>
> >> Regards,
> >> Soeren
> >>
> >>
> >> [1] www.tvdr.de
> >> [2] https://linuxtv.org/vdrwiki
> >>  
> >
> >
> > Thanks,
> > Mauro  
> 
> 



Thanks,
Mauro
