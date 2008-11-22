Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1L3y4P-0003TF-PS
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 20:23:06 +0100
Message-ID: <49285C15.4040903@iki.fi>
Date: Sat, 22 Nov 2008 21:23:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Richard Palmer <richard.palmer@gmail.com>
References: <100c0ba70811181413p57abe7daw1f2ac4a89881d2f8@mail.gmail.com>
In-Reply-To: <100c0ba70811181413p57abe7daw1f2ac4a89881d2f8@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Reception problems with af9015 based USB stick
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

Richard Palmer wrote:
> Hi,
> 
>   After abandoning my nova-t pci card due to the never ending usb
>   disconnect/i2c problems, I thought I'd try a cheap dvb stick from
>   Maplin's (Twinhan af9015 based).

I have same stick here.
> 
>   Whilst it works well in single mode (in dual mode neither tuner
>   worked), there seem to be a lot more 'pops' in the sound and blocks
>   appearing in the picture. Are there any more tuning options I can try when
>   loading the module?. I have re-scanned the channels in MythTV but no
>   improvement. I know it's not a signal strength problem as both a set-top box
>   and the nova-t ran from the same aerial without these problems.

I made test version that uses different tuner driver. Please test if it 
helps. http://linuxtv.org/hg/~anttip/af9015-mxl500x/

> 
>   I'm running Mythbuntu on a 2.6.24-19 kernel.
> 
> Many thanks,
> 
> Richard

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
