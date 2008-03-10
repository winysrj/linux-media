Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JYiF3-0001re-2F
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 14:40:56 +0100
Message-ID: <47D539E8.6060204@linuxtv.org>
Date: Mon, 10 Mar 2008 09:38:48 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>	
	<47D49309.8020607@linuxtv.org>	
	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>	
	<47D4B8D0.9090401@linuxtv.org>
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
>>     
>
> [snip]
>
> Also if I could somehow get this working with the right
> code, I don't know how to set up the values in the tda182171_config
> struct.
>   

Jarryd,

Assuming that there is no tda829x analog demod present, and that this is
a digital-only device, try something like this:

static struct tda18271_config jarryd_tda18271_config = {
	.gate = TDA18271_GATE_DIGITAL
}


You should leave .std_map as NULL unless you need to override the default values per standard.

The value in the ".std_bits" corresponds to the lower five bits in EP3 (register 0x05 [4:0])

Most likely, the driver's default setting will work for you, but you
may find that the vendor chose a different value if you sniff the usb
traffic from the windows driver.  This value is directly tied to the IF
frequency between the tuner and demod.

-Mike Krufky


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
