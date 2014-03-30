Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:48233 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752150AbaC3Vew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 17:34:52 -0400
Message-ID: <53388DF0.7030500@codethink.co.uk>
Date: Sun, 30 Mar 2014 22:34:40 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Subject: Re: [RFC 2/3] rcar_vin: add devicetree support
References: <1396214765-23689-1-git-send-email-ben.dooks@codethink.co.uk> <1396214765-23689-2-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1396214765-23689-2-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/03/14 22:26, Ben Dooks wrote:
> Add support for devicetree probe for the rcar-vin
> driver.

Sorry, this was an older branch and needed
a fix for the pdev->id field.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
