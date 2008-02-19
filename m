Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JGdkWc021053
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 11:39:46 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1JGdA88013025
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 11:39:10 -0500
Date: Tue, 19 Feb 2008 13:38:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080219133845.56fc5e7c@gaivota>
In-Reply-To: <20080219065109.199ee966@gaivota>
References: <20080127173132.551401d9@tux.abusar.org.br>
	<20080128165403.1f7137e0@gaivota>
	<20080128182634.345bd4e8@tux.abusar.org.br>
	<20080128184534.7af7a41b@gaivota>
	<20080128192230.59921445@tux.abusar.org.br>
	<20080129004104.17e20224@gaivota>
	<20080129021904.1d3047d1@tux.abusar.org.br>
	<20080129025020.60fa33de@gaivota>
	<20080129050103.2fae9d61@tux.abusar.org.br>
	<20080129122547.63214371@gaivota>
	<37219a840802182044k5a24bcbbm3646560c595df564@mail.gmail.com>
	<20080219065109.199ee966@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	=?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>,
	Michael Krufky <mkrufky@linuxtv.org>, LinuxTV-DVB <linux-dvb@linuxtv.org>
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: When
 xc3028/xc2028 will be supported?
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

On Tue, 19 Feb 2008 06:51:09 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> > The repository is broken after and including changeset ce6afd207b71 -
> That's said, maybe SET_TUNER_CONFIG is being called too early. Maybe the way to
> fix this is to create an special function to initialize it, that would be
> called later by cx8800 or cx8802.

After analysing the code, I noticed that "tuner" module is requested too late,
o both cx88 and saa7134 drivers. This explains why there are some instabilities
on those drivers with certain tuners.

I've did some changesets fixing both drivers at:
	http://linuxtv.org/hg/~mchehab/cx88-xc2028/

I expect that we should have better results after those changes. I also added
some newer printk's to cx88 driver. This way, we'll have a cleaner idea if an
error is still occurring.

Guys, please test.

Daniel Gimpelevich,

Could you please rebase your changesets fixing the gpio's for PowerColor Real
Angel 330 and send them to me?

Dâniel Fraga,

Please test if the gpio's from Daniel Gimpelvinch works for you, against the
newer tree. I suspect it will work. However, is it not uncommon to have two
cards with the same brand name, but needing different gpio settings.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
