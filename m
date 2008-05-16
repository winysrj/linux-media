Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JwyA2-000372-Vs
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 13:31:43 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Trevor Boon <trevor_boon@yahoo.com>
In-Reply-To: <671621.54035.qm@web55602.mail.re4.yahoo.com>
References: <671621.54035.qm@web55602.mail.re4.yahoo.com>
Date: Fri, 16 May 2008 13:31:10 +0200
Message-Id: <1210937470.3138.2.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] unknown i2c device on saa7130 card
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

Hi,

Am Donnerstag, den 15.05.2008, 22:25 -0700 schrieb Trevor Boon:
> Hi,
> 
> I've been plugging away blindly trying to get my Leadtek Winfast DTV1000S card working
> While trying to figure out how to find the gpio for the tda10048 to be recognised, I have come across an unknown device using the i2c tools. 
> Can anyone shed some light as to what this device is? 
> 
> ...noting that the tuner is at 0xC0 and the eeprom is at 0xA0 on the same bus
> 
> the i2cdump is as follows:
> 
> No size specified (using byte-data access)
> 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92    }?UfT ?.CC??U???
> 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff    ..??. ..........
> 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff    ?@???.???..?....
> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff    .5.?.???.?......
> 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
> 
> Basic i2cdetect info:
> 
>   Installed I2C busses:
>     i2c-3    smbus         saa7130[0]
>     i2c-0    i2c           NVIDIA i2c adapter 
>     i2c-1    i2c           NVIDIA i2c adapter 
>     i2c-2    i2c           NVIDIA i2c adapter 
> 
> sudo i2cdetect -y 3
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- 08 -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 60: 60 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --                         
> 

0x10 >> 1 is the tda10048 then.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
