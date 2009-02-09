Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37042 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbZBIV0a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 16:26:30 -0500
Message-ID: <49909F83.9000607@iki.fi>
Date: Mon, 09 Feb 2009 23:26:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: schollsky@arcor.de
CC: linux-media@vger.kernel.org
Subject: Re: Aw: Re: Driver for this DVB-T tuner?
References: <498F387A.7080606@iki.fi> <1234122710.31277.5.camel@localhost> <3986146.1234210524773.JavaMail.ngmail@webmail12.arcor-online.net>
In-Reply-To: <3986146.1234210524773.JavaMail.ngmail@webmail12.arcor-online.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

schollsky@arcor.de wrote:
> Wow that was fast! Thanks!!!
> 
>> You should use driver from
>> http://linuxtv.org/hg/~anttip/mc44s803/
> 
> I managed to do that.
> 
>>> af9013: firmware version:4.65.0
>> Use 4.95.0 instead.
> 
> How do I insert it correctly into the source tree? 
> A short hint (to a readme) should help. 

Sorry, didn't understand what you mean.

Anyhow, Mauro just committed this driver to the master, you can now use 
v4l-dvb -master instead.
http://linuxtv.org/repo/

regards
Antti
-- 
http://palosaari.fi/
