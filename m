Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2J0sn7N012038
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 20:54:49 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2J0sDJi031553
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 20:54:13 -0400
Received: by rn-out-0910.google.com with SMTP id e11so165861rng.17
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 17:54:13 -0700 (PDT)
Message-ID: <37219a840803181754n5935b4e8g37dc77dd605b3095@mail.gmail.com>
Date: Tue, 18 Mar 2008 20:54:13 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Hartmut Hackmann" <hartmut.hackmann@t-online.de>
In-Reply-To: <47E060EB.5040207@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E060EB.5040207@t-online.de>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] TDA8290 / TDA827X with LNA: testers wanted
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

On Tue, Mar 18, 2008 at 8:40 PM, Hartmut Hackmann
<hartmut.hackmann@t-online.de> wrote:
> Hi, Folks
>
>  Currently, the LNA support code for TDA8275a is broken, it may even cause a kernel oops.
>  The bugs were introduced during tuner refactoring.
>  In my personal repository at
>   http://linuxtv.org/hg/~hhackmann/v4l-dvb/
>  these bugs hopefully are fixed. But i can test only 3 cases. So i am looking for owners
>  of the cards
>  Pinnacle 310i,
>  Happauge hvr1110
>  ASUSTeK P7131 with LNA
>  MSI TV@NYWHERE AD11
>  KWORLD DVBT 210
>  to check whether things are right again. This holds for both, analog as well as DVB-T.
>
>  Michael, may i ask you to check whether my changes contradict with things you are doing?
>  Mauro, what's your opinion on this? As far as i know, the broken code is in the upcoming
>  kernel release. The patch is big, is there a chance to commit it to the kernel?

Hartmut,

I've already checked over your changes (I noticed the tree pushed a
few days ago)  -- I do not see any reason why they would cause any
problems on the tda8295 nor the tda18271.  These changes will not
contradict anything that I am currently working on, and it would be
nice to have them merged sooner than later.

There is only one detail that I would like to point out.  You made the
following change:

--- a/linux/drivers/media/video/tda8290.h	Mon Mar 03 22:55:05 2008 +0100
+++ b/linux/drivers/media/video/tda8290.h	Sun Mar 16 23:49:43 2008 +0100
@@ -21,7 +21,7 @@
 #include "dvb_frontend.h"

 struct tda829x_config {
-	unsigned int *lna_cfg;
+	unsigned int lna_cfg;
 	int (*tuner_callback) (void *dev, int command, int arg);

 	unsigned int probe_tuner:1;
--- a/linux/drivers/media/video/tuner-core.c	Mon Mar 03 22:55:05 2008 +0100
+++ b/linux/drivers/media/video/tuner-core.c	Sun Mar 16 23:49:43 2008 +0100
@@ -349,7 +349,7 @@ static void attach_tda829x(struct tuner
 static void attach_tda829x(struct tuner *t)
 {
 	struct tda829x_config cfg = {
-		.lna_cfg        = &t->config,
+		.lna_cfg        = t->config,
 		.tuner_callback = t->tuner_callback,
 	};
 	tda829x_attach(&t->fe, t->i2c->adapter, t->i2c->addr, &cfg);



...The above change means that the lna setting is set at tuner driver
attach time, and if somebody wants to use TUNER_SET_CONFIG (or some
other method) to enable / disable the LNA on-the-fly, it will not be
possible.    Meanwhile, I'm not even sure it that was possible to
begin with.  Just some food for thought -- you should decide what is
best, here.

I have an HVR1110, and I have a QAM64 generator that I use to test it.
 Obviously, it is a hot signal.  Is it possible for me to test the LNA
under these circumstances?  ...or do we need somebody "out in the
field" to do that sort of test?  (I live in ATSC-land ;-) )

You mentioned a possible kernel OOPS.  Have you actually experienced
an OOPS with the current tree?  I apologize if this feature being
broken is the result of my tuner refactoring.  I appreciate your
taking the time to fix it.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
