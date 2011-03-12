Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:51103 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1CLOK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:10:58 -0500
Received: from cmsout01.mbox.net (cmsout01-lo [127.0.0.1])
	by cmsout01.mbox.net (Postfix) with ESMTP id B9EFE2AC377
	for <linux-media@vger.kernel.org>; Sat, 12 Mar 2011 14:10:57 +0000 (GMT)
Date: Sat, 12 Mar 2011 15:10:53 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Ngene cam device name
Mime-Version: 1.0
Message-ID: <391PcLoJ29568S04.1299939053@web04.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> On 03/11/2011 10:44 PM, Martin Vidovic wrote:
> > Andreas Oberritter wrote:
> >> It's rather unintuitive that some CAMs appear as ca0, while others as
> >> cam0.
> >>   
> > Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
> > as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
> > transport stream. To me it  looks like an extension of the current API.
> 
> I see. This raises another problem. How to find out, which ca device
> cam0 relates to, in case there are more ca devices than cam devices?
> 

Are you sure there can be more ca devices than cam devices ? Shouldn't they
come by pair ?

