Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JYele-0004sL-83
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 10:58:08 +0100
Message-ID: <47D505DC.3030409@iki.fi>
Date: Mon, 10 Mar 2008 11:56:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>	<47D49309.8020607@linuxtv.org>	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>	<47D4B8D0.9090401@linuxtv.org>
	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
In-Reply-To: <abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
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
>>  I think that the tda18271 driver will work with your tuner, but we may
>>  need to make some small adjustments.  If you look in tda18271-fe.c ,
>>  you'll find the code that autodetects between a TDA18271c1 and a
>>  TDA18271c2 ...
> 
> I just realised there's a problem with versions of code. I'm using
> the code from http://www.linuxtv.org/hg/~anttip/af9015
> However I suppose you want me to use the code from the main
> repository. Needless to say it doesn't work with 0x60 or 0x61
> as the address for the tuner.

You can update af9015-tree to master level easily:
hg pull -u http://linuxtv.org/hg/v4l-dvb
hg merge


> Also if I could somehow get this working with the right
> code, I don't know how to set up the values in the tda182171_config
> struct.

Take USB-sniffs and look there correct configuration values.

regards
Antti
-- 
http://palosaari.fi

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
