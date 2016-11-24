Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57182 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965768AbcKXOgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 09:36:47 -0500
Date: Thu, 24 Nov 2016 16:36:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
Subject: Re: [PATCH v4l-utils v7 6/7] mediactl: libv4l2subdev: add support
 for comparing mbus formats
Message-ID: <20161124143642.GS16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-7-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476282922-11544-7-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Oct 12, 2016 at 04:35:21PM +0200, Jacek Anaszewski wrote:
> This patch adds a function for checking whether two mbus formats
> are compatible.

Compatible doesn't in general case mean the same as... the same.

On parallel busses a 10-bit source can be connected to an 8-bit sink-for
instance.

How about moving this to the plugin, and if someone else needs it, then we
move it out later?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
