Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38984 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaFOT7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:59:40 -0400
Message-ID: <539DFB25.9000406@codethink.co.uk>
Date: Sun, 15 Jun 2014 20:59:33 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
CC: horms@verge.net.au, magnus.damm@opensource.se,
	robert.jarzmik@free.fr, g.liakhovetski@gmx.de
Subject: Re: [Linux-kernel] RFC: new soc_camera/rcar_vin patch series
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/06/14 20:56, Ben Dooks wrote:
> This is a new series for the rcar_vin and soc_camera layer
> to support using OF.
> 
> It should incorporate most of the feedback from the previous
> series, but please let me know if there's anything missed. As
> a note, we have skipped over multiple eps for this release as
> there are few scenarios for the driver.
> 
> Testing/feedback welcome.

Forgot, pushed to:

	http://git.codethink.co.uk/linux.git bjdooks/v315/vin-of


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
