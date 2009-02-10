Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36172 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbZBJUdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 15:33:37 -0500
Message-ID: <4991E49E.9070707@iki.fi>
Date: Tue, 10 Feb 2009 22:33:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: schollsky@arcor.de
CC: linux-media@vger.kernel.org
Subject: Re: Driver for this DVB-T tuner?
References: <18289095.1234295868817.JavaMail.ngmail@webmail15.arcor-online.net> <4991D629.6060100@iki.fi> <49909F83.9000607@iki.fi> <498F387A.7080606@iki.fi> <1234122710.31277.5.camel@localhost> <3986146.1234210524773.JavaMail.ngmail@webmail12.arcor-online.net> <26204941.1234293468460.JavaMail.ngmail@webmail19.arcor-online.net> <28228543.1234296552867.JavaMail.ngmail@webmail15.arcor-online.net>
In-Reply-To: <28228543.1234296552867.JavaMail.ngmail@webmail15.arcor-online.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

schollsky@arcor.de wrote:
> Feb 10 20:10:44 localhost kernel: af9013: firmware version:4.65.0

Still old firmware. What md5sum says?

[root@localhost ~]# md5sum /lib/firmware/dvb-usb-af9015.fw
dccbc92c9168cc629a88b34ee67ede7b  /lib/firmware/dvb-usb-af9015.fw

Antti
-- 
http://palosaari.fi/
