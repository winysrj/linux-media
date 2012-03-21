Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46805 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756621Ab2CUBFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 21:05:12 -0400
Subject: Re: [Q] v4l buffer format inside isoc
From: Andy Walls <awalls@md.metrocast.net>
To: Ezequiel =?ISO-8859-1?Q?Garc=EDa?= <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Tue, 20 Mar 2012 21:05:07 -0400
In-Reply-To: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1332291909.26972.3.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-03-20 at 21:05 -0300, Ezequiel García wrote:
> Hello,
> 
> I'm a little lost while writing a driver for an easycap device
> (saa7113 capture device).
> I have my isoc handler, and the isoc urb flying OK.
> I also have the videobuf2 queue setup (or at least I think so), and I understand
> I need to call vb2_buffer_done() with a filled buffer.
> 
> What I DON'T understand is how should I fill such buffer?
> I mean, what *format* comes inside the isoc buffer?
> 
> Should I look at saa7113 datasheet?

Section 8.10 of the SAA7113 data sheet shows 16 "data formats".  The
interesting one for video is #15 Y:U:V 4:2:2.

The EM28xx chip programming might rearrange some data, but I have no
knowledge or experience with the eMPIA chips.

Regards,
Andy

> Should I base in em28xx?
> 
> I'm sorry to ask such a generic question.
> Perhaps, someone cares enough to give me a hint.
> 
> Thanks,
> Ezequiel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


