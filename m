Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2036 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab0KPHs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 02:48:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: Allocating videobuf_buffer, but lists not being initialized
Date: Tue, 16 Nov 2010 08:40:24 +0100
Cc: Andrew Chew <AChew@nvidia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com> <AANLkTi=HFRJpLFOCszKDMfE-_CtsQUYNoGfd6ZgfVn6U@mail.gmail.com>
In-Reply-To: <AANLkTi=HFRJpLFOCszKDMfE-_CtsQUYNoGfd6ZgfVn6U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011160840.24134.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 06:29:53 Pawel Osciak wrote:
> On Mon, Nov 15, 2010 at 17:10, Andrew Chew <AChew@nvidia.com> wrote:
> > I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).
> >
> 
> Those are not lists, but list entries. Those members of
> videobuf_buffer struct are used to put the buffer on one of the
> following lists: stream is a list entry for stream list in
> videobuf_queue, queue is used as list entry for driver's buffer queue.

So? They still should be initialized properly. It's bad form to leave
invalid pointers there.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
