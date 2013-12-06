Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51994 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759228Ab3LFWiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Dec 2013 17:38:55 -0500
Date: Sat, 7 Dec 2013 00:38:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH V2 -next] [media] media: i2c: lm3560: fix missing unlock
 on error in lm3560_get_ctrl().
Message-ID: <20131206223851.GJ30652@valkosipuli.retiisi.org.uk>
References: <1386308607-6127-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386308607-6127-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thanks for the update.

On Fri, Dec 06, 2013 at 02:43:27PM +0900, Daniel Jeong wrote:
> Sorry I should have checked below things before sending the first patch.

Applied to my tree with the above line removed, and subject changed slightly
to mention the other change. I hope that's ok for you. The subject becomes
"media: i2c: lm3560: fix missing unlock on error, fault handling".

I'll send a pull req over the week-end.

-- 
Kind regards.

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
