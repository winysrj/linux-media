Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SEG2cp020048
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:16:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3SEFopu026411
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:15:50 -0400
Date: Mon, 28 Apr 2008 11:14:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080428111431.6c12081f@gaivota>
In-Reply-To: <1209327322.2661.26.camel@pc10.localdom.local>
References: <20080425114526.434311ea@gaivota> <4811F391.1070207@linuxtv.org>
	<20080426085918.09e8bdc0@gaivota>
	<481326E4.2070909@pickworth.me.uk>
	<20080426110659.39fa836f@gaivota>
	<1209247821.15689.12.camel@pc10.localdom.local>
	<20080426201940.1507fb82@gaivota>
	<1209327322.2661.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mkrufky@linuxtv.org, gert.vervoort@hccnet.nl,
	linux-dvb@linuxtv.org
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 27 Apr 2008 22:15:22 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> Hi,
> 
> Am Samstag, den 26.04.2008, 20:19 -0300 schrieb Mauro Carvalho Chehab:
> > On Sun, 27 Apr 2008 00:10:21 +0200
> > hermann pitton <hermann-pitton@arcor.de> wrote:
> > > Cool stuff!
> > > 
> > > Works immediately for all tuners again. Analog TV, radio and DVB-T on
> > > that machine is tested.
> > > 
> > > Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> > 
> > Thanks. I'll add it to the patch.
> > 
> > > Maybe Hartmut can help too, but I will test also on the triple stuff and
> > > the FMD1216ME/I MK3 hybrid tomorrow.
> > 
> > Thanks.
> > 
> > It would be helpful if tda9887 conf could also be validated. I didn't touch at
> > the logic, but I saw some weird things:
> > 
> > For example, SAA7134_BOARD_PHILIPS_EUROPA defines this:
> > 	.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE
> > 
> > And SAA7134_BOARD_PHILIPS_SNAKE keep the default values.
> > 
> > However, there's an autodetection code that changes from EUROPA to SNAKE,
> > without cleaning tda9887_conf:
> > 
> >         case SAA7134_BOARD_PHILIPS_EUROPA:
> >                 if (dev->autodetected && (dev->eedata[0x41] == 0x1c)) {
> >                         /* Reconfigure board as Snake reference design */
> >                         dev->board = SAA7134_BOARD_PHILIPS_SNAKE;
> >                         dev->tuner_type = saa7134_boards[dev->board].tuner_type;
> >                         printk(KERN_INFO "%s: Reconfigured board as %s\n",
> >                                 dev->name, saa7134_boards[dev->board].name);
> >                         break;
> > 
> > I'm not sure if .tda9887_conf is missing at SNAKE board entry, or if the above
> > code should be doing, instead:
> > 
> > 	dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
> > 
> > If the right thing to do is to initialize SNAKE with the same tda9887
> > parameters as EUROPE, the better would be to add the .tda9887_conf to SNAKE
> > entry.
> > 
> > Cheers,
> > Mauro
> 
> Hartmut has the board and knows better, but it looks like it only has
> DVB-S and external analog video inputs. There is TUNER_ABSENT set, no
> analog tuner, no tda9887 and also no DVB-T, but it unfortunately shares
> the subsystem with the Philips Europa.

In this case, it would be better to do:
	dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;

for SNAKE. This won't produce any effect, but will avoid the overhead of
sending tda9887 config commands for a device that doesn't have it.

Later, maybe we can just move the above to the setup tuner subroutine.

> I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
> boards.
> 
> Unchanged is that the tda9887 is not up for analog after boot.
> Previously one did reload "tuner" just once and was done.

We need to fix this. The previous "hacks" like this now stops working.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
