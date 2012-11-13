Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1140 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KMH0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 02:26:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 0/3] Remove V4L2 int device and drivers using it
Date: Tue, 13 Nov 2012 08:25:25 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com
References: <20121112224655.GP25623@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121112224655.GP25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211130825.25952.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon November 12 2012 23:46:55 Sakari Ailus wrote:
> Hi all,
> 
> This patchset removes V4L2 int device interface and the two drivers using
> it: omap24xxcam and tcm825x. The status is that these drives do not work;
> the last time I hacked on it I managed to get them to compile about a year
> ago with a number of hacks. There was a hard crash without logs over the
> serial port, after which I had no further time left to continue debugging.
> 
> Where I left off with is available here, in the n800-cam branch. That's not
> pretty. Anyway, that's likely a better starting point than the current
> mainline, should someone have some extra time to spend on this.
> 
> <URL:git://salottisipuli.retiisi.org.uk/~sakke/linux-omap>
> 
> Remove these drivers for now so we can get rid of V4L2 int device. Perhaps I
> will have time to fix them at some point but it'll likely come after the
> N900 support.
> 
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks for looking at this! After removing this nobody can attempt to use the
v4l2_int to implement a i2c/spi driver anymore, something that has happened in
the past. Normally that's not enough reason to remove drivers, but if they
don't work anyway, then I see no problem with that.

Regards,

	Hans
