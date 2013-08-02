Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3079 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3HBJzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:55:50 -0400
Message-ID: <51FB8212.1070800@xs4all.nl>
Date: Fri, 02 Aug 2013 11:55:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 8/9] vsp1: Fix lack of the sink entity registration
 for enabled links
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375405408-17134-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
> From: Katsuya Matsubara <matsu@igel.co.jp>
> 
> Each source entity maintains a pointer to the counterpart sink
> entity while an enabled link connects them. It should be managed by
> the setup_link callback in the media controller framework at runtime.
> However, enabled links which connect RPFs and WPFs that have an
> equivalent index number are created during initialization.
> This registers the pointer to a sink entity from the source entity
> when an enabled link is created.
> 
> Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
