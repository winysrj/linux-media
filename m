Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LIl9l-0001kN-QC
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 15:37:51 +0100
Received: by qw-out-2122.google.com with SMTP id 9so3116916qwb.17
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 06:37:41 -0800 (PST)
Message-ID: <412bdbff0901020637l479a6cd0nb8a1e7764c9135e7@mail.gmail.com>
Date: Fri, 2 Jan 2009 09:37:41 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: CityK <cityk@rogers.com>
In-Reply-To: <495E21EB.4090602@rogers.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1230901740.14839.15.camel@localhost> <495E21EB.4090602@rogers.com>
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

On Fri, Jan 2, 2009 at 9:17 AM, CityK <cityk@rogers.com> wrote:
> Elio Voci wrote:
>> I have generated the firmware from
>> http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip,
>> Driver85/hcw85bda.sys
>>
>> em28xx installed correctly, dvb frontend did not:
>> zl10353_read_register returned -19
>> Below the relevant dmesg section (em28xx modprobed with core_debug=1
>> ------------------------------------------------------------------------
>>> [ 3435.932331] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
>>> [ 3435.948856] xc2028 1-0061: creating new instance
>
> Wrong firmware. You want XC3028, not the XC5000.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

It doesn't matter - the Cinergy Hybrid is known to not work.  It's on
my TODO list, but this is complicated by the fact that I have neither
the hardware nor the DVB-T signal to debug the issue with.

Patches welcome, of course!

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
