Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F2EC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA8E320685
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="cHmFNrjt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfAHP5s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:57:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:58758 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbfAHP5r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 10:57:47 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E61E6586;
        Tue,  8 Jan 2019 16:57:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546963066;
        bh=ce29x9J9occub7Z5m1K88/nS0zLDK7ak4oGJ++JKwp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHmFNrjt7FVo1Th884K//Cab98ynNScB0R1FAjpKrjj4JD/W2/16qluzksZbkq/Su
         W7nPvG6oM7vRH5FUDAB2sMmKLkV9XFAkwC/FBhwL2K8v6yPg9GOxM8UK3UH+qom3/I
         GjOUL38vdN3KomrWJjin4kL0CHurOcfrwNzObrGc=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I start capture video
Date:   Tue, 08 Jan 2019 17:58:54 +0200
Message-ID: <32231660.SI74LuYRbz@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com> <386743082.UsI2JZZ8BA@avalon> <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mikhail,

On Tuesday, 8 January 2019 17:18:15 EET Mikhail Gavrilov wrote:
> On Tue, 8 Jan 2019 at 19:53, Laurent Pinchart
> 
> <laurent.pinchart@ideasonboard.com> wrote:
> > Mikhail, could you please post the output of
> > 
> > lsusb -v -d 07ca:0553
> > 
> > if possible running as root ?
> 
> yes, attached here.

Thank you.

Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12, P010 and 
BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo driver except 
for the P010 format. This would be easy to fix in the uvcvideo driver if it 
wasn't for the fact that the P010 format isn't support by V4L2. Adding support 
for it isn't difficult, but I don't have time to do this myself at the moment. 
Would you consider volunteering if I guide you ? :-)

-- 
Regards,

Laurent Pinchart



