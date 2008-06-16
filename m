Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@acher.org>) id 1K8L2k-0004rd-Bh
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 22:11:11 +0200
Received: from braindead1.acher.org (91-65-154-251-dynip.superkabel.de
	[91.65.154.251])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTP id DFA96BFD8
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 22:11:01 +0200 (CEST)
Date: Mon, 16 Jun 2008 22:11:01 +0200
From: Georg Acher <acher@in.tum.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080616201101.GA3063@braindead1.acher>
References: <200709032205293433925@sina.com>
	<200806162217.15035.liplianin@me.by>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200806162217.15035.liplianin@me.by>
Subject: Re: [linux-dvb] Driver of STv0288
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

On Mon, Jun 16, 2008 at 10:17:14PM +0300, Igor M. Liplianin wrote:

> Is stv0288 somehow compatible with stv0299?

Not really, they have permuted the registers and a lotof control bits. But
the heritage is clear and it should be a replacement for the stv0299. The
stv0288 can also do a blindscan, but needs a lot of driver support for that
algorithm. 

> Any one who have useful information?

The Reel Multimedia SVN has a GPL'ed DVB-API driver for the stv0288. I don't
know what tweaks are needed for PCI-based cards (if they exist...).

-- 
         Georg Acher, acher@in.tum.de         
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias          

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
