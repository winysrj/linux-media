Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:60206 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2LRGNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 01:13:09 -0500
Received: by mail-yh0-f45.google.com with SMTP id p34so43401yhp.32
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 22:13:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD025yQoCiNaKvaCwvUWhk_jV70CPhV35UzV9MR6HtE+1baCxg@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CAD025yS5rGMbiRBdDxv=YLP6_fsQndAkr+3t29_mNhcvow_SwA@mail.gmail.com>
	<3133576.BkqAl7V01U@avalon>
	<CAD025yQoCiNaKvaCwvUWhk_jV70CPhV35UzV9MR6HtE+1baCxg@mail.gmail.com>
Date: Tue, 18 Dec 2012 11:43:08 +0530
Message-ID: <CAD025yTK6pBHR41hqPQAXHcDhB7s6OE-Z1nHPF0DU1WbBiEXaw@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On 17 December 2012 20:55, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Vikas,
>
> Sorry for the late reply. I now have more time to work on CDF, so delays
> should be much shorter.
>
> On Thursday 06 December 2012 10:51:15 Vikas Sajjan wrote:
> > Hi Laurent,
> >
> > I was thinking of porting CDF to samsung EXYNOS 5250 platform, what I found
> > is that, the exynos display controller is MIPI DSI based controller.
> >
> > But if I look at CDF patches, it has only support for MIPI DBI based Display
> > controller.
> >
> > So my question is, do we have any generic framework for MIPI DSI based
> > display controller? basically I wanted to know, how to go about porting CDF
> > for such kind of display controller.
>
> MIPI DSI support is not available yet. The only reason for that is that I
> don't have any MIPI DSI hardware to write and test the code with :-)
>
> The common display framework should definitely support MIPI DSI. I think the
> existing MIPI DBI code could be used as a base, so the implementation
> shouldn't be too high.
>
Yeah, i was also thinking in similar lines, below is my though for
MIPI DSI support in CDF.

o   MIPI DSI support as part of CDF framework will expose

    > mipi_dsi_register_device(mpi_device) (will be called mach-xxx-dt.c file )

   > mipi_dsi_register_driver(mipi_driver, bus ops) (will be called
from platform specific init driver call )

·       bus ops will be
     o   read data
     o   write data
     o   write command

>  MIPI DSI will be registered as bus_register()

When MIPI DSI probe is called, it (e.g., Exynos or OMAP MIPI DSI) will
initialize the MIPI DSI HW IP.

 This probe will also parse the DT file for MIPI DSI based panel, add
the panel device (device_add() ) to kernel and register the display
entity with its control and  video ops with CDF.
>
> I can give this a try. Does the existing Exynos 5250 driver support MIPI DSI ?
> Is the device documentation publicly available ? Can you point me to a MIPI
> DSI panel with public documentation (preferably with an existing mainline
> driver if possible) ?
>
 yeah, existing Exynos 5250 driver support MIPI DSI ass well as eDP.
 i think device documentation is NOT available publicly.

> --
> Regards,
>
> Laurent Pinchart
>

-- 
Thanks and Regards
 Vikas Sajjan
