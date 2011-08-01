Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25971 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1HAOKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 10:10:49 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LP900DFM6202I50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Aug 2011 23:10:48 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LP900FLQ61XO2@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Aug 2011 23:10:48 +0900 (KST)
Date: Mon, 01 Aug 2011 16:10:43 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: media Documentation Errors
In-reply-to: <4E34E34E.9040200@infradead.org>
To: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Randy Dunlap' <rdunlap@xenotime.net>
Cc: linux-media@vger.kernel.org
Message-id: <001a01cc5054$cfb9d880$6f2d8980$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <20110730165133.74b91104.rdunlap@xenotime.net>
 <4E34E34E.9040200@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> 
> Hi Randy,
> 
> Em 30-07-2011 20:51, Randy Dunlap escreveu:
> > Hi,
> >
> > What do I need to do to eliminate these errors?
> > (from 3.0-git12)
> 
> Thanks for reporting it.
> 
> > Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
> > Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-
> type.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
> > Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-
> type.
> 
> This probably means that Samsung guys didn't properly documented those new
> stuff
> into the DocBook, e. g. they're defined at include/linux/videodev2.h, but
> either there's no documentation for them, or the links inside the docbook
> don't match.
> 
> Kamil?

Yes, I can confirm this and I am working on a fix. It is strange that I did not
get those errors when I did "make htmldocs".

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

