Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34900 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZBHTyj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2009 14:54:39 -0500
Message-ID: <498F387A.7080606@iki.fi>
Date: Sun, 08 Feb 2009 21:54:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Stefan Czinczoll <schollsky@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: Driver for this DVB-T tuner?
References: <1234122710.31277.5.camel@localhost>
In-Reply-To: <1234122710.31277.5.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Czinczoll wrote:
> I'm trying to get my Terratec DVB-T USB (Cinergy T USB XE MKII) working
> with linux. Any chance in the near future? It works with Windumb & BDA
> drivers, but this is not what i want... ;-)

You should use driver from
http://linuxtv.org/hg/~anttip/mc44s803/

> af9013: firmware version:4.65.0

Use 4.95.0 instead.

> DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
> af9015: Freescale MC44S803 tuner found but no driver for thattuner. Look
> at the Linuxtv.org for tuner driver
> status.

regards
Antti
