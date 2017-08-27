Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55232
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751189AbdH0Kat (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 06:30:49 -0400
Date: Sun, 27 Aug 2017 07:30:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Soeren Moch <smoch@web.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20170827073040.6e96d79a@vento.lan>
In-Reply-To: <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
        <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Jul 2017 22:44:42 +0200
Soeren Moch <smoch@web.de> escreveu:

> Hi Mauro,
> 
> On 20.07.2017 07:49:36 -0300, Mauro Carvalho Chehab wrote:
> >Hi Soeren,
> >
> >Em Sun, 16 Jul 2017 20:34:23 +0200
> >Soeren Moch <smoch@xxxxxx> escreveu:
> >  
> >> This is a driver for DVB cards based on the SAA7160/62 PCIe bridges from
> >> Philips/NXP. The most important of these cards, at least for me, is the
> >> TechnoTrend S2-6400, a high-definition full-featured DVB-S2 card, the
> >> successor of the famous ttpci decoder cards. Other supported cards are:
> >> Avermedia H788
> >> Avermedia HC82 Express-54
> >> KNC One Dual S2
> >> KWorld DVB-T PE310
> >> Technisat SkyStar 2 eXpress HD
> >> Twinhan/Azurewave VP-1028
> >> Twinhan/Azurewave VP-3071
> >> Twinhan/Azurewave VP-6002
> >> Twinhan/Azurewave VP-6090
> >>
> >> The driver is taken from [1] with adaptations for current mainline,
> >> converted to git and moved to drivers/staging/media. See TODO for
> >> required cleanups (from my point of view, maybe more to come from
> >> additional code review by other developers). I added myself as driver
> >> maintainer to document my commitment to further development to get this
> >> out of staging, help from others welcome.
> >>
> >> This driver was licensed "GPL" from the beginning. S2-6400 firmware is
> >> available at [2].
> >>
> >> I want to preserve the development history of the driver, since this
> >> is mainly work of Andreas Regel, Manu Abraham, and Oliver Endriss.
> >> Unfortunately Andreas seems not to take care of this driver anymore, he
> >> also did not answer my requests to integrate patches for newer kernel
> >> versions. So I send this upstream.
> >>
> >> With all the history this is a 280 part patch series, so I send this as
> >> pull request. Of course I can also send this as 'git send-email' series
> >> if desired.  
> >
> >Even on staging, reviewing a 280 patch series take a while ;)
> >
> >As the patches that make it build with current upstream are at the
> >end of the series, you need to be sure that the saa716x Makefile
> >won't be included until those fixes get applied. It seems you took
> >care of it already, with is good!
> >
> >
> >The hole idea of adding a driver to staging is that it will be moved
> >some day out of staging. That's why a TODO and an entry at MAINTAINERS
> >is required.
> >
> >By looking at the saa716x_ff_main:
> >
> >     
> https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/media/saa716x/saa716x_ff_main.c
> >
> >I'm seeing that the main problem of this driver is that it still use
> >the API from the legacy ttpci driver, e. g. DVB audio, video and osd APIs.
> >
> >Those APIs were deprecated because they duplicate a functionality
> >provided by the V4L2 API, and are obscure, because they're not
> >properly documented. Also, no other driver uses it upstream.
> >
> >So, it was agreed several years ago that new full featured drivers
> >should use the V4L2 API for audio/video codecs.
> >
> >We have a some drivers that use V4L2 for MPEG audio/video decoding
> >and encoding. The best examples are ivtv and cx18 (as both are for
> >PCI devices). Currently, none of those drivers support the DVB
> >API, though, as they're used only on analog TV devices.
> >
> >It was also agreed that setup pipelines on more complex DVB
> >devices should use the media controller API (MC API).
> >
> >Yet, we don't have, currently, any full featured drivers upstream
> >(except for the legacy one).
> >
> >So, if we're willing to apply this driver, you should be committed
> >to do implement the media APIs properly, porting from DVB
> >audio/video/osd to V4L2 and MC APIs.
> >
> >That should also reflect its TODO:
> >
> >     
> https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/media/saa716x/TODO
> 
> Thanks for your feedback. I understand all your concerns about the legacy
> API and your request to convert this to v4l2. For me the whole story looks
> a little bit different, though.
> 
> The only application which makes use of the decoder part of this saa716x_ff
> driver is VDR (Video Disk Recorder by Klaus Schmidinger, [1] [2]) - if
> anybody else knows about a different use-case, please speak up!
> In fact the high-definition version of VDR (vdr-2.x) was co-developed with
> the S2-6400 hardware and this saa716x_ff driver. So it is no surprise, that
> this driver utilizes the - now legacy - DVB API of the ttpci cards, since
> VDR was originally developed with this API in mind. The missing API
> documentation, besides of course not being ideal, is therefore no real
> problem here, since driver and application are closely tied together.
> 
> The S2-6400 card (the only hardware which saa716x_ff supports) only has
> two simple hardware interfaces for the decoder part, a transport stream
> interface for the video/audio decoder, and a DVB API command interface
> for osd. There is no real separate DVB audio interface, audio TS packets
> are simply multiplexed into the video TS stream.
> 
> Because there are no complicated hardware interfaces or, e.g., configurable
> processing pipelines, I think a media controller driver is not applicable
> for this hardware, but a v4l2 API would be possible for the video part.

The media controller is now implemented by the DVB core. So, it costs
about nothing to make it work for the DVB part of the board.

> For
> the osd part instead I'm not really sure how to convert this. The DVB osd
> API contains several commands for window and palette management,
> pixel/line/block drawing, and even text rendering. Typical plane/framebuffer
> based overlay APIs are a very bad match for this command-based hardware
> interface. And a full-blown GPU driver only for menu overlays would be quite
> a big effort, especially as we do not need a standard command-to-image
> processing, but a gpu-command to dvb-osd-command conversion. Even now with
> the osd API command processing implemented in the S2-6400 hardware, the
> overlay is relatively slow, this could only become worse with an additional
> translation layer. But let's assume that is all solvable technically.

If I remember well, when we discussed about the OSD API, one of the
original developers said that it could be deprecated, as other APIs
replaced it. I didn't double-checked it personally, as there's no
documentation for such API, and I don't have any FF hardware.

Yet, if the other APIs are a poor match for DVB OSD API, we could revisit
the decision of deprecating this particular API. The main reason for
deprecating this API (besides the comment) is that there's no documentation,
and nobody was interested on solving the documentation issues for it.

> The real problem is not my commitment to convert the DVB video/osd API to
> v4l2. I would do it, although this means huge additional effort. My real
> concern about your request is, with converted DVB APIs in this saa716x_ff
> driver, VDR would not be able to use this driver. So the only known use-case
> would not work anymore, so the whole effort to mainline this driver would
> not make sense for me.

If support for Linux core APIs will be added for FF, applications can
start using it. I would be interested on adding support for it on
Kaffeine, if I can get one such hardware in hands and someone solve
the driver API issues.

One alternative we could do would be to add the proper APIs for the
driver and keep for a couple of Kernel versions, in staging, a module
that would provide backward compatibility to the legacy APIs. This way,
applications will have some time to add support for the new API.

If you're willing to do that, I can merge the patches.

> I agree that new drivers should use modern APIs in the general case. But
> for this driver the legacy DVB decoder API is a hard requirement for me,
> as described. So I hope you will dispense with the v4l2 conversion for
> this special case. I'm pretty sure that there will be no new hardware
> and therefore no new driver with this legacy API, this saa716x_ff driver
> also has a 7-year development history, in this sense it is not really new
> and one could also think of it as some sort of legacy code.

FF hardware is still common on embedded devices. Sooner or later support
for them will be added upstream, and applications that support it
will appear.

> If it helps, I can offer to also take maintainership for the saa7146/ttpci
> drivers, I still have such card in productive use. This way I could at
> least maintain the DVB decoder API code together, as we cannot get rid
> of it.

Drivers added to staging has a limited lifetime: either they fix
the issues or they're removed on some newer Kernel version.

> 
> If you got any better idea how to solve this "legacy issue" in a different
> way, I'm glad to help.
> 
> Regards,
> Soeren
> 
> 
> [1] www.tvdr.de
> [2] https://linuxtv.org/vdrwiki
> 



Thanks,
Mauro
