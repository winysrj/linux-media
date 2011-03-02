Return-path: <mchehab@pedra>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:33852 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab1CBVPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 16:15:12 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=toddler)
	by mail81.extendcp.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.73)
	id 1Pusw3-0004Uh-TE
	for linux-media@vger.kernel.org; Wed, 02 Mar 2011 20:46:15 +0000
Received: from [127.0.0.1] (helo=toddler)
	by toddler with esmtp (Exim 4.72)
	(envelope-from <h@realh.co.uk>)
	id 1Pusvz-00059I-Kb
	for linux-media@vger.kernel.org; Wed, 02 Mar 2011 20:46:11 +0000
Date: Wed, 2 Mar 2011 20:46:10 +0000
From: Tony Houghton <h@realh.co.uk>
To: <linux-media@vger.kernel.org>
Subject: Re: Hauppauge "grey" remote not working in recent kernels
Message-ID: <20110302204610.464785f5@toddler>
In-Reply-To: <3A464BCE-1E30-48D3-B275-99815E1A8983@wilsonet.com>
References: <20110302181404.6406a3d2@realh.co.uk>
 <3A464BCE-1E30-48D3-B275-99815E1A8983@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2 Mar 2011 13:39:32 -0500
Jarod Wilson <jarod@wilsonet.com> wrote:

> On Mar 2, 2011, at 1:14 PM, Tony Houghton wrote:
> 
> > Since upgrading my kernel from 2.6.32 to 2.6.37 in Debian my DVB
> > remote control no longer works. The card is a Hauppauge Nova-T PCI
> > with the "grey" remote. It uses the saa7146, tda1004x, budget_ci
> > and budget_core modules (but it doesn't actually have a CI).
> 
> There's a pending patchset for ir-kbd-i2c and the hauppauge key tables
> that should get you back in working order.

OK, thanks. Is it possible to download the patch(es) and apply it to a
current kernel or is that a bit complicated?

