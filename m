Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1273 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab0DZHze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:55:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Doing a stable v4l-utils release
Date: Mon, 26 Apr 2010 09:55:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4BD5423B.4040200@redhat.com>
In-Reply-To: <4BD5423B.4040200@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004260955.13792.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 26 April 2010 09:35:23 Hans de Goede wrote:
> Hi all,
> 
> Currently v4l-utils is at version 0.7.91, which as the version
> suggests is meant as a beta release.
> 
> As this release seems to be working well I would like to do
> a v4l-utils-0.8.0 release soon. This is a headsup, to give
> people a chance to notify me of any bugs they would like to
> see fixed first / any patches they would like to add first.

This is a good opportunity to mention that I would like to run checkpatch
over the libs and clean them up.

I also know that there is a bug in the control handling code w.r.t.
V4L2_CTRL_FLAG_NEXT_CTRL. I have a patch, but I'd like to do the clean up
first.

If no one else has major patch series that they need to apply, then I can
start working on this. The clean up is just purely whitespace changes to
improve readability, no functionality will be touched.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
