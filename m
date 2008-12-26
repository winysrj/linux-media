Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LGLi0-0007Df-UE
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 00:03:13 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812261348h35b28437m5c87f43a3e6a5e33@mail.gmail.com>
References: <412bdbff0812261348h35b28437m5c87f43a3e6a5e33@mail.gmail.com>
Date: Sat, 27 Dec 2008 00:02:51 +0100
Message-Id: <1230332571.9078.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] mxl5005s tuner analog support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Devin,

Am Freitag, den 26.12.2008, 16:48 -0500 schrieb Devin Heitmueller:
> Hello,
> 
> I working on the analog support for the Pinnacle Ultimate 880e
> support, and that device includes an mxl5005s tuner.
> 
> I went to do the normal changes to em28xx to support another tuner,
> which prompted me to wonder:
> 
> Is the analog support known to to work in Linux for this tuner for any
> other device?
> 
> The reason I ask is because I hit an oops and when I looked at the
> source I found some suspicious things:
> 
> * No entry in tuner.h
> * No attach command in tuner-core.c
> * No definition of set_analog_params() callback in mxl5005s.c
> 
> I wonder if perhaps the driver was ported from some other source and
> nobody ever got around to getting the analog support working?  If
> that's the case then that is fine (I'll make it work), but I want to
> know if I am just missing something obvious here....
> 
> Devin
> 

we have lots of hybrid tuners meanwhile, either dealt with in
tuner-types or dedicated tuner submodules, but if not at least in
tuner.h, you are right that there is no analogue support yet.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
