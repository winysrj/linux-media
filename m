Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2262 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab3HBJ4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:56:02 -0400
Message-ID: <51FB821F.4080504@xs4all.nl>
Date: Fri, 02 Aug 2013 11:55:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 9/9] vsp1: Use the maximum number of entities defined
 in platform data
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375405408-17134-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
> From: Katsuya Matsubara <matsu@igel.co.jp>
> 
> The VSP1 driver allows to define the maximum number of each module
> such as RPF, WPF, and UDS in a platform data definition.
> This suppresses operations for nonexistent or unused modules.
> 
> Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
