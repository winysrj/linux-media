Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m76GxAhj004176
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 12:59:10 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m76GwsTB002718
	for <video4linux-list@redhat.com>; Wed, 6 Aug 2008 12:58:57 -0400
From: "Jalori, Mohit" <mjalori@ti.com>
To: John <john.maximus@gmail.com>
Date: Wed, 6 Aug 2008 11:58:41 -0500
Message-ID: <8AA5EFF14ED6C44DB31DA963D1E78F0DB5E60C72@dlee02.ent.ti.com>
References: <3634de740807172215v52a624ga09449e81bb684fe@mail.gmail.com>
	<8AA5EFF14ED6C44DB31DA963D1E78F0DB58C686C@dlee02.ent.ti.com>
	<3634de740808060845x14e00908hd177201c73414162@mail.gmail.com>
In-Reply-To: <3634de740808060845x14e00908hd177201c73414162@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE: omap3 camera patches
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

Hi John,


> -----Original Message-----
> From: John [mailto:john.maximus@gmail.com]
> Sent: Wednesday, August 06, 2008 10:46 AM
> To: Jalori, Mohit
> Cc: video4linux-list@redhat.com
> Subject: RE: omap3 camera patches
>
> Hello Mohit,
>    Using the patches on the omap git kernel. patch applies cleanly.
>
>    Seems like the camera clocks aren't set properly.
>
>    Messages like "Clock cam_mclk didn't enable in 100000 tries" are
> displayed during
>    boot.
>
>    have you tried with latest git kernel
>
>    trying out with 2.6.26-rc6 results in the same error.

No I have not tried with the latest GIT but with 2.6.26 I saw the same error but the clocks are correctly enabled. I think there was some changes going on in omap clock naming a while back. But when I tried with my sensor here the clock was enabled correctly

>
> /John
>
>
> On Sat, Jul 26, 2008 at 8:20 AM, Jalori, Mohit <mjalori@ti.com> wrote:
> >> -----Original Message-----
> >> From: John [mailto:john.maximus@gmail.com]
> >> Sent: Friday, July 18, 2008 12:15 AM
> >> To: video4linux-list@redhat.com
> >> Subject:
> >>
> >> Hello,
> >>    looking at the OMAP3 camera patches posted sometime back.
> >>    I manually applied these patches on a existing OMAP3 2.6.22
> kernel.
> >>    am trying to port an existing SOC micron driver to OMAP3 on a
> >> custom board.
> >>    am not seeing any interrupts.
> >>
> >>   Is anyone using the current camera patches for OMAP3. Is this
> >> working?
> >>
> >>   Are there any existing sensor drivers that use these patches. I
> find
> >> there are no sensor
> >>   driver for OMAP3.
> >
> > I have sent the sensor and lens driver patches. They are also based
> on 2.6.26. I verified these by applying the original 16 patches and
> then these 4 new ones.
> >
> >>
> >>
> >> Regards,
> >>
> >> John
> >

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
