Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from faunus.aptilo.com ([62.181.224.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JRlOE-0003OZ-Oo
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 10:37:22 +0100
Received: from [192.168.1.8] (h-49-157.A157.cust.bahnhof.se [79.136.49.157])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by faunus.aptilo.com (Postfix) with ESMTP id 9CDAF1F9062
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 10:36:43 +0100 (CET)
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1203499521.6682.2.camel@acropora>
References: <8ad9209c0802111207t51e82a3eg53cf93c0bda0515b@mail.gmail.com>
	<1202762738.8087.8.camel@youkaida> <1203458171.8019.20.camel@anden.nu>
	<8ad9209c0802192338v66cfb4c4n42d733629421fe6c@mail.gmail.com>
	<1203499521.6682.2.camel@acropora>
Date: Wed, 20 Feb 2008 10:36:39 +0100
Message-Id: <1203500199.10076.29.camel@anden.nu>
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

> The strange thing is that modinfo does not say anything about a level 15
> debug for the dvb_usb_dib0700 module.
> 
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#dvb_usb_dib0700

The debug value is a bit field, with each bit representing a different
category. With all bits on (ie full debugging) the decimal value becomes
15.

  // J


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
