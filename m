Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48907 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab1CBSjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 13:39:20 -0500
Received: by qyg14 with SMTP id 14so311714qyg.19
        for <linux-media@vger.kernel.org>; Wed, 02 Mar 2011 10:39:19 -0800 (PST)
References: <20110302181404.6406a3d2@realh.co.uk>
In-Reply-To: <20110302181404.6406a3d2@realh.co.uk>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <3A464BCE-1E30-48D3-B275-99815E1A8983@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Hauppauge "grey" remote not working in recent kernels
Date: Wed, 2 Mar 2011 13:39:32 -0500
To: Tony Houghton <h@realh.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 2, 2011, at 1:14 PM, Tony Houghton wrote:

> Since upgrading my kernel from 2.6.32 to 2.6.37 in Debian my DVB remote
> control no longer works. The card is a Hauppauge Nova-T PCI with the
> "grey" remote. It uses the saa7146, tda1004x, budget_ci and budget_core
> modules (but it doesn't actually have a CI).
> 
> There used to be a patch for the budget_ci driver to support this model
> of remote because the driver's key mappings were incorrect, but that
> patch was no longer necessary from about Linux 2.6.20 onwards. Has there
> been a regression or is there a new problem?
> 
> FWIW I have two cards which used the saa7146, but the other one is DVB-S
> and doesn't have a remote. The one with the remote is adapter1 and the
> one without is adapter0. Could that have anything to do with the
> problem?

There's a pending patchset for ir-kbd-i2c and the hauppauge key tables
that should get you back in working order.


-- 
Jarod Wilson
jarod@wilsonet.com



