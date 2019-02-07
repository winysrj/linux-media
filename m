Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536B4C169C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 02:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B2BC217F9
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 02:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfBGCPd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 21:15:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:28144 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfBGCPd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 21:15:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2019 18:15:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,342,1544515200"; 
   d="scan'208";a="131681397"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Feb 2019 18:15:31 -0800
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 6 Feb 2019 18:15:32 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.138) by
 ORSMSX157.amr.corp.intel.com (10.22.240.23) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 6 Feb 2019 18:15:31 -0800
Date:   Wed, 6 Feb 2019 17:57:44 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
CC:     Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: v4l2-tpg: Fix the memory layout of AYUV buffers
Message-ID: <20190206175744.1dde5fd9@vkasired-desk2.fm.intel.com>
In-Reply-To: <c7aaec9c-2660-1d60-5bab-704b812ea01c@xs4all.nl>
References: <20190129023222.10036-1-vivek.kasireddy@intel.com>
        <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
        <1549377502.3929.12.camel@pengutronix.de>
        <c7aaec9c-2660-1d60-5bab-704b812ea01c@xs4all.nl>
X-Mailer: Claws Mail 3.15.1-dirty (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.22.254.138]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 6 Feb 2019 11:46:21 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:
Hi Hans,

> On 2/5/19 3:38 PM, Philipp Zabel wrote:
> > Hi Hans,
> > 
> > On Thu, 2019-01-31 at 14:36 +0100, Hans Verkuil wrote:
> > [...]  
> >>
> >> Our YUV32 fourcc is defined as follows:
> >>
> >> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-packed-yuv.html
> >>
> >> As far as I see the format that the TPG generates is according to
> >> the V4L2 spec.
> >>
> >> Philipp, can you check the YUV32 format that the imx-pxp driver
> >> uses? Is that according to our spec?
> >>
> >> At some point we probably want to add a VUY32 format which is what
> >> Weston expects, but we certainly cannot change what the TPG
> >> generates for YUV32 since that is correct.  
> > 
> > I hadn't noticed as YUV32 doesn't show up in GStreamer, but testing
> > with v4l2-ctl, it seems to be incorrect. This script:
> > 
> >   #!/bin/sh
> >   function check() {
> >       PATTERN="$1"
> >       NAME="$2"
> >       echo -ne "${NAME}:\t"
> >       v4l2-ctl \
> >           --set-fmt-video-out=width=8,height=8,pixelformat=RGBP \
> >           --set-fmt-video=width=8,height=8,pixelformat=YUV4 \
> >           --stream-count 1 \
> >           --stream-poll \
> >           --stream-out-pattern "${PATTERN}" \
> >           --stream-out-mmap 3 \
> >           --stream-mmap 3 \
> >           --stream-to - 2>/dev/null | hexdump -v -n4 -e '/1 "%02x "'
> >       echo
> >   }
> >   check 6 "100% white"
> >   check 7 "100% red"
> >   check 9 "100% blue"
> > 
> > results in the following output:
> > 
> >   100% white:	80 80 ea ff 
> >   100% red:	f0 66 3e ff 
> >   100% blue:	74 f0 23 ff 
> > 
> > That looks like 32-bit VUYA 8-8-8-8.  
> 
> Right. So Vivek, can you make the patches to add a proper VUYA
> pixelformat?
Sure, let me send the patches soon.
> 
> And a final patch updating imx-pxp so it uses the right pixelformat?
Ok, will do.

Thanks,
Vivek

> 
> Since there is now a driver using it, it is also not a problem
> anymore to get the new pixelformat patches merged.
> 
> Regards,
> 
> 	Hans

