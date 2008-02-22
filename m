Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from s1.cableone.net ([24.116.0.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vanessaezekowitz@gmail.com>) id 1JSZCT-0006og-Md
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 15:48:34 +0100
Received: from [72.24.208.253] (unverified [72.24.208.253])
	by S1.cableone.net (CableOne SMTP Service S1) with ESMTP id
	145255556-1872270
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 07:47:58 -0700
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 22 Feb 2008 08:47:03 -0600
References: <20080219065109.199ee966@gaivota> <47BED1E4.1010806@linuxtv.org>
	<47BED898.4070902@linuxtv.org>
In-Reply-To: <47BED898.4070902@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802220847.03466.vanessaezekowitz@gmail.com>
Subject: Re: [linux-dvb] [EXPERIMENTAL] cx88+xc3028 - tests are required -
	was: Re: Wh en xc3028/xc2028 will be supported?
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

On Friday 22 February 2008 8:13:44 am Michael Krufky wrote:
> warn_printk("Closing s5h1409 i2c gate to allow xc3028 detection\n");
>
> to:
>
> warn_printk("Closing s5h1409 i2c gate to allow xc3028 detection\n");

I think you meant:

warn_printk(core, "Closing s5h1409 i2c gate to allow xc3028 detection\n");

(which makes changeset 871db4e0451c compile for me)

however, cx8802 still kernel-BUGs on me when loaded (see "Re: New(ish) card 
support needed, sorta").

-- 
"Life is full of happy and sad events.  If you take the time
to concentrate on the former, you'll get further in life."
Vanessa Ezekowitz  <vanessaezekowitz@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
