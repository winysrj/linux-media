Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4635 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3HBJoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:44:54 -0400
Message-ID: <51FB7F82.5070500@xs4all.nl>
Date: Fri, 02 Aug 2013 11:44:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 1/9] media: Add support for circular graph traversal
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375405408-17134-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
> The graph traversal API (media_entity_graph_walk_*) doesn't support
> cyclic graphs and will fail to correctly walk a graph when circular
> links exist. Support circular graph traversal by checking whether an
> entity has already been visited before pushing it to the stack.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
