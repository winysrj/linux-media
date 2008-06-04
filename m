Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m54Ej3Y3001834
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 10:45:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m54EiorZ019403
	for <video4linux-list@redhat.com>; Wed, 4 Jun 2008 10:44:50 -0400
Date: Wed, 4 Jun 2008 11:44:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Eduardo Valentin" <edubezval@gmail.com>
Message-ID: <20080604114437.0cf0dd69@gaivota>
In-Reply-To: <a0580c510806040725i8070ce1n2445c5a422bb88a3@mail.gmail.com>
References: <1212506741-17056-1-git-send-email-edubezval@gmail.com>
	<37219a840806030844p4ac8612x3388859ad29ad0dc@mail.gmail.com>
	<20080603185603.33647fc1@gaivota>
	<a0580c510806040725i8070ce1n2445c5a422bb88a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Tony Lindgren <tony@atomide.com>, Eduardo
	Valentin <eduardo.valentin@indt.org.br>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>, Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: [PATCH 0/1] Add support for TEA5761 (from linux-omap)
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

Hi Eduardo,

On Wed, 4 Jun 2008 10:25:23 -0400
"Eduardo Valentin" <edubezval@gmail.com> wrote:

> Hi Mauro and Michael,
> 
> Thanks for pointing that there were a duplicated work. If there is any
> update on the current driver, I'll contact you. I'm not the author of
> this driver, but I'm interested in some points here.
> 
> This chip is used on n800 FM radio. That's why this version came from
> linux-omap.
> Anyway, one quest that came from my mind, taking a brief look into
> this two drivers,
> I see they use different interfaces to register a FM radio driver, and
> more they are located
> under different places inside the tree. So, what is more recommended
> for FM radio drivers?
> being under drivers/media/radio/ or under drivers/media/common/tunners/ ?
> What is the API more recommended dvb_tuner_ops or video_device ? I
> wonder also what current applications are using.

Good point. some radio tuners are used inside video boards. Before, this were
located inside drivers/media/video. Now, they are at common/tuners. This seems
to be a better place.

It should be noticed that tea5761 is an I2C device. So, you'll probably need a
counterpart module, at media/radio, that will provice I2C access methods needed
on N800.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
