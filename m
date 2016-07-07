Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:45644 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbcGGPpm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:45:42 -0400
Subject: Re: [PATCH 02/11] Revert "[media] adv7180: fix broken standards
 handling"
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-3-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <577E7924.9070301@metafoo.de>
Date: Thu, 7 Jul 2016 17:45:40 +0200
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-3-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
> Autodetect was likely broken only because access to the
> interrupt registers were broken, so there were no standard
> change interrupts. After fixing that, and reverting this,
> autodetect seems to work just fine on an i.mx6q SabreAuto.
> 
> This reverts commit 937feeed3f0ae8a0389d5732f6db63dd912acd99.

The brokenness the commit refers to is conceptual not functional. The driver
simply implemented the API incorrect. A subdev driver is not allowed to
automatically switch the output format/resolution randomly. In the best case
this will confuse the receiver which is not prepared to receive the changed
resolution, in the worst case it will cause buffer overruns with hardware
that has no boundary checks. This is why this was removed from the driver.

The correct sequence is for the driver to generate a change notification and
then have userspace react to that notification by stopping the current
stream, query the new format/resolution, reconfigure the video pipeline for
the new format/resolution and re-start the stream.

