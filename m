Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41323 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbZDYKa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 06:30:29 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lxf9Q-0002Xh-4t
	for linux-media@vger.kernel.org; Sat, 25 Apr 2009 10:30:28 +0000
Received: from 41.226.100.198 ([41.226.100.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 25 Apr 2009 10:30:28 +0000
Received: from nizar.saied by 41.226.100.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 25 Apr 2009 10:30:28 +0000
To: linux-media@vger.kernel.org
From: nizar <nizar.saied@gmail.com>
Subject: Re: Support for SkyStar USB 2 ?
Date: Sat, 25 Apr 2009 11:33:03 +0200
Message-ID: <gsuono$iec$1@ger.gmane.org>
References: <25314470.1236090890821.JavaMail.ngmail@webmail15.arcor-online.net> <26537179.1236096877826.JavaMail.ngmail@webmail13.arcor-online.net>
Reply-To: nizar.saied@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <26537179.1236096877826.JavaMail.ngmail@webmail13.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ronny.bantin@nexgo.de wrote:
> Hi,
> 
> the current flexcop-usb driver supports only USB 1.1 devices. Is there any plan to support USB 
> 2.0 devices ? The device id is "13d0:2282". For testing I have simply changed the "flexcop_usb_table" 
> structur to this ids. But of course is does not work.
> 
> The hardware components are the same of the SkyStar2 PCI (CX24113 tuner...).
> 
> Best Regards Ronny.
> 
> 
> Erwischt! Bei Arcor sehen Sie die besten Promi-Bilder riesengroß und in Top-Qualität. Hier finden Sie die schönsten Schnappschüsse auf dem roten Teppich, lernen die Frauen des Womanizers Boris Becker kennen und schauen den Royals ins Wohnzimmer. Viel Spaß auf Ihrer virtuellen Reise durch die Welt der Stars und Sternchen: http://vip.arcor.de.
> --
Hi all
yes I can confirm that skystar usb2.0 has same components as skystar2 
PCI. The only difference is the net2282 PCI-to-USB controller.
Is it possible to find the find the vendor specific protocol from 
usbsnoop log


Thank you
Nizar saied

