Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51596 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab0HQSAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 14:00:15 -0400
Date: Tue, 17 Aug 2010 20:01:23 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sudhindra Nayak <sudhindra.nayak@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Not able to capture video frames
Message-ID: <20100817200123.656b1461@tele>
In-Reply-To: <AANLkTinEbSe=d7TESEzzd8MZ5tPExrN4U9LvHrgm7FYf@mail.gmail.com>
References: <AANLkTim5YmSsvhub3+t0_QX0k84xZgPy1FS5=9COfEzH@mail.gmail.com>
	<20100805131919.73541e9a@tele>
	<AANLkTinEbSe=d7TESEzzd8MZ5tPExrN4U9LvHrgm7FYf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 17 Aug 2010 17:50:58 +0530
Sudhindra Nayak <sudhindra.nayak@gmail.com> wrote:

> As you suggested I removed the 'cam->bulk....' part in the sd_config
> function. Also, can you please explain how you arrived at the
> sd_pkt_scan function? I'm not able to understand the bit
> manipulations that you have performed in the sd_pkt_scan function.
> Also, you did mention that the sd_pkt_scan function needs to be
> modified. Can you please elaborate on the changes that need to be
> done to the sd_pkt_scan function?
> 
> As I'd mentioned earlier, I'm using the 'ov534.c' code with the ov538
> bridge processor. Will there be any change in the sd_pkt_scan
> function with respect to ov538?
	[snip]
> functions and then enters the mainloop() function. In the mainloop()
> function, the select() function call times out after 2 seconds and
> I'm not able to capture any video frames.
> 
> Any suggestions??

Hi Sudhindra,

The ov534 sends images in UVC format, i.e. each packet contains a
12 bytes header and a part of the image. In the header, the 1st byte
contains various indicators, of which the bit 1 (0x02) marks the end
of the image.

To code your sd_pkt_scan(), you have to search in the ms-windows traces
how the images are fragmented, how you may find the start and end of
image and whether some data have to be discarded in the packets.

The last problem to solve is to find how are encoded the images. You
may know it looking also in the ms-winsows traces or, when the driver
will work, in the received images. If you want, I may send you a small
program which displays raw images (done by 'svv -rg') forcing the
encoding.

Good luck!

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
