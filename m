Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:38134 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZFSMMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 08:12:12 -0400
Message-ID: <4A3B809D.7050709@linuxtv.org>
Date: Fri, 19 Jun 2009 14:12:13 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@linuxtv.org>
Subject: Re: [PATCH] Use kzalloc for frontend states to have struct dvb_frontend
 properly initialized
References: <200906191321.05477.zzam@gentoo.org>
In-Reply-To: <200906191321.05477.zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Matthias,

Matthias Schwarzott wrote:
> This patch changes most frontend drivers to allocate their state structure via 
> kzalloc and not kmalloc. This is done to properly initialize the 
> embedded "struct dvb_frontend frontend" field, that they all have.
> 
> The visible effect of this struct being uninitalized is, that the member "id" 
> that is used to set the name of kernel thread is totally random.
> 
> Some board drivers (for example cx88-dvb) set this "id" via 
> videobuf_dvb_alloc_frontend but most do not.
> 
> So I at least get random id values for saa7134, flexcop and ttpci based cards. 
> It looks like this in dmesg:
> DVB: registering adapter 1 frontend -10551321 (ST STV0299 DVB-S)
> 
> The related kernel thread then also gets a strange name 
> like "kdvb-ad-1-fe--1".
> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

I still think that this id doesn't belong into struct dvb_frontend and
should be private to the drivers, but using kzalloc is a good idea in
every case. Did you verify that none of the drivers does an additional
memset? If so, you can add my "Acked-by: Andreas Oberritter
<obi@linuxtv.org>".

Regards,
Andreas
