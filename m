Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1KgMHt-0001T6-Gb
	for linux-dvb@linuxtv.org; Thu, 18 Sep 2008 18:23:26 +0200
Message-ID: <48D28052.5000209@gmx.de>
Date: Thu, 18 Sep 2008 18:22:42 +0200
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Frederic CAND <frederic.cand@anevia.com>
References: <48D27B52.2010704@anevia.com>
In-Reply-To: <48D27B52.2010704@anevia.com>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] hvr 1300 radio
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

Frederic CAND wrote:
> Dear all,
>
> has anyone got analog FM radio working with an Hauppauge HVR 1300 ?
> If yes please tell me how ! I got only noise from /dev/dsp* ... :(
> This is an issue I've had for some time now ...
> I tried option radio=63 on cx88xx module but it did not change anything 
> (except writing cx88[0]: TV tuner type 63, Radio tuner type 63 in dmesg 
> instead of radio tuner type -1 ...)
>
> Is radio support just not implemented ?
>
>   
Load cx88_blackbird and open /dev/radioX.
I haven't tried radio up to now, but i would expect that only radio *or* 
dvb works, but not both at the same time. Most probably radio is also 
not feed trough the mpeg encoder.

Regards,
Winfried


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
