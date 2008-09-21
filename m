Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eazy.amigager.de ([213.239.192.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tino@tikei.de>) id 1KhXxA-0003lo-Cw
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 01:02:57 +0200
Received: from dose.home.local (port-212-202-35-74.dynamic.qsc.de
	[212.202.35.74])
	by eazy.amigager.de (Postfix) with ESMTP id 98669C8C018
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 01:02:52 +0200 (CEST)
Received: from scorpion by dose.home.local with local (Exim 4.69)
	(envelope-from <tino.keitel@tikei.de>) id 1KhXy0-0007eg-3G
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 01:03:48 +0200
Date: Mon, 22 Sep 2008 01:03:48 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080921230348.GA29412@dose.home.local>
References: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
	<48D34D66.7000200@linuxtv.org>
	<dec60b9dbdf2adac0b57a3bf0601ef3b.squirrel@78.226.152.136:8080>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dec60b9dbdf2adac0b57a3bf0601ef3b.squirrel@78.226.152.136:8080>
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
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

On Fri, Sep 19, 2008 at 14:34:50 +0200, Thierry Merle wrote:

[...]

> OK. In my mind this patch was not a priority and some users reported bugs
> but we don't have any news from their part. Maybe buggy users :)
> I will wait just a little at least from Tomi and send a pull request to
> Mauro within the middle of the next week.

I had 2 issues:

- irrecord didn't work

- a failure after resume after suspend with the driver loaded, the
  keyboard went crazy. Unloading the driver and unplugging the
  CinergyT2 helped in this case

I don't know if theses issues are still present, though. I don't use the IR
receiver anymore, and always unload the driver before suspend. I'll try
to update to the current driver and re-test.

Regards,
Tino

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
