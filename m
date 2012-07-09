Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50896 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab2GIAzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jul 2012 20:55:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1So2Fl-0005AA-UN
	for linux-media@vger.kernel.org; Mon, 09 Jul 2012 02:55:06 +0200
Received: from bb403454.virtua.com.br ([bb403454.virtua.com.br])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 02:55:05 +0200
Received: from diego.cfporto by bb403454.virtua.com.br with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 02:55:05 +0200
To: linux-media@vger.kernel.org
From: Diego Porto <diego.cfporto@gmail.com>
Subject: Geniatech S870 ISDB-T does not work properly on kernels above 3.2
Date: Mon, 9 Jul 2012 00:48:34 +0000 (UTC)
Message-ID: <loom.20120709T024017-786@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to install the v4l-dvb drivers on fedora 17 so I can use my ISDB-T
(Geniatech/MyGica S870) usb card but I'm having some issues...
this is what I did,

- clean install of fedora 17.
- git clone git://linuxtv.org/media_build.git
- cd media_build && ./build && make install
- reboot

then the card starts to work with VLC 2.0, selecting the card as DVB-T.
but other programs like w_scan/vdr/tvheadend/scandvb don't work.


I'm using Fedora17 with kernel 3.4.4-5.fc17.i686


here's the dmesg output, when my card gets plugged in:
http://pastebin.com/QJHrkwsS


here's w_scan output, using "w_scan -c BR >> channels.conf"
http://pastebin.com/pN6vRsUX

* tvheadend detects my card as dvb-s sometimes.
if I restart tvheadend a few times it gets detected as dvb-t (as it normally
would do.) then I'm able to add the multiplexes to tvheadend's list, but
tvheadend scan fails with this error:
http://pastebin.com/U3YCTM6j


and it also produces this message on dmesg:
[  315.447669] dtv_property_cache_sync: doesn't know how to handle a DVBv3 call
to delivery system 0
[  327.947746] dtv_property_cache_sync: doesn't know how to handle a DVBv3 call
to delivery system 0



I tried to do the same thing on ubuntu 12.04 and
downgrading the kernel to 3.2 fixed the problem.
but I need this to work on fedora 17, so how can I fix this?


-- 
Diego Porto
Graduando em Ciência da Computação - UFPB

