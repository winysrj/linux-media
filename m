Return-path: <linux-media-owner@vger.kernel.org>
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:54042 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307Ab1IXGGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 02:06:12 -0400
Received: from mail615.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 61C8A1008FB5
	for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 07:49:45 +0200 (CEST)
Date: Sat, 24 Sep 2011 07:26:09 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Josh Wu <josh.wu@atmel.com>, nicolas.ferre@atmel.com,
	linux-kernel@vger.kernel.org, s.nawrocki@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on
 sam9m10/sam9g45 board.
Message-ID: <20110924052609.GI29998@game.jcrosoft.org>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
 <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109220911500.11164@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109220911500.11164@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09:35 Thu 22 Sep     , Guennadi Liakhovetski wrote:
> On Thu, 22 Sep 2011, Josh Wu wrote:
> 
> > This patch
> > 1. add ISI_MCK parent setting code when add ISI device.
> > 2. add ov2640 support on board file.
> > 3. define isi_mck clock in sam9g45 chip file.
> > 
> > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > ---
> >  arch/arm/mach-at91/at91sam9g45.c         |    3 +
> >  arch/arm/mach-at91/at91sam9g45_devices.c |  105 +++++++++++++++++++++++++++++-
> >  arch/arm/mach-at91/board-sam9m10g45ek.c  |   85 ++++++++++++++++++++++++-
> >  arch/arm/mach-at91/include/mach/board.h  |    3 +-
> 
> Personally, I think, it would be better to separate this into two patches 
> at least: one for at91 core and one for the specific board, but that's up 
> to arch maintainers to decide.
> 
> You also want to patch arch/arm/mach-at91/at91sam9263_devices.c, don't 
> you?
agreed

Best Regards,
J.
