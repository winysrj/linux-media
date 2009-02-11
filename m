Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:38123 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbZBKREJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 12:04:09 -0500
Message-ID: <16077102.1234371844902.JavaMail.ngmail@webmail19.arcor-online.net>
Date: Wed, 11 Feb 2009 18:04:04 +0100 (CET)
From: schollsky@arcor.de
To: crope@iki.fi
Subject: Aw: Re: Driver for this DVB-T tuner?
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti wrote:
 
> Still old firmware. What md5sum says?
> 
> [root@localhost ~]# md5sum /lib/firmware/dvb-usb-af9015.fw
> dccbc92c9168cc629a88b34ee67ede7b  /lib/firmware/dvb-usb-af9015.fw

Same as yours:

$ md5sum /lib/firmware/dvb-usb-af9015.fw 
dccbc92c9168cc629a88b34ee67ede7b  dvb-usb-af9015.fw

Do I have to enable HOTPLUG_PCI additionally to HOTPLUG for kernel?
