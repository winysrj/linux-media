Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4968 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbZKOLyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 06:54:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 5/5] go7007: subdev conversion
Date: Sun, 15 Nov 2009 12:54:34 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1257880904.21307.1109.camel@pete-desktop>
In-Reply-To: <1257880904.21307.1109.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911151254.34324.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 November 2009 20:21:44 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> Convert the go7007 driver to v4l2 subdev interface, using v4l2 i2c
> subdev functions instead of i2c functions directly.  The v4l2 ioctl ops
> functions call subdev ops instead of i2c commands.
> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Again, nice work!

It's in much better shape now.

When all this is in we need to take a good look at this and see what
needs to be done to move this driver out of staging.

One thing that needs to be fixed before that can happen is that I
noticed the use of lock_kernel in s2250-loader.c: this should be done
differently. The BKL is slowly being removed throughout the kernel so it
should be removed here as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
