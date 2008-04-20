Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JnZEd-00020E-IZ
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 15:05:36 +0200
Received: by fg-out-1718.google.com with SMTP id 22so1175323fge.25
	for <linux-dvb@linuxtv.org>; Sun, 20 Apr 2008 06:05:32 -0700 (PDT)
Message-ID: <854d46170804200605i711bda4ci2c2e1b78a3e1c47b@mail.gmail.com>
Date: Sun, 20 Apr 2008 15:05:31 +0200
From: "Faruk A" <fa@elwak.com>
To: "Dominik Kuhlen" <dkuhlen@gmx.net>
In-Reply-To: <200804201054.35570.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200804190101.14457.dkuhlen@gmx.net>
	<200804191154.20445.dkuhlen@gmx.net>
	<854d46170804191245m6015dbdpe8b244aa1c884153@mail.gmail.com>
	<200804201054.35570.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
	TT-Connect-S2-3600 final version (RC-keymap)
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

>  > The second patch you posted "patch_multiproto_dvbs2_frequency.diff"
>  > doesn't seem to work for me, it does compile fine but the problem is
>  > loading the the driver.
>  >
>  > insmod stb0899.ko verbose=5
>  >
>  > insmod: error inserting 'stb0899.ko': -1 Unknown symbol in module
>  >
>  > Apr 19 21:22:40 archer usbcore: deregistering interface driver pctv452e
>  > Apr 19 21:22:40 archer dvb-usb: Technotrend TT Connect S2-3600
>  > successfully deinitialized and disconnected.
>  > Apr 19 21:22:40 archer usbcore: deregistering interface driver
>  > dvb-usb-tt-connect-s2-3600-01.fw
>  > Apr 19 21:22:45 archer stb0899: Unknown symbol __divdi3
>  hmm, there might be an issue with the 64-bit arithmetic. what platform are your running?
>  I'll try to convert that back to 32-bit only.

I'm using 32-bit Archlinux kernel 2.6.24.4 and my testing computer spec is:
Dell Optiplex GX620
Pentium D 2.80GHz
2GB RAM, 160GB SATA2.

thanks for "patch_add_tt_s2_3600_rc_keymap.diff" I have tested it with
vdr remote plugin and all keys are working.

If you are going to release another version or future update please
add support for TT connect s2 3650 CI, its same as 3600 but with CI.
+#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI             0x300a

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
