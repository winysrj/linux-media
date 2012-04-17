Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34920 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932073Ab2DQQJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 12:09:25 -0400
Date: Tue, 17 Apr 2012 19:09:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/15] V4L: Add camera 3A lock control
Message-ID: <20120417160920.GG5356@valkosipuli.localdomain>
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
 <1334657396-5737-11-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334657396-5737-11-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Apr 17, 2012 at 12:09:51PM +0200, Sylwester Nawrocki wrote:
> The V4L2_CID_3A_LOCK bitmask control allows applications to pause
> or resume the automatic exposure, focus and wite balance adjustments.
> It can be used, for example, to lock the 3A adjustments right before
> a still image is captured, for pre-focus, etc.
> The applications can control each of the algorithms independently,
> through a corresponding control bit, if driver allows that.

How is disabling e.g. focus algorithm different from locking focus?

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
