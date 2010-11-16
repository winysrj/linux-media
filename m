Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64330 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab0KPFaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 00:30:15 -0500
Received: by wyb28 with SMTP id 28so308275wyb.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 21:30:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com>
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 15 Nov 2010 21:29:53 -0800
Message-ID: <AANLkTi=HFRJpLFOCszKDMfE-_CtsQUYNoGfd6ZgfVn6U@mail.gmail.com>
Subject: Re: Allocating videobuf_buffer, but lists not being initialized
To: Andrew Chew <AChew@nvidia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Nov 15, 2010 at 17:10, Andrew Chew <AChew@nvidia.com> wrote:
> I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).
>

Those are not lists, but list entries. Those members of
videobuf_buffer struct are used to put the buffer on one of the
following lists: stream is a list entry for stream list in
videobuf_queue, queue is used as list entry for driver's buffer queue.

-- 
Best regards,
Pawel Osciak
