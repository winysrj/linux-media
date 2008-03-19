Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2J1XwLv027818
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 21:33:58 -0400
Received: from mailout01.sul.t-online.de (mailout01.sul.t-online.de
	[194.25.134.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2J1XONP020527
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 21:33:25 -0400
Message-ID: <47E06D5C.3070109@t-online.de>
Date: Wed, 19 Mar 2008 02:33:16 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <47E060EB.5040207@t-online.de>
	<37219a840803181754n5935b4e8g37dc77dd605b3095@mail.gmail.com>
In-Reply-To: <37219a840803181754n5935b4e8g37dc77dd605b3095@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [RFC] TDA8290 / TDA827X with LNA: testers wanted
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

Hi, Mike

Michael Krufky schrieb:
> On Tue, Mar 18, 2008 at 8:40 PM, Hartmut Hackmann
> <hartmut.hackmann@t-online.de> wrote:
>> Hi, Folks
>>
>>  Currently, the LNA support code for TDA8275a is broken, it may even cause a kernel oops.
>>  The bugs were introduced during tuner refactoring.
>>  In my personal repository at
>>   http://linuxtv.org/hg/~hhackmann/v4l-dvb/
>>  these bugs hopefully are fixed. But i can test only 3 cases. So i am looking for owners
>>  of the cards
>>  Pinnacle 310i,
>>  Happauge hvr1110
>>  ASUSTeK P7131 with LNA
>>  MSI TV@NYWHERE AD11
>>  KWORLD DVBT 210
>>  to check whether things are right again. This holds for both, analog as well as DVB-T.
>>
>>  Michael, may i ask you to check whether my changes contradict with things you are doing?
>>  Mauro, what's your opinion on this? As far as i know, the broken code is in the upcoming
>>  kernel release. The patch is big, is there a chance to commit it to the kernel?
> 
> Hartmut,
> 
> I've already checked over your changes (I noticed the tree pushed a
> few days ago)  -- I do not see any reason why they would cause any
> problems on the tda8295 nor the tda18271.  These changes will not
> contradict anything that I am currently working on, and it would be
> nice to have them merged sooner than later.
> 
> There is only one detail that I would like to point out.  You made the
> following change:
> 
> --- a/linux/drivers/media/video/tda8290.h	Mon Mar 03 22:55:05 2008 +0100
> +++ b/linux/drivers/media/video/tda8290.h	Sun Mar 16 23:49:43 2008 +0100
> @@ -21,7 +21,7 @@
>  #include "dvb_frontend.h"
> 
>  struct tda829x_config {
> -	unsigned int *lna_cfg;
> +	unsigned int lna_cfg;
>  	int (*tuner_callback) (void *dev, int command, int arg);
> 
>  	unsigned int probe_tuner:1;
> --- a/linux/drivers/media/video/tuner-core.c	Mon Mar 03 22:55:05 2008 +0100
> +++ b/linux/drivers/media/video/tuner-core.c	Sun Mar 16 23:49:43 2008 +0100
> @@ -349,7 +349,7 @@ static void attach_tda829x(struct tuner
>  static void attach_tda829x(struct tuner *t)
>  {
>  	struct tda829x_config cfg = {
> -		.lna_cfg        = &t->config,
> +		.lna_cfg        = t->config,
>  		.tuner_callback = t->tuner_callback,
>  	};
>  	tda829x_attach(&t->fe, t->i2c->adapter, t->i2c->addr, &cfg);
> 
> 
> 
> ...The above change means that the lna setting is set at tuner driver
> attach time, and if somebody wants to use TUNER_SET_CONFIG (or some
> other method) to enable / disable the LNA on-the-fly, it will not be
> possible.    Meanwhile, I'm not even sure it that was possible to
> begin with.  Just some food for thought -- you should decide what is
> best, here.
> 
Ah, That's your intention.. I changed this because in the case of DVB
there is nothing that creates a copy of the tda827x config structure -
so no legal way to change the data. And imho it is not necessary to change
this dynamically.

> I have an HVR1110, and I have a QAM64 generator that I use to test it.
>  Obviously, it is a hot signal.  Is it possible for me to test the LNA
> under these circumstances?  ...or do we need somebody "out in the
> field" to do that sort of test?  (I live in ATSC-land ;-) )
>
You should be able to. You need to have the debug option for the tuner on
and you need to be aware that the decicion LNA on / off is taken only once
while tuning. When you modify the RF level you should notice that increasing
the amplitude results in a lower AGC2 value. When it reaches the value 2, the
driver should report that it turns the LNA to low gain. You will also need to
monitor the AGC value of the channel decoder to see the effect.

> You mentioned a possible kernel OOPS.  Have you actually experienced
> an OOPS with the current tree?  I apologize if this feature being
> broken is the result of my tuner refactoring.  I appreciate your
> taking the time to fix it.
> 
Yes. The first parameter to the tuner callback was wrong and cause a reference
to a NULL pointer.

Best regards
 Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
