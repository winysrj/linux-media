Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:53703 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490AbZCCQOq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 11:14:46 -0500
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id 45A39332758
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2009 17:14:39 +0100 (CET)
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net [151.189.21.53])
	by mail-in-05-z2.arcor-online.net (Postfix) with ESMTP id ACD4D2DAC1F
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2009 17:14:38 +0100 (CET)
Received: from webmail13.arcor-online.net (webmail13.arcor-online.net [151.189.8.66])
	by mail-in-13.arcor-online.net (Postfix) with ESMTP id D7B9F2BAF36
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2009 17:14:37 +0100 (CET)
Message-ID: <26537179.1236096877826.JavaMail.ngmail@webmail13.arcor-online.net>
Date: Tue, 3 Mar 2009 17:14:37 +0100 (CET)
From: ronny.bantin@nexgo.de
To: linux-media@vger.kernel.org
Subject: Support for SkyStar USB 2 ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
References: <25314470.1236090890821.JavaMail.ngmail@webmail15.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the current flexcop-usb driver supports only USB 1.1 devices. Is there any plan to support USB 
2.0 devices ? The device id is "13d0:2282". For testing I have simply changed the "flexcop_usb_table" 
structur to this ids. But of course is does not work.

The hardware components are the same of the SkyStar2 PCI (CX24113 tuner...).

Best Regards Ronny.


Erwischt! Bei Arcor sehen Sie die besten Promi-Bilder riesengroß und in Top-Qualität. Hier finden Sie die schönsten Schnappschüsse auf dem roten Teppich, lernen die Frauen des Womanizers Boris Becker kennen und schauen den Royals ins Wohnzimmer. Viel Spaß auf Ihrer virtuellen Reise durch die Welt der Stars und Sternchen: http://vip.arcor.de.
