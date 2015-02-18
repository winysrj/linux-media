Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22281 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbbBRKb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 05:31:27 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NJY004E0QR2HJ70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Feb 2015 10:35:26 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	nicolas.dufresne@collabora.com, posciak@chromium.org
References: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
 <54E305AC.6050103@xs4all.nl>
 <000001d04b5f$30a4afe0$91ee0fa0$%debski@samsung.com> <54E4623F.70902@xs4all.nl>
In-reply-to: <54E4623F.70902@xs4all.nl>
Subject: RE: [PATCH 1/2] vb2: Add VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag to
 vb2_fileio_flags
Date: Wed, 18 Feb 2015 11:31:23 +0100
Message-id: <000101d04b66$0b715af0$225410d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Wednesday, February 18, 2015 10:58 AM
> 
> On 02/18/15 10:42, Kamil Debski wrote:
> > Hi Hans,
> >
> >> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> >> Sent: Tuesday, February 17, 2015 10:11 AM
> >>
> >> Hi Kamil,
> >>
> >> On 12/16/14 12:36, Kamil Debski wrote:
> >>> The vb2: fix bytesused == 0 handling (8a75ffb) patch changed the
> >>> behavior of __fill_vb2_buffer function, so that if bytesused is 0
> it
> >>> is set to the size of the buffer. However, bytesused set to 0 is
> >>> used by older codec drivers as as indication used to mark the end
> of
> >> stream.
> >>>
> >>> To keep backward compatibility, this patch adds a flag passed to
> the
> >>> vb2_queue_init function - VB2_FILEIO_ALLOW_ZERO_BYTESUSED. If the
> >> flag
> >>> is set upon initialization of the queue, the videobuf2 keeps the
> >> value
> >>> of bytesused intact and passes it to the driver.
> >>
> >> What is the status of this patch series?
> >
> > I have to admit that I had forgotten a bit about this patch, because
> > of other important work. Thanks for reminding me :)
> >
> >> Note that io_flags is really the wrong place for this flag, it
> should
> >> be io_modes. This flag has nothing to do with file I/O.
> >
> > What do you think about adding a separate flags field into the
> > vb2_queue structure? This could be combined with changing io_flags to
> > u8 or a bit field to save space.
> 
> I think changing io_flags to a bitfield is a good idea.
> 
> 	unsigned fileio_read_once:1;
> 	unsigned fileio_write_immediately:1;
> 	unsigned allow_zero_bytesused:1;
> 
> However, going back to allow_zero_bytesused: this has been broken for
> quite some time without anyone complaining (other than you :-) ). 

If I remember correctly, it was Nicolas who reported to me the problem 
on the IRC.

> Might
> it not be better to just fix this properly by calling
> V4L2_DEC_CMD_STOP, as done here: https://www.mail-archive.com/linux-
> media@vger.kernel.org/msg84916.html,
> and drop the support for zero bytesused to mark EOS entirely?

I think it would be good to have the backward compatibility for some time.

> I might be too optimistic here. Or perhaps at least add a pr_warn
> telling users to switch to V4L2_DEC_CMD_STOP since this will be removed
> in 2017 or whatever.

Where do you see the pr_warn? I guess it would be good if it was only
displayed once and only when the app uses bytesused == 0 to signal the
EOS. Do you think alike?


> 
> Regards,
> 
> 	Hans

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

