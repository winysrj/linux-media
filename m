Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:34135 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543AbZBJTRu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 14:17:50 -0500
Received: from mail-in-16-z2.arcor-online.net (mail-in-16-z2.arcor-online.net [151.189.8.33])
	by mx.arcor.de (Postfix) with ESMTP id A4342259352
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 20:17:48 +0100 (CET)
Received: from mail-in-15.arcor-online.net (mail-in-15.arcor-online.net [151.189.21.55])
	by mail-in-16-z2.arcor-online.net (Postfix) with ESMTP id 9693A254703
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 20:17:48 +0100 (CET)
Received: from webmail19.arcor-online.net (webmail19.arcor-online.net [151.189.8.77])
	by mail-in-15.arcor-online.net (Postfix) with ESMTP id 7D204A3AE1
	for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 20:17:48 +0100 (CET)
Message-ID: <26204941.1234293468460.JavaMail.ngmail@webmail19.arcor-online.net>
Date: Tue, 10 Feb 2009 20:17:48 +0100 (CET)
From: schollsky@arcor.de
To: linux-media@vger.kernel.org
Subject: Re: Driver for this DVB-T tuner?
In-Reply-To: <49909F83.9000607@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
References: <49909F83.9000607@iki.fi> <498F387A.7080606@iki.fi> <1234122710.31277.5.camel@localhost> <3986146.1234210524773.JavaMail.ngmail@webmail12.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 


----- Original Nachricht ----
Von:     Antti Palosaari <crope@iki.fi>
An:      schollsky@arcor.de
Datum:   09.02.2009 22:26
Betreff: Re: Aw: Re: Driver for this DVB-T tuner?

> schollsky@arcor.de wrote:
> > Wow that was fast! Thanks!!!
> > 
> >> You should use driver from
> >> http://linuxtv.org/hg/~anttip/mc44s803/
> > 
> > I managed to do that.
> > 
> >>> af9013: firmware version:4.65.0
> >> Use 4.95.0 instead.
> > 
> > How do I insert it correctly into the source tree? 
> > A short hint (to a readme) should help. 
> 
> Sorry, didn't understand what you mean.

I've downloaded the af9015 firmware version 4.95.0 from here:

http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/

but simply downloading and installing into /lib/firmware seems to be not enough here (Mandriva 2009.0).

> Anyhow, Mauro just committed this driver to the master, you can now use 

I did so, but firmware 4.95.0 is not included?!?

Thanks,

Stefan
