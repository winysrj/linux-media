Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yoshi314@gmail.com>) id 1KF5Yi-0007hf-I6
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 13:04:05 +0200
Received: by ug-out-1314.google.com with SMTP id m3so963420uge.20
	for <linux-dvb@linuxtv.org>; Sat, 05 Jul 2008 04:04:01 -0700 (PDT)
Date: Sat, 5 Jul 2008 13:03:22 +0200
From: marcin kowalski <yoshi314@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080705110322.GA3898@watanabe>
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>
	<4868A644.5030806@onelan.co.uk>
	<1214870271.2623.33.camel@pc10.localdom.local>
	<20080701052044.GA3846@watanabe>
	<51029ae90807050218v3c10b69bl261690ac3d9ed680@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51029ae90807050218v3c10b69bl261690ac3d9ed680@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr-1300 analog audio question
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

On 11:18 Sat 05 Jul     , yoshi watanabe wrote:
> one small update. when i run the arecord | aplay combo with these parameters :
> 
> arecord -D hw:1,0 -c 2 -f S16 --period-size=8192 --buffer-size=524288 | aplay -
> 
> or with omitting the --period-size=8192 --buffer-size=524288
> 
> i hear noise. but when i start tvtime, right after video appears on
> screen i usually get 1-2 seconds of clear audio, and then noise comes
> in. i might be on to something. when i discard the buffering
> parameters sometimes arecord or aplay complain about buffer underrun.
> tvtime does not use cx88 mixes by default, by if i specify /
> 
> also this command
>  arecord -D hw:1,0 -c 2 -f S16_LE --period-size=65536
> --buffer-size=524288 -r 48000| aplay -r 48000 -
> 
> gives me very few errors now. noise pick ups when the sounds get
> louder though, but feel i'm really close now.
> 
> this is on a freshly installed system with mpeg encoder module
> disabled. i'll do some more testing.
> 
> 
this mail got strangely garbled when i sent it. it certainly didn't look like this when i sent it.

the thing is - i'm pretty close to success. i'll try building cx88 modules from ~rmcc branch to see whether they make a 
difference.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
