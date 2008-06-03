Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53FjvgW008066
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:45:57 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53Fii6f027752
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:44:44 -0400
Received: by yw-out-2324.google.com with SMTP id 5so708208ywb.81
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 08:44:36 -0700 (PDT)
Message-ID: <37219a840806030844p4ac8612x3388859ad29ad0dc@mail.gmail.com>
Date: Tue, 3 Jun 2008 11:44:36 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Eduardo Valentin" <edubezval@gmail.com>
In-Reply-To: <1212506741-17056-1-git-send-email-edubezval@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212506741-17056-1-git-send-email-edubezval@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
	Eduardo Valentin <eduardo.valentin@indt.org.br>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Tue, Jun 3, 2008 at 11:25 AM, Eduardo Valentin <edubezval@gmail.com> wrote:
> From: Eduardo Valentin <eduardo.valentin@indt.org.br>
>
> Hi guys,
>
> This patch is just an update from linux-omap tree.
> It is a v4l2 driver which is only in linux-omap tree.
> I'm just sendint it to proper repository.
>
> It adds support for tea5761 chip.
> It is a v4l2 driver which exports a radio interface.
>
> Comments are wellcome!
>
> Cheers,
>
> Eduardo Valentin (1):
>  Add support for tea5761 chip
>
>  drivers/media/radio/Kconfig         |   13 +
>  drivers/media/radio/Makefile        |    1 +
>  drivers/media/radio/radio-tea5761.c |  516 +++++++++++++++++++++++++++++++++++
>  3 files changed, 530 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-tea5761.c

Eduardo,

We already have a tea5761 driver in our tree -- can you use that one,
instead?  Mauro Carvalho Chehab (cc added) wrote that driver based on
a datasheet -- it should work for you.  If it needs changes, please
generate patches against
linux/drivers/media/common/tuners/tea5761.[ch]

Regards,

Mike Krufky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
