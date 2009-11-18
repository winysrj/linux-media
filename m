Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1659 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZKRG3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 01:29:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: v4l: Use the new video_device_node_name function
Date: Wed, 18 Nov 2009 07:29:40 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <1258504731-8430-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911180729.40424.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2009 01:38:43 Laurent Pinchart wrote:
> Fix all device drivers to use the new video_device_node_name function.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

Using video_device_node_name() is a great improvement! Excellent work!

One suggestion, though: I have to agree with the discussion you had with Mauro
on irc yesterday about the /dev/ prefix. I think that should be removed and
doing that in this patch as well makes a lot of sense. No need for a separate
patch to do that as far as I am concerned.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
