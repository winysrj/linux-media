Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jit4H-0004RR-BE
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 17:15:37 +0200
Message-ID: <47FA3A7A.3010002@iki.fi>
Date: Mon, 07 Apr 2008 18:15:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benoit Paquin <benoitpaquindk@gmail.com>
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
In-Reply-To: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

Benoit Paquin wrote:
> Antti,
>  
> When I tried the Sandberg stick with the AF9015 on an old PC, it 
> reported that the device could not be supported by the USB 1.1 ports. 
> However, according to the AF9015 web page of AFA, it can support USB 1.1:
> 
> AF9015 DVB-T Solution Summary
>   - Afatech's second-generation ETSI ETS 300 744 COFDM terrestrial 
> demodulator. 
>   - Exceeds all performance requirements of Nordig Unified 1.0.2, 
> D-Book, E-Book,  
>   - EN55020 (CE/S1), IEC62002 (MBRAI) and BSMI 
>   - Embedded USB 2.0 PHY, *backward compatible with USB 1.1* 
>   - Integrated TS PID filter (32-entry) 
>   - Support USB suspend mode, capable of entering C3 mode for N/B 
> built-in App. 
>   - Support second MPEG2-TS input/output for PIP, PVR and Dual-Display 
> applications.  
>   - BDA driver supported with WHQL, USB-IF, MCE2005 certified 
>   - Special function support for silicon tuners, e.g. Dynamic 
> Take-Over-Point (TOP) 
>   - Robust mobile performance (Up to 150km/h - single antenna)
> 
> Found at: 
> http://www.usbest.com.tw/EN/products_more.aspx?CategoryID=7&ID=18 
> <http://www.usbest.com.tw/EN/products_more.aspx?CategoryID=7&ID=18>
> 
> Can you explain this? It would be neat if it worked with USB 1.1. There 
> are several old laptops around that could be used as digital video 
> recorder. The main stream vendors (Pinnacle, Hauppauge and ASUS) do not 
> support USB 1.1.

AF9015 chipset does support USB1.1 but driver not. I haven't see this 
important enough to implement yet... It is rather easy to implement, 
lets see if I get inspirations soon ;)

> 
> Thanks and regards,
> 
> Benoit

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
