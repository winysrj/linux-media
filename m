Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45916 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3ABXcP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 18:32:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] mt9p031: Add support for regulators
Date: Thu, 03 Jan 2013 00:33:46 +0100
Message-ID: <1532627.Bp59zG3znG@avalon>
In-Reply-To: <Pine.LNX.4.64.1301022143580.13661@axis700.grange>
References: <1357127200-7672-1-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1301022143580.13661@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review.

On Wednesday 02 January 2013 21:49:53 Guennadi Liakhovetski wrote:
> On Wed, 2 Jan 2013, Laurent Pinchart wrote:
> > Enable the regulators when powering the sensor up, and disable them when
> > powering it down.
> > 
> > The regulators are mandatory. Boards that don't allow controlling the
> > sensor power lines must provide dummy regulators.
> 
> I have been told several times, that (production) systems shouldn't use
> dummy regulators, they can only be used during development until proper
> regulators are implemented. Not that this should affect your patch, just
> maybe we should avoid wording like "must provide dummy regulators" in
> commit descriptions:-)

Dummy was indeed a bad choice of word, I meant fixed voltage regulators. I'll 
fix the commit message.

-- 
Regards,

Laurent Pinchart

