Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:41857 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753102Ab1EVJSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 05:18:32 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Make dvb_net.c optional
Date: Sun, 22 May 2011 11:17:21 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <201105191035.04185.hselasky@c2i.net> <4DD79AD9.8010706@redhat.com>
In-Reply-To: <4DD79AD9.8010706@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105221117.21632.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 21 May 2011 12:58:33 Mauro Carvalho Chehab wrote:
> Em 19-05-2011 05:35, Hans Petter Selasky escreveu:
> > Hi,
> > 
> > In my setup I am building the DVB code without dvb_net.c, because there
> > is no IP-stack currently in my "Linux kernel". Is this worth a separate
> > configuration entry?
> 
> I have no problems with that, but your patch is wrong ;) It is not adding
> the new symbol at the Kconfig. IMHO, if we add such patch, the defaut for
> config DVB_NET should be y, and such symbol needs to depend on having the
> network enabled.

Yes, I know my patch is not complete. Then I will go ahead and make a complete 
patch and post it. Thank you!

--HPS
