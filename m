Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1LIkqO-0006pk-RU
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 15:17:46 +0100
Message-ID: <495E21EB.4090602@rogers.com>
Date: Fri, 02 Jan 2009 09:17:15 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Elio Voci <elio.voci@gmail.com>
References: <1230901740.14839.15.camel@localhost>
In-Reply-To: <1230901740.14839.15.camel@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx frontend does not attach
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

Elio Voci wrote:
> I have generated the firmware from
> http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip,
> Driver85/hcw85bda.sys
>
> em28xx installed correctly, dvb frontend did not:
> zl10353_read_register returned -19
> Below the relevant dmesg section (em28xx modprobed with core_debug=1
> ------------------------------------------------------------------------
>> [ 3435.932331] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
>> [ 3435.948856] xc2028 1-0061: creating new instance

Wrong firmware. You want XC3028, not the XC5000.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
