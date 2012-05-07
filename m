Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55637 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757204Ab2EGPF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 11:05:27 -0400
Date: Mon, 7 May 2012 18:05:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v5 01/12] V4L: Add helper function for standard integer
 menu controls
Message-ID: <20120507150522.GK852@valkosipuli.localdomain>
References: <4FA64EAB.20600@iki.fi>
 <1336330263-13802-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336330263-13802-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, May 06, 2012 at 08:51:03PM +0200, Sylwester Nawrocki wrote:
> This patch adds v4l2_ctrl_new_int_menu() helper function which can be used
> in drivers for creating standard integer menu control with driver-specific
> menu item list. It is similar to v4l2_ctrl_new_std_menu(), except it doesn't
> have a mask parameter and an additional qmenu parameter allows passing
> an array of signed 64-bit integers as the menu item list.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Tested-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
