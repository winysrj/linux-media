Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53LulX5010766
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:56:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53LuIG3026968
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:56:18 -0400
Date: Tue, 3 Jun 2008 18:56:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Message-ID: <20080603185603.33647fc1@gaivota>
In-Reply-To: <37219a840806030844p4ac8612x3388859ad29ad0dc@mail.gmail.com>
References: <1212506741-17056-1-git-send-email-edubezval@gmail.com>
	<37219a840806030844p4ac8612x3388859ad29ad0dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Tony Lindgren <tony@atomide.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>, Eduardo
	Valentin <eduardo.valentin@indt.org.br>,
	Sakari Ailus <sakari.ailus@nokia.com>
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

On Tue, 3 Jun 2008 11:44:36 -0400
"Michael Krufky" <mkrufky@linuxtv.org> wrote:

> On Tue, Jun 3, 2008 at 11:25 AM, Eduardo Valentin <edubezval@gmail.com> wrote:
> > From: Eduardo Valentin <eduardo.valentin@indt.org.br>
> >
> > Hi guys,
> >
> > This patch is just an update from linux-omap tree.
> > It is a v4l2 driver which is only in linux-omap tree.
> > I'm just sendint it to proper repository.
> >
> > It adds support for tea5761 chip.
> > It is a v4l2 driver which exports a radio interface.
> >
> > Comments are wellcome!
> >
> > Cheers,
> >
> > Eduardo Valentin (1):
> >  Add support for tea5761 chip
> >
> >  drivers/media/radio/Kconfig         |   13 +
> >  drivers/media/radio/Makefile        |    1 +
> >  drivers/media/radio/radio-tea5761.c |  516 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 530 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/radio/radio-tea5761.c
> 
> Eduardo,
> 
> We already have a tea5761 driver in our tree -- can you use that one,
> instead?  Mauro Carvalho Chehab (cc added) wrote that driver based on
> a datasheet -- it should work for you.  If it needs changes, please
> generate patches against
> linux/drivers/media/common/tuners/tea5761.[ch]

Michael,

Thanks for noticing this. I'm very busy those days, still trying to figure out
what patches are missed.

Olá Eduardo,

We should avoid to duplicate drivers. Feel free to fix tea5761, if it is not
working, but don't add another version.

If you have any doubts about it, feel free to send it to me.

Thanks.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
