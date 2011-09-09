Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36258 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab1IIPI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 11:08:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC][PATCH] as3645a: introduce new LED Flash driver
Date: Fri, 9 Sep 2011 17:08:01 +0200
Cc: "Ivan T . Ivanov" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org, Tuukka Toivonen <tuukkat76@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <020b9977ca7e8f0eabfe1b52b7f37a2105611605.1315580169.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <020b9977ca7e8f0eabfe1b52b7f37a2105611605.1315580169.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109091708.02328.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Friday 09 September 2011 16:59:31 Andy Shevchenko wrote:
> The driver supports the AS3645A, LM3555 chips and their clones.
> 
> Accordingly to datasheet the AS3645 chip is a "1000/720mA Ultra Small High
> efficient single/dual LED Flash Driver with Safety Features". LM3555 is
> similar one, that has following difference - the current in the torch mode
> is the same (60mA) for the levels 0, 1, and 2.
> 
> This driver is a huge rework of the previously published driver which could
> be found in the MeeGo kernel package.

Thank you for the patch.

I was about to send a new AS3645A driver version that supports more chip 
features. I will CC you.

-- 
Regards,

Laurent Pinchart
