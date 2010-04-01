Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4593 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0DAHfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 03:35:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dean A." <dean@sensoray.com>
Subject: Re: [PATCH] s2255drv: removal of big kernel lock
Date: Thu, 1 Apr 2010 09:36:05 +0200
Cc: linux-media@vger.kernel.org
References: <tkrat.01ad6f348d78ae3e@sensoray.com>
In-Reply-To: <tkrat.01ad6f348d78ae3e@sensoray.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004010936.05062.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 31 March 2010 16:41:51 Dean A. wrote:
> # HG changeset patch
> # User Dean Anderson <dean@sensoray.com>
> # Date 1270046291 25200
> # Node ID c72bdc8732abc0cf7bc376babfd06b2d999bdcf4
> # Parent  2ab296deae938864b06b29cc224eb4b670ae3aa9
> s2255drv: removal of BKL
> 
> From: Dean Anderson <dean@sensoray.com>
> 
> big kernel lock removed from open function.
> v4l2 code does not require locking the open function except
> to check asynchronous firmware load state, which is protected
> by a mutex

Can you do the same for the go7007 driver?

And for both drivers you can also switch to using unlocked_ioctl.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
