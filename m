Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33342 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0HWKtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 06:49:36 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3716987bwz.19
        for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 03:49:35 -0700 (PDT)
Date: Mon, 23 Aug 2010 13:50:09 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] V4L/DVB: radio-si4713: Release i2c adapter in
 driver cleanup paths
Message-Id: <20100823135009.f362e812.jhnikula@gmail.com>
In-Reply-To: <20100802130952.bc968de6.jhnikula@gmail.com>
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
	<4C32325E.1060903@gmail.com>
	<20100802130952.bc968de6.jhnikula@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi

On Mon, 2 Aug 2010 13:09:52 +0300
Jarkko Nikula <jhnikula@gmail.com> wrote:

> On Mon, 05 Jul 2010 16:28:30 -0300
> Mauro Carvalho Chehab <maurochehab@gmail.com> wrote:
> 
> > Hi Eduardo,
> > 
> > Could you please review those two patches?
> > 
> Hmm.. are these two patches already late for 2.6.36? I have two another
> patches to arch/arm/mach-omap2/board-rx51-peripherals.c and
> sound/soc/omap/rx51.c that are pending from patch 2/2.
> 
Is there anything I can do with these two patches? Would reposting to
lkml make any sense (like getting nak/ack about regulator framework
conversion etc)? At least I would like to drive these patches to some
conclusion :-)

https://patchwork.kernel.org/patch/105846/
https://patchwork.kernel.org/patch/105847/


-- 
Jarkko
