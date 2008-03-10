Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JYuTG-0004Cw-MW
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 03:44:08 +0100
Message-ID: <47D5AF38.90600@iki.fi>
Date: Mon, 10 Mar 2008 23:59:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>	<47D49309.8020607@linuxtv.org>	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>	<47D4B8D0.9090401@linuxtv.org>	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>	<47D539E8.6060204@linuxtv.org>
	<abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>
In-Reply-To: <abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

Jarryd Beck wrote:
> 
> That didn't work, the problem is I can't tell where it's going wrong and
> I don't understand usb sniffs. I have a few questions:
> When af9015 reads the tuner, the existing tuners set the spectral
> inversion state->gpio3. Do you know what state->gpio3 does?

It connects tuner, probably turns power on. I don't if it needed or not 
in your device. At least it is needed when used AF9015 reference design 
with MT2060 or MT2061 tuners.

> The code then goes on to read the spectral inversion, but there's
> a comment there saying it's always 0, and the existing tuners
> have theirs set to 1, what should I set it to for this one?

Don't care this setting before you have got tuner attached. Tuner module 
will print message to log when it was attached. That's good indicator to 
see that communication to tuner works. After that you should try to find 
correct settings for all other things.

> If it's the case that some of the other values in the config are wrong,
> how would I go about making sense of a usb sniff?

Can you take logs with vendor WHQL driver and sent for further analysis?
http://www.afatech.com/EN/support.aspx

Antti

-- 
http://palosaari.fi

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
