Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43273 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934295AbaDJS6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 14:58:43 -0400
Message-ID: <5346E9E1.2080702@iki.fi>
Date: Thu, 10 Apr 2014 21:58:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 7/9] Print timestamp type and source for dequeued
 buffers
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-8-git-send-email-sakari.ailus@iki.fi> <5116965.JxiWPkm0Gp@avalon>
In-Reply-To: <5116965.JxiWPkm0Gp@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.
>
> Given that the timestamp type and source are not supposed to change during
> streaming, do we really need to print them for every frame ?

When processing frames from memory to memory (COPY timestamp type), the 
it is entirely possible that the timestamp source changes as the flags 
are copied from the OUTPUT buffer to the CAPTURE buffer.

These patches do not support it but it is allowed.

One option would be to print the source on every frame only when the 
type is COPY. For a program like yavta this might be overly 
sophisticated IMO. :-)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
