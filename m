Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33185 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751459AbdAaSVk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 13:21:40 -0500
Subject: Re: [PATCH v3 20/24] media: imx: Add Camera Interface subdev driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
 <b7456d40-040d-41b7-45bc-ef6709ab7933@xs4all.nl>
 <20170131134252.GX27312@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b0517394-7717-3e1d-b850-e2b69a9c19e9@gmail.com>
Date: Tue, 31 Jan 2017 10:21:26 -0800
MIME-Version: 1.0
In-Reply-To: <20170131134252.GX27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/31/2017 05:42 AM, Russell King - ARM Linux wrote:
> On Fri, Jan 20, 2017 at 03:38:28PM +0100, Hans Verkuil wrote:
>> Should be set to something like 'platform:imx-media-camif'. v4l2-compliance
>> should complain about this.
> ... and more.

Right, in version 3 that you are working with, no v4l2-compliance fixes were
in yet. A lot of the compliance errors are fixed, please look in latest 
branch
imx-media-staging-md-wip at git@github.com:slongerbeam/mediatree.git.


<snip>
>
>
>
> Total: 39, Succeeded: 33, Failed: 6, Warnings: 0
>
> Not all of these may be a result of Steve's code - this is running against
> my gradually modified version to support bayer formats (which seems to be
> the cause of the v4l2-test-formats.cpp failure... for some reason the
> driver isn't enumerating all the formats.)
>
> And that reason is the way that the formats are enumerated:
>
> static int camif_enum_fmt_vid_cap(struct file *file, void *fh,
>                                    struct v4l2_fmtdesc *f)
> {
>          const struct imx_media_pixfmt *cc;
>          u32 code;
>          int ret;
>
>          ret = imx_media_enum_format(&code, f->index, true, true);
>          if (ret)
>                  return ret;
>          cc = imx_media_find_format(0, code, true, true);
>          if (!cc)
>                  return -EINVAL;
>
> When imx_media_enum_format() hits this entry in the table:
>
>          }, {
>                  .fourcc = V4L2_PIX_FMT_BGR24,
>                  .cs     = IPUV3_COLORSPACE_RGB,
>                  .bpp    = 24,
>          }, {
>
> becaues there's no .codes defined:
>
> int imx_media_enum_format(u32 *code, u32 index, bool allow_rgb,
>                            bool allow_planar)
> {
> ...
>          *code = fmt->codes[0];
>          return 0;
> }
>
> So, we end up calling imx_media_find_format(0, 0, true, true), which
> fails, returning NULL.  That causes camif_enum_fmt_vid_cap() to
> return -EINVAL.
>
> So everything past this entry is unable to be enumerated.
>
> I think this is a really round-about way of enumerating the pixel
> formats when there are soo many entries in the table which have no
> media bus code - there's absolutely no way that any of those entries
> can ever be enumerated in this fashion, so they might as well not be
> in the table...
>
> That's my present solution to this problem, to #if 0 out all the
> entries without any .codes field.  I think the real answer is that
> this needs a _separate_ function to enumerate the pixel formats for
> camif_enum_fmt_vid_cap().  However, there may be other issues lurking
> that I've not yet found (still trying to get this code to work...)

I believe this has been fixed in imx-media-staging-md-wip as well,
see imx-media-capture.c:capture_enum_fmt_vid_cap()

Camif subdev is gone, replaced with a set of exported functions
that allow attaching a capture device (and v4l2 interface) to a
calling subdev's output pad. See imx-media-capture.c.

The subdev's capture device interface is the only subdev that
can request a planar format from imx_media_enum_format().
All the others now (the non-device node pads), request only RGB
or packed YUV, or the IPU internal formats for IPU internal connections,
and these are the first entries in the table. The planar formats all are at
the end, which can only be enumerated by the capture device interfaces.

Steve

