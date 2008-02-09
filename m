Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JNx22-0002Hq-DG
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 22:14:42 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: Eduard Huguet <eduardhc@gmail.com>
Date: Sat, 9 Feb 2008 22:14:06 +0100
References: <47ADC81B.4050203@gmail.com>
In-Reply-To: <47ADC81B.4050203@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802092214.06946.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Samstag, 9. Februar 2008, Eduard Huguet wrote:
> Hi, Matthias
Hi Eduard!

>     I've been performing some tests using your patch for this card.
> Right now neither dvbscan nor kaffeine are able to find any channel on
> Astra (the sat. my dish points to).
>
> However, Kaffeine has been giving me some interesting results: with your
> driver "as is" it's getting me a 13-14% signal level and ~52% SNR when
> scanning. Then, thinking that the problem is related to the low signal I
> have I've changed the gain levels used to program the tuner: you were
> using default values of 0 for all (in zl1003x_set_gain_params()
> function, variables "rfg", "ba" and "bg"), and I've changed them top the
> maximum (according to the documentation: rfg=1, ba=bg=3). With that, I'm
> getting a 18% signal level, which is higher but still too low apparently
> to get a lock.
>
> I've stopped here, because I really don't have the necessary background
> to keep tweaking the driver. I just wanted to share it with you, as
> maybe you have some idea on how to continue or what else could be done.
>

So I can do only this guess:
I changed demod driver to invert the Polarization voltage for a700 card.
This is controlled by member-variable voltage_inverted.

static struct mt312_config avertv_a700_mt312 = {
        .demod_address = 0x0e,
        .voltage_inverted = 1,
};

Can you try to comment the voltage_inverted line here (saa7134-dvb.c: line 
865).

BUT: If this helps we need to find out how to detect which card needs this 
enabled/disabled.

Regards
Matthias

-- 
Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
