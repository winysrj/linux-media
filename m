Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1595 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CTVxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 17:53:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Sat, 20 Mar 2010 22:53:04 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
References: <201003200958.49649.hverkuil@xs4all.nl>
In-Reply-To: <201003200958.49649.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003202253.04191.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
> 
> Kconfig mistakes:
> 
> I found four errors in drivers/media/video/Kconfig: the saa7191, meye, mxb
> and cpia2 drivers are all marked as V4L1 only, while all support V4L2!
> The cpia2 driver supports both v4l1 and v4l2. I can test this driver and
> will look at removing the V4L1 support from that driver.

The pwc driver also depends on V4L1, but also contains V4L2 support.
Can someone test this driver? It is easy to remove the V4L1 code, but I'm
not sure how well the V4L2 code works.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
