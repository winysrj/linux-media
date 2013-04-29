Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3D2Mlz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 08:41:55 -0400
Date: Mon, 29 Apr 2013 09:41:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Lars Buerding <lindvb@metatux.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 00/31] Add r820t support at rtl28xxu
Message-ID: <20130429094127.3a8306fd@redhat.com>
In-Reply-To: <517D5F74.2050106@metatux.net>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
	<517D5F74.2050106@metatux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Apr 2013 19:42:12 +0200
Lars Buerding <lindvb@metatux.net> escreveu:

> On 17.04.2013 02:42, Mauro Carvalho Chehab wrote:
> > Add a tuner driver for Rafael Micro R820T silicon tuner.
> >
> > This tuner seems to be popular those days. Add support for it
> > at rtl28xxu.
> >
> > This tuner was written from scratch, based on rtl-sdr driver.
> 
> Thanks Mauro, applied your patches to a vanilla v3.8.10 kernel yesterday, and a Nooelec r820t stick is working fine with it receiving DVB-T for a VDR. 
> Not any issues so far.

Thanks for your feedback! It's good to hear that everything is working
fine there.

Regards,
Mauro
