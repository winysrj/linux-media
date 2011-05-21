Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab1EUK6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 06:58:40 -0400
Message-ID: <4DD79AD9.8010706@redhat.com>
Date: Sat, 21 May 2011 07:58:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Make dvb_net.c optional
References: <201105191035.04185.hselasky@c2i.net>
In-Reply-To: <201105191035.04185.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-05-2011 05:35, Hans Petter Selasky escreveu:
> Hi,
> 
> In my setup I am building the DVB code without dvb_net.c, because there is no 
> IP-stack currently in my "Linux kernel". Is this worth a separate 
> configuration entry?

I have no problems with that, but your patch is wrong ;) It is not adding the new
symbol at the Kconfig. IMHO, if we add such patch, the defaut for config DVB_NET
should be y, and such symbol needs to depend on having the network enabled.

Cheers,
Mauro

> 
> --HPS

