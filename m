Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55150 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1IFKZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 06:25:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [media-ctl][PATCHv5 1/5] libmediactl: restruct error path
Date: Tue, 6 Sep 2011 12:25:33 +0200
Cc: linux-media@vger.kernel.org
References: <201109051657.21646.laurent.pinchart@ideasonboard.com> <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061225.34125.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thank you for the patches.

I've slightly modified 1/5 and 3/5 (the first one returned -1 from 
media_enum_entities(), which made media-ctl stop with a failure message) and 
pushed the result to the repository.

I've also added another patch to fix autoconf malloc/realloc tests when cross-
compiling that resulted in a compilation failure.

-- 
Regards,

Laurent Pinchart
