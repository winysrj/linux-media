Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAEAxjpW024757
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 05:59:45 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAEAxXKF004892
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 05:59:33 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081113233554.65c5a5f4.ospite@studenti.unina.it>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
	<20081112191736.bcbc1e37.ospite@studenti.unina.it>
	<1226576038.2040.42.camel@localhost>
	<20081113180421.09c5ca05.ospite@studenti.unina.it>
	<1226601059.1705.12.camel@localhost>
	<20081113233554.65c5a5f4.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 14 Nov 2008 11:55:30 +0100
Message-Id: <1226660130.1737.22.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Thu, 2008-11-13 at 23:35 +0100, Antonio Ospite wrote:
> > I attached the patch of the main driver.
> 
> Many thanks Jean-Francois, any ETA of this change in mainline?

Sorry, what do you mean by ETA? I uploaded the patch to my repository
with you as the author.

	[snip]
> > +	/* resubmit the URB */
> > +	if (gspca_dev->cam.bulk_nurbs != 0) {
> 
> Just to be sure: this check is still needed because bulk_irq() can be
> still called even for drivers like finepix, right?

Yes, the subdriver may use the bulk_irq or have an other function. This
is the case for finepix which may receive normal(!) URB errors.

> I am not sure I've fully understood the code path here, maybe I should
> look better at what the finepix driver does, sorry, does it still uses
> the urb initialized in create_urbs(), even if it drives the submission
> manually?

Yes. The URB is created and destroyed by the main driver. Only the
submission and optionally the IRQ treatment are done by the subdriver.

	[snip]
> > +		if (gspca_dev->cam.bulk_nurbs != 0)
> > +			nurbs = gspca_dev->cam.bulk_nurbs;
> 
> should we set this to min(gspca_dev->cam.bulk_nurbs, MAX_NURBS) ?

Yes, we should, but, if a greater value is set, the subdriver will crash
at the first development test...

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
