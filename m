Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eazy.amigager.de ([213.239.192.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tino@tikei.de>) id 1KhrpP-0000eG-Tb
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 22:16:16 +0200
Received: from dose.home.local (port-212-202-35-74.dynamic.qsc.de
	[212.202.35.74])
	by eazy.amigager.de (Postfix) with ESMTP id 400E5C8C01C
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 22:16:13 +0200 (CEST)
Received: from scorpion by dose.home.local with local (Exim 4.69)
	(envelope-from <tino.keitel@tikei.de>) id 1KhrpM-0002Iw-2b
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 22:16:12 +0200
Date: Mon, 22 Sep 2008 22:16:12 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080922201612.GA8756@dose.home.local>
References: <28756.192.100.124.219.1222068042.squirrel@ncircle.nullnet.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <28756.192.100.124.219.1222068042.squirrel@ncircle.nullnet.fi>
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

On Mon, Sep 22, 2008 at 10:20:42 +0300, Tomi Orava wrote:

[...]

> Could you check what is the firmware version in your device ?
> Check for the "bcdDevice" keyword with lsusb -v -s <busid>:<devnum> I had
> way too many problems with 1.06 firmware version, but the
> newer 1.08 seems to be a little bit better in stability.
> I do think that this device is certainly not the most stable tuner on
> earth but if you don't do suspend/resume with it,
> it should work quite fine.

I have 1.06, but it was rock stable over the years, if I unload the
driver before suspend. And as I use MythTV, the card had pretty much
load (MythTV's EIT crawler).

I just updated to 2.6.27-rc7 and the cinergyT2 driver from
http://linuxtv.org/hg/~tmerle/cinergyT2. Looks good so far.

Regards,
Tino

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
