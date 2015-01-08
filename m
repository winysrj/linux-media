Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46249 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbAHMvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 07:51:31 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NHU00LO3ZWKQPA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jan 2015 12:55:32 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Cc: 'Arun Kumar K' <arun.kk@samsung.com>
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
 <54ADBE0E.5030205@collabora.com>
In-reply-to: <54ADBE0E.5030205@collabora.com>
Subject: RE: [PATCH 0/3] Various fixes for s5p-mfc driver
Date: Thu, 08 Jan 2015 13:51:28 +0100
Message-id: <009b01d02b41$d27b7800$77726800$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

I usually don't ack patches that I plan to take into my tree, but it might
be a good idea to let know the submitter that patches are good. 

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> Sent: Thursday, January 08, 2015 12:15 AM
> To: linux-media@vger.kernel.org
> Cc: Kamil Debski; Arun Kumar K
> Subject: Re: [PATCH 0/3] Various fixes for s5p-mfc driver
> 
> Just a friendly reminder that this patch is pending review ;-P
> 
> cheers,
> Nicolas
> 
> Le 2014-12-15 16:10, Nicolas Dufresne a écrit :
> > This patchset fixes ability to drain the decoder due to use of wrong
> > enumeration name and fixes implementation of display delay controls
> > for MFC firmware v6 and higher.
> >
> > Note that there is no need in the display delay fix for trying to be
> > backward compatible with what the comment was saying since the
> control
> > properties was preventing it. There was basically no way other then
> > setting a large delay value to get the frames in display order.
> >
> > Nicolas Dufresne (3):
> >    s5p-mfc-v6+: Use display_delay_enable CID
> >    s5p-mfc-dec: Don't use encoder stop command
> >    media-doc: Fix MFC display delay control doc
> >
> >   Documentation/DocBook/media/v4l/controls.xml    | 11 +++++------
> >   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  2 +-
> >   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  6 +-----
> >   3 files changed, 7 insertions(+), 12 deletions(-)
> >

