Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:46637 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320AbaGGQke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 12:40:34 -0400
Message-ID: <53BACD7E.50606@codethink.co.uk>
Date: Mon, 07 Jul 2014 17:40:30 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Ian Molton <ian.molton@codethink.co.uk>,
	linux-media@vger.kernel.org
CC: linux-kernel@lists.codethink.co.uk, g.liakhovetski@gmx.de,
	m.chehab@samsung.com
Subject: Re: [Linux-kernel] [PATCH 0/4] rcar_vin: fix soc_camera WARN_ON()
 issues.
References: <1404751069-5666-1-git-send-email-ian.molton@codethink.co.uk>
In-Reply-To: <1404751069-5666-1-git-send-email-ian.molton@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/14 17:37, Ian Molton wrote:
> This patch series provides fixes that allow the rcar_vin driver to function
> without triggering dozens of warnings from the videobuf2 and soc_camera layers.
> 
> Patches 2/3 should probably be merged into a single, atomic change, although
> patch 2 does not make the existing situation /worse/ in and of itself.
> 
> Patch 4 does not change the code logic, but is cleaner and less prone to
> breakage caused by furtutre modification. Also, more consistent with the use of
> vb pointers elsewhere in the driver.
> 
> Comments welcome!

You should have probably CC:d the original authors
as well as the linux-sh list and possibly Magnus and
Horms.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
