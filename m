Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:30478 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbZBJTb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 14:31:57 -0500
Message-ID: <4991D629.6060100@iki.fi>
Date: Tue, 10 Feb 2009 21:31:53 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: schollsky@arcor.de
CC: linux-media@vger.kernel.org
Subject: Re: Driver for this DVB-T tuner?
References: <49909F83.9000607@iki.fi> <498F387A.7080606@iki.fi> <1234122710.31277.5.camel@localhost> <3986146.1234210524773.JavaMail.ngmail@webmail12.arcor-online.net> <26204941.1234293468460.JavaMail.ngmail@webmail19.arcor-online.net>
In-Reply-To: <26204941.1234293468460.JavaMail.ngmail@webmail19.arcor-online.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

schollsky@arcor.de wrote:
> I've downloaded the af9015 firmware version 4.95.0 from here:
> 
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/

Thats ok

> but simply downloading and installing into /lib/firmware seems to be not enough here (Mandriva 2009.0).

?? How did you installed old 4.65.0 firmware? Just replace 4.65.0 
firmware file (file name is same) with 4.95.0 is enough.

>> Anyhow, Mauro just committed this driver to the master, you can now use 
> 
> I did so, but firmware 4.95.0 is not included?!?

Is not included? Firmware does not come with driver - it should be 
downloaded and installed separately.

What it now prints to the /var/log/messages ?

regards
Antti
-- 
http://palosaari.fi/
