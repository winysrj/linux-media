Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34N92iO001042
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 19:09:02 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m34N8mT5032544
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 19:08:48 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Oliver Endriss <o.endriss@gmx.de>
In-Reply-To: <200804041959.28748@orion.escape-edv.de>
References: <1115343012.20080318233620@a-j.ru> <47F6258B.7020207@linuxtv.org>
	<37219a840804040623i274d7292ledbe91ac7a531171@mail.gmail.com>
	<200804041959.28748@orion.escape-edv.de>
Content-Type: text/plain
Date: Sat, 05 Apr 2008 01:08:33 +0200
Message-Id: <1207350513.4591.41.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Hi,

Am Freitag, den 04.04.2008, 19:59 +0200 schrieb Oliver Endriss:
> Michael Krufky wrote:
> > On Fri, Apr 4, 2008 at 8:56 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> > >  Guys,
> > >
> > >  Please test this patch against 2.6.24.4 -stable.
> > >
> > >  I don't have this hardware, or any way to test this myself, so I will wait on your feedback before sending this to the -stable team.  (Please try to test it and get back to me quickly -- I'd like to send this over before the 2.6.24.5 review cycle begins)
> > 
> > 
> > I also uploaded the patch to linuxtv.org, in case of mailer whitespace-mangling:
> > 
> > http://linuxtv.org/~mkrufky/stable/2.6.24.y/0002-DVB-tda10086-make-the-22kHz-tone-for-DISEQC-a-conf.patch
> > 
> > Please test.
> 
> The following devices are affected by the patch:
> 
> driver: budget
> - Technontrend DVB-S 1401, pci subsystem id: 13c2:1018
> 
> driver ttusb2:
> - USB_PID_PCTV_400E
> - USB_PID_PCTV_450E
> 
> driver: saa7134
> - SAA7134_BOARD_FLYDVB_TRIO
> - SAA7134_BOARD_MEDION_MD8800_QUADRO
> - SAA7134_BOARD_FLYDVBS_LR300
> - SAA7134_BOARD_PHILIPS_SNAKE
> - SAA7134_BOARD_MD7134_BRIDGE_2
> 
> Sorry, cannot do any tests, I do not own any of these devices.
> 
> CU
> Oliver
> 

good, we are likely not dead by external bureaucracy then, but explicit
tests on 2.6.24 are needed.

For saa7134 only the FLYBVBS_LR300 and the FLYDVB_TRIO are on 2.6.24.

Here are two slightly different versions of the MEDION_MD8800_QUADRO,
one in an orange MSI nforce3 amd64 and one in a normal PCI slot, means
only the first 16be:0007 subdevice is functional, but I can use the
second LNB connector for loop through to an external receiver.

Also one of the new Medion/Creatix triple CTX948 low profile PCI cards,
a version sold in Austria, which is auto detected as 16be:0005 and
covered by the MD8800 config. We might add it to the name string.

I would have to down port all our new stuff, including isl6405 support,
to 2.6.24 and likely that is not the sort of test intended.

BTW, the patch in question is in 2.6.25, but none of the new DVB-S
support.

Andrew, since you are waiting for the fix on 2.6.24, can you test the
patch on 2.6.24.4 and report?

Thanks,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
