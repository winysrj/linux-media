Return-path: <linux-media-owner@vger.kernel.org>
Received: from n15a.bullet.mail.mud.yahoo.com ([68.142.207.125]:22051 "HELO
	n15a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751676AbZFKUaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 16:30:20 -0400
From: David Brownell <david-b@pacbell.net>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
Date: Thu, 11 Jun 2009 13:24:24 -0700
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111324.24438.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 June 2009, m-karicheri2@ti.com wrote:
> VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446
> 
> This is the version v2 of the patch series. This is the reworked
> version of the driver based on comments received against the last
> version of the patch.

I'll be glad to see this get to mainline ... it's seeming closer
and closer!

What's the merge plan though?  I had hopes for 2.6.31.real-soon
but several of the later patches comment

  > Applies to Davinci GIT Tree

which implies "not -next".  DM355 patches are in the "-next" tree.

Is this just an oversight (tracking -next can be a PITA!) or is
there some other dependency?

- dave

