Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44123 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0FNNKJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 09:10:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OO9QT-0003Sv-11
	for linux-media@vger.kernel.org; Mon, 14 Jun 2010 15:10:05 +0200
Received: from r6af93.net.upc.cz ([89.176.31.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 14 Jun 2010 15:10:05 +0200
Received: from makovick by r6af93.net.upc.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 14 Jun 2010 15:10:05 +0200
To: linux-media@vger.kernel.org
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Mon, 14 Jun 2010 14:27:08 +0200
Message-ID: <20100614142708.668d382e@holly>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
	<YPGdyfWGvNK.A.C8B.d9OFMB@chimera>
	<201006131722.44062.s.L-H@gmx.de>
	<alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de>
	<AANLkTily7ZDG16uE2vSsq8t3mssuATwtHnr8OajX8oga@mail.gmail.com>
	<20100614063948.GA3999@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20100614063948.GA3999@x200>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-testers@vger.kernel.org, linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Jun 2010 09:39:48 +0300
Alexey Dobriyan <adobriyan@gmail.com>
wrote:

> On Sun, Jun 13, 2010 at 01:57:40PM -0600, Grant Likely wrote:
> > On brief review, they look like completely different issues.  I
> > doubt the second patch will fix the flexcop-pci issue.
> 
> It will, see how name wht slashes propagated by request_irq()

Yes, the latter patch dodges the issue with flexcop driver by simply
skipping the directory creation, but both patches should be applied IMO.
The former to fix the flexcop driver because we can trivially fix it,
the latter to solve problems with any generic bogus firmware.

-- 
Jindrich Makovicka


