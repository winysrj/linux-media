Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59966 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3I3Iai (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 04:30:38 -0400
Message-ID: <1380529823.3959.1.camel@pizza.hi.pengutronix.de>
Subject: Re: iram pool not available for MX27
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: linux-media@vger.kernel.org
Date: Mon, 30 Sep 2013 10:30:23 +0200
In-Reply-To: <52490EEB.1090806@gtsys.com.hk>
References: <52490EEB.1090806@gtsys.com.hk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

Am Montag, den 30.09.2013, 13:40 +0800 schrieb Chris Ruehl:
> Hi Phillipp,
> 
> hope things doing OK.
> 
> I recently update to the 3.12-rc kernel and hit this problem below.
> 
> [ 3.377790] coda coda-imx27.0: iram pool not available
> [ 3.383363] coda: probe of coda-imx27.0 failed with error -12
> 
> I read your comments of the patch-set using platform data rather then 
> hard coded addresses to get
> the ocram from a SoC.
> 
> I checked the imx27.dtsi for the iram (coda: coda@..) definition and 
> compare with the former hard coded address and size it matches.
> 
> My .config also has the CONFIG_OF set.
> 
> Any Idea what's go wrong?

do you have the mmio-sram driver enabled (CONFIG_SRAM=y)?

regards
Philipp

