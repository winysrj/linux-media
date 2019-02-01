Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7245C169C4
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 02:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE7C920863
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 02:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfBACrG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 21:47:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:42503 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfBACrG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 21:47:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2019 18:47:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,546,1539673200"; 
   d="scan'208";a="315395572"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2019 18:47:04 -0800
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 31 Jan 2019 18:47:04 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.139) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 31 Jan 2019 18:47:04 -0800
Date:   Thu, 31 Jan 2019 18:29:03 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
CC:     <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH] media: v4l2-tpg: Fix the memory layout of AYUV buffers
Message-ID: <20190131182903.08f28cd9@vkasired-desk2.fm.intel.com>
In-Reply-To: <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
References: <20190129023222.10036-1-vivek.kasireddy@intel.com>
        <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
X-Mailer: Claws Mail 3.15.1-dirty (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.22.254.139]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 31 Jan 2019 14:36:42 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

Hi Hans,

> Hi Vivek,
> 
> On 1/29/19 3:32 AM, Vivek Kasireddy wrote:
> > From: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
> > 
> > The memory layout of AYUV buffers (V4L2_PIX_FMT_YUV32) should be
> > similar to V4L2_PIX_FMT_ABGR32 instead of V4L2_PIX_FMT_ARGB32.
> > 
> > While displaying the packed AYUV buffers generated by the Vivid
> > driver using v4l2-tpg on Weston, it was observed that these AYUV
> > images were not getting displayed correctly. Changing the memory
> > layout makes them display as expected.  
> 
> Our YUV32 fourcc is defined as follows:
> 
> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-packed-yuv.html
> 
> As far as I see the format that the TPG generates is according to the
> V4L2 spec.

I looked into the above link, and I am now wondering whether YUV32 is
the same as the format referred to as AYUV here or not:

https://docs.microsoft.com/en-us/windows/desktop/medfound/recommended-8-bit-yuv-formats-for-video-rendering#ayuv

If YUV32 is not the same as AYUV, should I send another patch adding a
new format named AYUV with the reversed memory layout?

> 
> Philipp, can you check the YUV32 format that the imx-pxp driver uses?
> Is that according to our spec?
> 
> At some point we probably want to add a VUY32 format which is what
> Weston expects, but we certainly cannot change what the TPG generates
> for YUV32 since that is correct.
Weston does not know much about the details of pixel formats and
instead relies on the Mesa i965 DRI driver to do the heavy lifting.
And, this driver implemented AYUV support looking at the above Microsoft
link. Also, is the description of V4l pixel formats mentioned in the
below link accurate:
https://afrantzis.com/pixel-format-guide/v4l2.html

Thanks,
Vivek

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > ---
> >  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> > b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c index
> > d9a590ae7545..825667f67c92 100644 ---
> > a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c +++
> > b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c @@ -1269,7 +1269,6
> > @@ static void gen_twopix(struct tpg_data *tpg, case
> > V4L2_PIX_FMT_HSV32: alpha = 0;
> >  		/* fall through */
> > -	case V4L2_PIX_FMT_YUV32:
> >  	case V4L2_PIX_FMT_ARGB32:
> >  		buf[0][offset] = alpha;
> >  		buf[0][offset + 1] = r_y_h;
> > @@ -1280,6 +1279,7 @@ static void gen_twopix(struct tpg_data *tpg,
> >  	case V4L2_PIX_FMT_XBGR32:
> >  		alpha = 0;
> >  		/* fall through */
> > +	case V4L2_PIX_FMT_YUV32:
> >  	case V4L2_PIX_FMT_ABGR32:
> >  		buf[0][offset] = b_v;
> >  		buf[0][offset + 1] = g_u_s;
> >   
> 

