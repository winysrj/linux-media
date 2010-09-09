Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63141 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0IIT0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 15:26:19 -0400
Received: by wyf22 with SMTP id 22so1777313wyf.19
        for <linux-media@vger.kernel.org>; Thu, 09 Sep 2010 12:26:18 -0700 (PDT)
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Andy Walls" <awalls@md.metrocast.net>,
	"Hans de Goede" <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	"ext Eino-Ville Talvala" <talvala@stanford.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <y1el0c4vecj8x6uk04ypatvd.1284039765001@email.android.com>
	<275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
Date: Thu, 09 Sep 2010 21:26:10 +0200
In-Reply-To: <275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
	(Hans Verkuil's message of "Thu, 9 Sep 2010 16:17:40 +0200")
Message-ID: <87vd6ebtwt.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

>>>>> "Hans" == Hans Verkuil <hverkuil@xs4all.nl> writes:

Hi,

 Hans> But I feel I am missing something: who is supposed to use these LEDs?
 Hans> Turning LEDs in e.g. webcams on or off is a job for the driver, never for
 Hans> a userspace application.

Agreed - By default, the driver should just turn on the LED when the
device is active and off again when it is not.

 Hans> For that matter, if the driver handles the LEDs,
 Hans> can we still expose the API to userspace? Wouldn't those two interfere
 Hans> with one another? I know nothing about the LED interface in sysfs, but I
 Hans> can imagine that will be a problem.

Yes, you expose the LED using the LED class, and add a LED trigger per
video device (named something like "videoX-active"). Furthermore you set
the default trigger for that LED to be videoX-active.

So the logic of how to turn on/off the LED is seperated from the policy
about WHEN it should be turned on/off.

 >> Sysfs entry ownership, unix permissions, and ACL permissions consistency
 >> with /dev/videoN will be the immediate usability problem for end users in
 >> any case.

 Hans> Again, why would end users or application need or want to manipulate such
 Hans> LEDs in any case?

In most cases they don't - Not using the LED sysfs or v4l. But if they
do, then they CAN.

-- 
Bye, Peter Korsgaard
