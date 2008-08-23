Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas04p.mx.bigpond.com ([61.9.189.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KWrn6-0005Gb-Np
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 14:00:26 +0200
From: Jonathan Hummel <jhhummel@bigpond.com>
To: mick <mickhowe@bigpond.net.au>
In-Reply-To: <200808011415.06162.mickhowe@bigpond.net.au>
References: <200807161621.42016.mickhowe@bigpond.net.au>
	<1216232348.2669.35.camel@pc10.localdom.local>
	<200807301244.17219.mickhowe@bigpond.net.au>
	<200808011415.06162.mickhowe@bigpond.net.au>
Date: Sat, 23 Aug 2008 21:59:48 +1000
Message-Id: <1219492788.8670.5.camel@mistress>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek DTV2000H rev J - no digital tv,
	no sound	but I have got analog vision
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

On Fri, 2008-08-01 at 14:15 +1000, mick wrote:
> On Wed, 30 Jul 2008 12:44:16 mick wrote:
> > On Thu, 17 Jul 2008 04:19:08 you wrote:
> > > Hi Mick,
> > >
> > > Am Mittwoch, den 16.07.2008, 16:21 +1000 schrieb mick:
> > > > A couple of days ago I finally managed to get the latest source for
> > > > v4l-dvb to d/l & build and then add a patch (from a croatian
> > > > contributor - lost the link) for my Leadtek DTV2000H rev J.
> > > >
> > > > I now have picture on analog using either motv or tvtime applications
> > > > but can get no sound or digital tv.
> > > >
> > > > Where can I turn next?
> > > >
> > > > /]/]ik
> > >
> > > have a look at the patch here and further messages.
> > > http://www.spinics.net/lists/vfl/msg37257.html
> >
> > I downloaded the latest v4l-dvb and this patch (which contains a patch to
> > cx88-mpeg.c that wasn't in the patch I had), applied it and got the
> > following error trying to build.
> >
> > root@cave:~/v4l-dvb# make
> > make -C /root/v4l-dvb/v4l
> > make[1]: Entering directory `/root/v4l-dvb/v4l'
> > creating symbolic links...
> > Kernel build directory is /lib/modules/2.6.26cave1/build
> > make -C /lib/modules/2.6.26cave1/build SUBDIRS=/root/v4l-dvb/v4l  modules
> > make[2]: Entering directory `/usr/src/linux-2.6.26'
> >   CC [M]  /root/v4l-dvb/v4l/cx88-video.o
> >   CC [M]  /root/v4l-dvb/v4l/cx88-vbi.o
> >   CC [M]  /root/v4l-dvb/v4l/cx88-mpeg.o
> > /root/v4l-dvb/v4l/cx88-mpeg.c: In function 'cx8802_start_dma':
> > /root/v4l-dvb/v4l/cx88-mpeg.c:108: error: invalid operands to binary ==
> > make[3]: *** [/root/v4l-dvb/v4l/cx88-mpeg.o] Error 1
> > make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-2.6.26'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/root/v4l-dvb/v4l'
> > make: *** [all] Error 2
> > root@cave:~/v4l-dvb#
> >
> > The failing code is
> > ...
> > 	/* FIXME: this needs a review.
> > 	 * also: move to cx88-blackbird + cx88-dvb source files? */
> > /*****/
> > 	if ((core->board) == CX88_BOARD_WINFAST_DTV2000H_J)
> >                   cx_write(MO_GP0_IO, 0x00017300);
> > /******/         /*switch signal input to antena*/
> >
> I think I have found the problem with that bit of code;
> replacing Zbynek Hrabovsky's patch of cx88-mpeg.c with:
> diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88-mpeg.c /usr/src/linux/drivers/media/video/cx88-patched/cx88-mpeg.c
> --- /usr/src/linux/drivers/media/video/cx88/cx88-mpeg.c	2007-10-09 
> 22:31:38.000000000 +0200
> +++ /usr/src/linux/drivers/media/video/cx88-patched/cx88-mpeg.c	2008-01-07 
> 23:28:29.000000000 +0100
> @@ -103,6 +103,7 @@
>  	/* FIXME: this needs a review.
>  	 * also: move to cx88-blackbird + cx88-dvb source files? */
>  
> +	if ((core->boardnr) == CX88_BOARD_WINFAST_DTV2000H_2)
> +                 cx_write(MO_GP0_IO, 0x00017300);
> +             /*switch signal input to antena*/
>  	dprintk( 1, "core->active_type_id = 0x%08x\n", core->active_type_id);
>  
>  	if ( (core->active_type_id == CX88_MPEG_DVB) &&
> 
> compiles successfully.
> 
> still can't get the a tv app to find channels
> 
> mick
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi Mick,

Are you getting radio, analogue and digital TV with this card now? I've
got digital TV, which is reasonably easy, (see
http://wiki.linuxmce.org/index.php/Leadtek_DTV2000H if you don't) but
haven't managed to get radio or analogue going.

On this topic, do you find this card seems to strugle with HD TV? or is
something in my system?

cheers

Jon


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
