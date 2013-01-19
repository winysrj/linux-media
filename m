Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59995 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab3ASRne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 12:43:34 -0500
Date: Sat, 19 Jan 2013 19:43:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, arun.kk@samsung.com,
	s.nawrocki@samsung.com, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Message-ID: <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <1358156164-11382-4-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358156164-11382-4-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Thanks for the patch.

On Mon, Jan 14, 2013 at 10:36:04AM +0100, Kamil Debski wrote:
> Set proper timestamp type in drivers that I am sure that use either
> MONOTONIC or COPY timestamps. Other drivers will correctly report
> UNKNOWN timestamp type instead of assuming that all drivers use monotonic
> timestamps.

What other kind of timestamps there can be? All drivers (at least those not
mem-to-mem) that do obtain timestamps using system clock use monotonic ones.

I'd think that there should no longer be any drivers using the UNKNOWN
timestamp type: UNKNOWN is either from monotonic or realtime clock, and we
just replaced all of them with the monotonic ones. No driver uses realtime
timestamps anymore.

How about making MONOTONIC timestamps default instead, or at least assigning
all drivers something else than UNKNOWN?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
