Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36258 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750788AbdJBL2s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 07:28:48 -0400
Date: Mon, 2 Oct 2017 14:28:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 1/1] v4l: async: Fix notifier complete callback error
 handling
Message-ID: <20171002112846.ymr4ubrg6nlos6hh@valkosipuli.retiisi.org.uk>
References: <20171002105954.29474-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171002105954.29474-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 02, 2017 at 01:59:54PM +0300, Sakari Ailus wrote:
> The notifier complete callback may return an error. This error code was
> simply returned to the caller but never handled properly.
> 
> Move calling the complete callback function to the caller from
> v4l2_async_test_notify and undo the work that was done either in async
> sub-device or async notifier registration.
> 
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Oh, I forgot to metion this patch depends on another patch here, part of
the fwnode parsing patchset:

<URL:http://www.spinics.net/lists/linux-media/msg122689.html>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
