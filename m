Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:56368 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2CUIBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 04:01:49 -0400
Date: Wed, 21 Mar 2012 09:01:59 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Ezequiel =?UTF-8?B?R2FyY8OtYQ==?= <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [Q] v4l buffer format inside isoc
Message-ID: <20120321090159.09c0e0c0@tele>
In-Reply-To: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Mar 2012 21:05:13 -0300
Ezequiel García <elezegarcia@gmail.com> wrote:

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
> Should I base in em28xx?
> 
> I'm sorry to ask such a generic question.
> Perhaps, someone cares enough to give me a hint.

Hi Ezequiel,

The saa7113 chip is (also?) handled by the gspca spca506 subdriver
which may be a base for your device.

In the gspca test tarball (see my site), I merged the spca506 code into
the spca505 for a webcam which may also do analog video capture. The
webcam works, but the analog video capture has never been tested.
Also, the gspca_main <-> subdriver interface for vidioc_s_input and
vidioc_s_std is not very clean.

So, you might include your device in this new spca505 subdriver,
forgetting about urb, isoc, videobuf.., and just concentrating on the
device management (image format, video controls, USB exchanges..). I am
ready to cleanup and extend the gspca subdriver interface to handle any
specific need.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
