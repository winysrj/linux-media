Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45095 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753498AbaCGWl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 17:41:57 -0500
Date: Sat, 8 Mar 2014 00:41:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC v7 0/3] add new Dual LED FLASH LM3646
Message-ID: <20140307224121.GU15635@valkosipuli.retiisi.org.uk>
References: <1393840330-11130-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393840330-11130-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Mon, Mar 03, 2014 at 06:52:07PM +0900, Daniel Jeong wrote:
>  This patch is to add new dual led flash, lm3646.
>  LM3646 is the product of ti and it has two 1.5A sync. boost 
>  converter with dual white current source.
>  2 files are created and 4 files are modified.
>  And 3 patch files are created and sent.

Thank you for the patchset. I've applied the patches to my tree with a few
modifications to the commit messages. I also noticed there were some
whitespace issues in the 2nd patch; I fixed those as well.

The patches are in the flash branch.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
