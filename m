Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:54719 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbZBJUJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 15:09:22 -0500
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net [151.189.8.85])
	by mx.arcor.de (Postfix) with ESMTP id 82AC028EED7
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 21:09:20 +0100 (CET)
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net [151.189.21.54])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id 74E49107D40
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 21:09:20 +0100 (CET)
Received: from webmail15.arcor-online.net (webmail15.arcor-online.net [151.189.8.68])
	by mail-in-14.arcor-online.net (Postfix) with ESMTP id 967D837E404
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 21:09:15 +0100 (CET)
Message-ID: <28228543.1234296552867.JavaMail.ngmail@webmail15.arcor-online.net>
Date: Tue, 10 Feb 2009 21:09:12 +0100 (CET)
From: schollsky@arcor.de
To: linux-media@vger.kernel.org
Subject: Re: Driver for this DVB-T tuner?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
References: <18289095.1234295868817.JavaMail.ngmail@webmail15.arcor-online.net> <4991D629.6060100@iki.fi> <49909F83.9000607@iki.fi> <498F387A.7080606@iki.fi> <1234122710.31277.5.camel@localhost> <3986146.1234210524773.JavaMail.ngmail@webmail12.arcor-online.net> <26204941.1234293468460.JavaMail.ngmail@webmail19.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti wrote:

> ?? How did you installed old 4.65.0 firmware? Just replace 4.65.0 
> firmware file (file name is same) with 4.95.0 is enough.
> 

I'm not fully sure, if I did it at all, it was from an old, unsuccessful attempt.
Tryed an "updatedb" as root and the only places where I could find it has the new
version. I'm suspecting it comes with standard kernel 2.6.27.10-1 on Mandriva, which
I'm using. Should I deactivate 9015 from standard kernel options?

Anyhow - is there no default place to store firmware when compiling a kernel or modules?

> What it now prints to the /var/log/messages ?

This is still as before:

Feb 10 20:10:44 localhost kernel: af9013: firmware version:4.65.0


Thanks for your help,

Stefan

