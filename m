Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58477 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaAIUeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 15:34:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: florian.vaussard@epfl.ch
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: Regression inside omap3isp/resizer
Date: Thu, 09 Jan 2014 21:34:57 +0100
Message-ID: <1530474.IjFu1Njy3V@avalon>
In-Reply-To: <52CEE5EC.3050704@epfl.ch>
References: <52B02A7A.4010901@epfl.ch> <5578156.0MrbcJaUWJ@avalon> <52CEE5EC.3050704@epfl.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Thursday 09 January 2014 19:09:48 Florian Vaussard wrote:
> On 12/31/2013 09:51 AM, Laurent Pinchart wrote:
> > Hi Florian,
> > 
> > Sorry for the late reply.
> 
> Now it is my turn to be late.
> 
> > On Monday 23 December 2013 22:47:45 Florian Vaussard wrote:
> >> On 12/17/2013 11:42 AM, Florian Vaussard wrote:
> >>> Hello Laurent,
> >>> 
> >>> I was working on having a functional IOMMU/ISP for 3.14, and had an
> >>> issue with an image completely distorted. Comparing with another kernel,
> >>> I saw that PRV_HORZ_INFO and PRV_VERT_INFO differed. On the newer
> >>> kernel, sph, eph, svl, and slv were all off-by 2, causing my final image
> >>> to miss 4 pixels on each line, thus distorting the result.
> >>> 
> >>> Your commit 3fdfedaaa7f243f3347084231c64f6c1be0ba131 '[media] omap3isp:
> >>> preview: Lower the crop margins' indeed changes PRV_HORZ_INFO and
> >>> PRV_VERT_INFO by removing the if() condition. Reverting it made my image
> >>> to be valid again.
> >>> 
> >>> FYI, my pipeline is:
> >>> 
> >>> MT9V032 (SGRBG10 752x480) -> CCDC -> PREVIEW (UYVY 752x480) -> RESIZER
> >>> -> out
> >> 
> >> Just an XMAS ping on this :-) Do you have any idea how to solve this
> >> without reverting the patch?
> > 
> > The patch indeed changed the preview engine margins, but the change is
> > supposed to be handled by applications. As a base for this discussion
> > could you please provide the media-ctl -p output before and after applying
> > the patch ? You can strip the unrelated media entities out of the output.
> 
> Ok, so I understand the rationale behind this patch, but I am a bit
> concerned. If this patch requires a change in userspace, this is somehow
> breaking the userspace, isn't? For example in my case, I will have to
> change my initialization scripts in order to pass the correct resolution
> to the pipeline. Most people have probably hard-coded the resolution
> into their script / application.

But they shouldn't have. This has never been considered as an ABI. Userspace 
needs to computes and propagates resolutions through the pipeline dynamically, 
no hardcode them.

If your initialization script read the kernel version and aborted for any 
version other than v3.6, an upgrade to a newer kernel would break the system 
but you wouldn't call it a kernel regression :-)

Problems with pipeline configuration shouldn't result in distorted images 
though. The driver is supposed to refuse to start streaming when the pipeline 
is misconfigured by making sure that resolutions on connected source and sink 
pads are identical. A valid pipeline should not distort the image.

After a quick look at the code the problem we're dealing with seems to be 
different and shouldn't affect userspace scripts if solved properly. I haven't 
touched the preview engine crop configuration code for some time now, so I'll 
need to refresh my memory, but it seems that the removal of

-       if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
-           format->code != V4L2_MBUS_FMT_Y10_1X10) {
-               sph -= 2;
-               eph += 2;
-               slv -= 2;
-               elv += 2;
-       }

was wrong. The change to the margins and to preview_try_crop() seem correct, 
but the preview_config_input_size() function should probably have been kept 
unmodified. Could you please test reverting that part of the patch only ?

Sakari, if you have time, could you please have a look at the code and give me 
your opinion ?

> For example, with the current Gumstix Overo, most people are using the 3.6,
> which is the latest officially supported. I saw a number of them fighting to
> get a working pipeline. So when they will update to a 3.10+, their
> application will stop working correctly, and a big number of the users will
> have a hard time figuring out that they will have to update the pipeline's
> configuration to get back an image.
>
> The result of meida-ctl -p in the same with and without the patch applied,
> as the same script is calling media-ctl at startup to configure the
> pipeline. Stripped-down and ordered (camera -> output) result is coming
> below. Obviously the configuration should be updated when the patch is
> applied.
> 
> Best regards,
> 
> Florian
> 
> - entity 16: mt9v032 2-005c (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev8
> 	pad0: Output [SGRBG10 752x480 (1,5)/752x480]
> 		-> 'OMAP3 ISP CCDC':pad0 [ACTIVE]
> 
> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev2
> 	pad0: Input [SGRBG10 752x480]
> 		<- 'mt9v032 2-005c':pad0 [ACTIVE]
> 	pad2: Output [SGRBG10 752x479]
> 		-> 'OMAP3 ISP preview':pad0 [ACTIVE]
> 
> - entity 7: OMAP3 ISP preview (2 pads, 4 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev3
> 	pad0: Input [SGRBG10 752x479 (10,4)/734x471]
> 		<- 'OMAP3 ISP CCDC':pad2 [ACTIVE]
> 	pad1: Output [UYVY 734x471]
> 		-> 'OMAP3 ISP resizer':pad0 [ACTIVE]
> 
> - entity 10: OMAP3 ISP resizer (2 pads, 4 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev4
> 	pad0: Input [UYVY 734x471 (0,0)/734x471]
> 		<- 'OMAP3 ISP preview':pad1 [ACTIVE]
> 	pad1: Output [UYVY 752x480]
> 		-> 'OMAP3 ISP resizer output':pad0 [ACTIVE]
> 
> - entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video6
> 	pad0: Input
> 		<- 'OMAP3 ISP resizer':pad1 [ACTIVE]
-- 
Regards,

Laurent Pinchart

