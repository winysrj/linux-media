Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36724 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751517AbaEZU4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 16:56:40 -0400
Message-ID: <5383AA86.5000103@iki.fi>
Date: Mon, 26 May 2014 23:56:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 5/6] v4l: smiapp: Return V4L2_FIELD_NONE from pad-level
 get/set format
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com> <1401131165-3542-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> The SMIA++ sensors are progressive, always return the field order set to
> V4L2_FIELD_NONE.
>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi
