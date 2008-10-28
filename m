Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b6341f62251611e1d35d+1892+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Kumme-0001mZ-Uo
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 12:30:49 +0100
Date: Tue, 28 Oct 2008 09:29:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Eddi De Pieri <eddi@depieri.net>
Message-ID: <20081028092949.5aacb553@pedra.chehab.org>
In-Reply-To: <1225191933.8398.40.camel@uvdr>
References: <200810241441.40928.borych@gmx.de>
	<20081025021331.35651bac@pedra.chehab.org>
	<20081025104025.01f7a074@pedra.chehab.org>
	<1225191933.8398.40.camel@uvdr>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] tm6000/tm6010 progress?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Eddi,

On Tue, 28 Oct 2008 12:05:33 +0100
Eddi De Pieri <eddi@depieri.net> wrote:

> I report you some problem:
> 
> With DVB support active build fail on tm6000-dvb.o
>   CC [M]  /data/devel/tm6010/v4l/tm6000-dvb.o
> /data/devel/tm6010/v4l/tm6000-dvb.c: In function 'tm6000_dvb_register':
> /data/devel/tm6010/v4l/tm6000-dvb.c:240: error: unknown field
> 'video_dev' specified in initializer
> /data/devel/tm6010/v4l/tm6000-dvb.c:240: warning: initialization makes
> integer from pointer without a cast
> 
> I've tried changing the line..
> -                      .video_dev = dev,
> +                      .i2c_addr  = 0x61,
> Now it build but the decoder is not detected.

Hmm.. Ok, I'll check this.

The DVB part deserves some work. I'm currently trying to fix the streaming
routine to use the same model for DVB as we did on em28xx-dvb.

> insmod tm6000-alsa.ko
> insmod: error inserting 'tm6000-alsa.ko': -1 Unknown symbol in module

> # dmesg
> [ 1785.667726] tm6000_alsa: Unknown symbol tm6000_get_reg
> [ 1785.667930] tm6000_alsa: Unknown symbol tm6000_set_reg
> 

tm6000-alsa is just a cleaned copy of the dummy alsa prototype. It never
worked. I need first to have the streaming routines working fine for making the
binding between stream reception and audio.

> 
> Without dvb it build but  mplayer show green screen and no image.

One of the hardest part of tm6000 is the streaming decoding. If you take a look
at the history, most of the latest patches were meant to fix streaming reception.

On analog mode, tm6000 produces frames with 180 bytes wide. The 3rd byte is the
header identifier (why they didn't use the first byte?). since the frames are
broken into several URB's, and even can be broken into different URB sets, a
complex logic is required to avoid double-buffering and to recover the original
image. That part of the code is currently broken. It used to work in the past,
but, on some cases, I was losing some URB's, causing very bad effects at the
image. We need this fixed in order to have the driver properly working.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
