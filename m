Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFMCG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 08:02:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Thu, 6 Oct 2011 14:02:04 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <20111005234140.GE8614@valkosipuli.localdomain> <4E8D075E.40702@infradead.org>
In-Reply-To: <4E8D075E.40702@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061402.05364.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 06 October 2011 03:41:50 Mauro Carvalho Chehab wrote:
> Em 05-10-2011 20:41, Sakari Ailus escreveu:
> > On Mon, Oct 03, 2011 at 04:36:44PM -0300, Mauro Carvalho Chehab wrote:
> >> Em 03-10-2011 16:01, Sakari Ailus escreveu:
> >>
> >>> It's the same old issues again... let's discuss this in the Multimedia
> >>> summit.
> >> 
> >> We can discuss more at the summit, but we should start discussing it
> >> here, as otherwise we may not be able to go into a consensus there, due
> >> to the limited amount of time we would have for each topic.
> > 
> > Sounds good to me, but sometimes face-to-face discussion just is not
> > replaceable.
> 
> We've scheduled some time for discussing it there, and we may schedule more
> discussions a about that if needed during the rest of the week.

This is clearly a hot topic, and I believe there are some basic 
misunderstandings (probably on all sides) that would be much easier to solve 
with a face to face meeting. The kernel summit is only a couple of weeks away, 
what about taking a bit of psychological rest until then ? :-)

-- 
Regards,

Laurent Pinchart
