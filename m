Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55853 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaEIMJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:09:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Smiapp quirk call order and best scaling ratio fixes
Date: Fri, 09 May 2014 14:09:32 +0200
Message-ID: <2057396.LUSOhzWLnK@avalon>
In-Reply-To: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patches.

On Wednesday 23 April 2014 22:33:56 Sakari Ailus wrote:
> Hi,
> 
> The most important patch is the third one: wrong scaling ratio was selected
> in many (or most?) cases due to the wrong signedness of the variable. The
> other two have less effect on the functionality.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

