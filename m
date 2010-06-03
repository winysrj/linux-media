Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:38142 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755452Ab0FCP0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 11:26:51 -0400
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Thu, 3 Jun 2010 08:26:43 -0700
Date: Thu, 3 Jun 2010 08:26:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	m-karicheri2@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH-V1 1/2] Davinci: Create seperate Kconfig file for
 davinci devices
Message-Id: <20100603082643.83293005.rdunlap@xenotime.net>
In-Reply-To: <1275547321-31406-2-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
	<1275547321-31406-2-git-send-email-hvaibhav@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  3 Jun 2010 12:12:00 +0530 hvaibhav@ti.com wrote:

> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Currently VPFE Capture driver and DM6446 CCDC driver is being
> reused for AM3517. So this patch is preparing the Kconfig/makefile
> for re-use of such IP's.

Hi,
What are "IP's"?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
