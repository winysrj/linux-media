Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44082 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab2FTIPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 04:15:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ShG49-0002hz-66
	for linux-media@vger.kernel.org; Wed, 20 Jun 2012 10:15:05 +0200
Received: from cgq171.neoplus.adsl.tpnet.pl ([83.30.244.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 10:15:04 +0200
Received: from acc.for.news by cgq171.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 10:15:04 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: How to make bug report
Date: Mon, 18 Jun 2012 08:40:53 +0200
Message-ID: <p4v2b9-nd7.ln1@wuwek.kopernik.gliwice.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I have four DVB cards:
DVB-S2:
-Pinnacle PCTV SAT HDTV 452E PRO USB (main kernel support)
-Terratec Cinergy S2 USB HD v.2
-Prof Revolution DVB-S2 8000 PCIe
DVB-T:
-AF9015 noname USB (main kernel support)

on AMD Brazos platform (Asrock E350M1) with Debian (lately with 3.4 kernel).

While I could be able to make all of them working via different drivers 
(media-build, patches, vendor drivers, Igor Liplianin's repo, yavdr dkms 
package etc) none of this card works stable (unlike Twinhan PCI I had 
previously). Prof hangs system, Pinnacle doesn't work with DVB-S2, 
Terratec records streams partially unplayable, AF9015 stops working 
after and hour or so etc. Often I see errors of I2C subsystem.

While I'm in process of testing it on different hardware (laptop) I 
would like to know if it's good place to write about dvb drivers bugs. 
Or maybe should I write directly to developer? or write bugs in 
Debian/kernel bugzilla or sth similair?
How to properly report bugs? What kernel should I use, which driverset? 
What logs to attach (kernel.log)? how to enable debug options (if needed)?

I think it's rather unusual all of cards doesn't work, so I suspect that 
there can be something wrong with my system. Maybe you, as skilled 
developers, can direct me what can be wrong, what can I test?

Marx


_______________________________________________
vdr mailing list
vdr@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/vdr


