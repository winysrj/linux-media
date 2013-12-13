Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52691 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752230Ab3LML3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 06:29:34 -0500
Date: Fri, 13 Dec 2013 13:29:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	David Cohen <dacohen@gmail.com>
Subject: Re: [RFCv2 PATCH 2/2] omap24xx/tcm825x: move to staging for future
 removal.
Message-ID: <20131213112930.GU30652@valkosipuli.retiisi.org.uk>
References: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl>
 <1386851193-3845-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386851193-3845-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Dec 12, 2013 at 01:26:33PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The omap24xx driver and the tcm825x sensor driver are the only two
> remaining drivers to still use the old deprecated v4l2-int-device API.
> 
> Nobody maintains these drivers anymore. But unfortunately the v4l2-int-device
> API is used by out-of-tree drivers (MXC platform). This is a very bad situation
> since as long as this deprecated API stays in the kernel there is no reason for
> those out-of-tree drivers to convert.
> 
> This patch moves v4l2-int-device and the two drivers that depend on it to
> staging in preparation for their removal.

Do you think we should move these to staging instead of removing them right
away? These drivers have never been in a usable state in the mainline
kernel due to missing platform data. Currently they suffer from other
problems, too. I'd be surprised if they compile.

If I wanted to get them working again I'd start with this since it's not
very far from the state where they used to work:

<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux-omap/.git;a=summary>

The branch is n800-cam . Porting to up-to-date APIs can then be done, and I
think David did some work to that end.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
