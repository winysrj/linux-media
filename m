Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRlVT-0004rt-8Z
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 10:44:51 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id EF7D0D8811B
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 10:43:44 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1203500199.10076.29.camel@anden.nu>
References: <8ad9209c0802111207t51e82a3eg53cf93c0bda0515b@mail.gmail.com>
	<1202762738.8087.8.camel@youkaida> <1203458171.8019.20.camel@anden.nu>
	<8ad9209c0802192338v66cfb4c4n42d733629421fe6c@mail.gmail.com>
	<1203499521.6682.2.camel@acropora> <1203500199.10076.29.camel@anden.nu>
Date: Wed, 20 Feb 2008 09:43:25 +0000
Message-Id: <1203500605.6682.12.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Very quiet around Nova-T 500
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


On Wed, 2008-02-20 at 10:36 +0100, Jonas Anden wrote:
> > The strange thing is that modinfo does not say anything about a
> level 15
> > debug for the dvb_usb_dib0700 module.
> > 
> >
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#dvb_usb_dib0700
> 
> The debug value is a bit field, with each bit representing a different
> category. With all bits on (ie full debugging) the decimal value
> becomes
> 15.

I should have guessed.

Documented for poor souls with slow brains like me.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
