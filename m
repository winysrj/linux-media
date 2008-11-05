Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KxjpN-0008C8-Mn
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 15:57:50 +0100
Received: by ik-out-1112.google.com with SMTP id c28so33135ika.1
	for <linux-dvb@linuxtv.org>; Wed, 05 Nov 2008 06:57:46 -0800 (PST)
Date: Wed, 5 Nov 2008 15:57:34 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20081105143003.GA9384@moelleritberatung.de>
Message-ID: <alpine.DEB.2.00.0811051551240.22461@ybpnyubfg.ybpnyqbznva>
References: <20081105142144.2d44ba9a@realh.co.uk>
	<20081105143003.GA9384@moelleritberatung.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PCI-e drivers
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

On Wed, 5 Nov 2008, Artem Makhutov wrote:

> I have not seen a PCI Express DVB-S2 card at all.
> Can you point me to a vendor who is producing DVB-S2 PCI-Express cards?

If I remember right, when I was searching for DVB-S2-able cards
a couple days ago, there is a new vendor of products, based in
Poland, `X3M', with a number of interesting products available.

Many of the products appear to be based on Conexant cx88-type
demodulators, with various tuner chips, many of which already
have linux-dvb support.

I think there's a hybrid PCI-e card from them.


Of interest to me, if anyone should know, they also have a
DVB-S2 USB device, apparently with supplied Linux drivers --
but the used chipsets aren't listed on the vendor page.

Does anyone know if these various devices will get their
vendor/product IDs added to the sourcecode, or might someone
be able to add info to the Wiki about these products, and
fill in the missing chipset info from their product list?


thanks,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
