Return-path: <linux-media-owner@vger.kernel.org>
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:35955 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933682Ab1IOOUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 10:20:36 -0400
Received: from mail240.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo2.mail-out.ovh.net (Postfix) with SMTP id 217A1DCDA15
	for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 15:45:59 +0200 (CEST)
Date: Thu, 15 Sep 2011 15:23:01 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] at91: add code to initialize and manage the
 ISI_MCK for Atmel ISI driver.
Message-ID: <20110915132301.GK28104@game.jcrosoft.org>
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
 <20110906200512.GA15083@game.jcrosoft.org>
 <4E668BBF.4020600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E668BBF.4020600@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23:08 Tue 06 Sep     , Sylwester Nawrocki wrote:
> On 09/06/2011 10:05 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> I'm not entirely sure on this one, but as we had a similar situation with
> >> clocks, we decided to extablish the clock hierarchy in the board code, and
> >> only deal with the actual device clocks in the driver itself. I.e., we
> >> moved all clk_set_parent() and setting up the parent clock into the board.
> >> And I do think, this makes more sense, than doing this in the driver, not
> >> all users of this driver will need to manage the parent clock, right?
> >
> > I don't like to manage the clock in the board except if it's manadatory otherwise
> > we manage this at soc level
> > 
> > the driver does not have to manage the clock hierachy or detail implementation
> > but manage the clock enable/disable and speed depending on it's need
> 
> We had a similar problem in the past and we ended up having the boot loader
> setting up the parent clock for the device clock. The driver only controls clock
> gating and sets its clock frequency based on an internal IP version information,
> derived from the SoC revision.
sorry NACK

I do not want to rely on bootloader
when we will have the DT we will pass it via it right now we need find an
other generic way

Best Regards,
J.
