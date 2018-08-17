Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46118 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbeHRAyx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 20:54:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: chf.fritz@googlemail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>,
        Dirk Bender <D.bender@phytec.de>
Subject: Re: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
Date: Sat, 18 Aug 2018 00:50:39 +0300
Message-ID: <2371417.kFLlxrCYBz@avalon>
In-Reply-To: <7233ce5ecd19fa6942afc1d86e3a7e97f8c3d734.camel@gmail.com>
References: <1519212389.11643.13.camel@googlemail.com> <4073605.T2oYED4Iz8@avalon> <7233ce5ecd19fa6942afc1d86e3a7e97f8c3d734.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Friday, 17 August 2018 20:46:33 EEST Philipp Zabel wrote:
> Am Donnerstag, den 16.08.2018, 19:39 +0300 schrieb Laurent Pinchart:
> > Hi Christoph,
> > 
> > (Philipp, there's a question for you at the end)
> 
> > On Thursday, 16 August 2018 15:48:15 EEST Christoph Fritz wrote:
> [...]
> 
> >>                         format->fcc = dev->forced_color_format;
> >>                         format->bpp = 8;
> >>                         width_multiplier = 2;
> > 
> > bpp and multiplier are more annoying. bpp is a property of the format,
> > which we could add to the uvc_fmts array.
> > 
> > I believe the multiplier could be computed by device bpp / bpp from
> > uvc_fmts. That would work at least for the Oculus VR Positional Tracker
> > DK2, but I don't have the Oculus VR Rift Sensor descriptors to check
> > that. Philipp, if you still have access to the device, could you send
> > that to me ?
> 
> Full lsusb -v output below, the UVC descriptors are not decoded because
> bFunctionClass is set to 255. The YUY2 uncompressed format descriptor
> looks like this:
> 
>                ___guidFormat__________________________________
> 1b 24 04 01 04 59 55 59 32 00 00 10 00 80 00 00 aa 00 38 9b 71 10 01 00 00
> 00 00 ^^
> so,                                           bBitsPerPixel == 16.

Thanks a lot, that's exactly the information I needed. We can thus compute the 
multiplier with something like

        if (dev->info->pixel_format) {
                fmtdesc = uvc_format_by_fourcc(dev->info->pixel_format);
                strlcpy(format->name, fmtdesc->name,
                        sizeof(format->name));
                format->fcc = fmtdesc->fcc;
                width_multiplier = format->bpp / fmtdesc->bpp;
                format->bpp = fmtdesc->bpp;
        }

(possibly with a better name for the pixel_format field)

-- 
Regards,

Laurent Pinchart
