Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas04p.mx.bigpond.com ([61.9.189.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mickhowe@bigpond.net.au>) id 1KO1gP-0001Dv-EX
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 04:44:58 +0200
Received: from nschwotgx02p.mx.bigpond.com ([124.177.142.75])
	by nschwmtas04p.mx.bigpond.com with ESMTP id
	<20080730024418.CQQB19703.nschwmtas04p.mx.bigpond.com@nschwotgx02p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Wed, 30 Jul 2008 02:44:18 +0000
Received: from fini.bareclan ([124.177.142.75])
	by nschwotgx02p.mx.bigpond.com with ESMTP
	id <20080730024418.RSNR10826.nschwotgx02p.mx.bigpond.com@fini.bareclan>
	for <linux-dvb@linuxtv.org>; Wed, 30 Jul 2008 02:44:18 +0000
From: mick <mickhowe@bigpond.net.au>
To: linux-dvb@linuxtv.org
Date: Wed, 30 Jul 2008 12:44:16 +1000
References: <200807161621.42016.mickhowe@bigpond.net.au>
	<1216232348.2669.35.camel@pc10.localdom.local>
In-Reply-To: <1216232348.2669.35.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807301244.17219.mickhowe@bigpond.net.au>
Subject: Re: [linux-dvb] Leadtek DTV2000H rev J - no digital tv,
	no sound but I have got analog vision
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

On Thu, 17 Jul 2008 04:19:08 you wrote:
> Hi Mick,
>
> Am Mittwoch, den 16.07.2008, 16:21 +1000 schrieb mick:
> > A couple of days ago I finally managed to get the latest source for
> > v4l-dvb to d/l & build and then add a patch (from a croatian contributor
> > - lost the link) for my Leadtek DTV2000H rev J.
> >
> > I now have picture on analog using either motv or tvtime applications but
> > can get no sound or digital tv.
> >
> > Where can I turn next?
> >
> > /]/]ik
>
> have a look at the patch here and further messages.
> http://www.spinics.net/lists/vfl/msg37257.html

I downloaded the latest v4l-dvb and this patch (which contains a patch to 
cx88-mpeg.c that wasn't in the patch I had), applied it and got the following 
error trying to build.

root@cave:~/v4l-dvb# make
make -C /root/v4l-dvb/v4l
make[1]: Entering directory `/root/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.26cave1/build
make -C /lib/modules/2.6.26cave1/build SUBDIRS=/root/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.26'
  CC [M]  /root/v4l-dvb/v4l/cx88-video.o
  CC [M]  /root/v4l-dvb/v4l/cx88-vbi.o
  CC [M]  /root/v4l-dvb/v4l/cx88-mpeg.o
/root/v4l-dvb/v4l/cx88-mpeg.c: In function 'cx8802_start_dma':
/root/v4l-dvb/v4l/cx88-mpeg.c:108: error: invalid operands to binary ==
make[3]: *** [/root/v4l-dvb/v4l/cx88-mpeg.o] Error 1
make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.26'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2
root@cave:~/v4l-dvb#

The failing code is
...
	/* FIXME: this needs a review.
	 * also: move to cx88-blackbird + cx88-dvb source files? */
/*****/
	if ((core->board) == CX88_BOARD_WINFAST_DTV2000H_J)
                  cx_write(MO_GP0_IO, 0x00017300);
/******/         /*switch signal input to antena*/

	dprintk( 1, "core->active_type_id = 0x%08x\n", core->active_type_id);

	if ( (core->active_type_id == CX88_MPEG_DVB) &&
		(core->board.mpeg & CX88_MPEG_DVB) ) {

		dprintk( 1, "cx8802_start_dma doing .dvb\n");
...

I've looked for something obvious but nothing jump out at me
I'm using kubuntu 8.04 x86_64 with gcc 4.2.3 and fresh kernel.org 2.6.26 
source

mick
> Mauro is waiting for somebody to test it and giving him at least a
> Reviewed-by-line before adding the card.
>
> Cheers,
> Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
