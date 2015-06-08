Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53475 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbFHVCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 17:02:44 -0400
Date: Mon, 8 Jun 2015 22:52:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 18/26] [media] dvb: Get rid of typedev usage for enums
Message-ID: <20150608225240.06741b6f@kant>
In-Reply-To: <336c59e13064f2fa872a1682268f1995deb18fa5.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
	<336c59e13064f2fa872a1682268f1995deb18fa5.1433792665.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jun 08 Mauro Carvalho Chehab wrote:
> The DVB API was originally defined using typedefs. This is against
> Kernel CodingStyle, and there's no good usage here. While we can't
> remove its usage on userspace, we can avoid its usage in Kernelspace.
[...]

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (drivers/media/firewire/*)
-- 
Stefan Richter
-=====-===== -==- -=---
http://arcgraph.de/sr/
