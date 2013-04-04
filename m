Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:34781 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760708Ab3DDUpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 16:45:25 -0400
Message-ID: <515DE661.2050902@wwwdotorg.org>
Date: Thu, 04 Apr 2013 14:45:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dh09.lee@samsung.com, prabhakar.lad@ti.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de
Subject: Re: [PATCH v7] [media] Add common video interfaces OF bindings documentation
References: <1364313495-18635-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1364313495-18635-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2013 09:58 AM, Sylwester Nawrocki wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> This patch adds a document describing common OF bindings for video
> capture, output and video processing devices. It is curently mainly
> focused on video capture devices, with data busses defined by
> standards such as ITU-R BT.656 or MIPI-CSI2.
> It also documents a method of describing data links between devices.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Stephen Warren <swarren@nvidia.com>
