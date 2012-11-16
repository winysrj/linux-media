Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1650 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2KPNyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 08:54:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 3/4] v4l: Convert drivers to use monotonic timestamps
Date: Fri, 16 Nov 2012 14:54:21 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk> <1353017207-370-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1353017207-370-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161454.21083.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu November 15 2012 23:06:46 Sakari Ailus wrote:
> Convert drivers using wall clock time (CLOCK_REALTIME) to timestamp from the
> monotonic timer (CLOCK_MONOTONIC).
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
