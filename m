Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45029 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab3JOPWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:22:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: Re: [PATCH v2.1 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Tue, 15 Oct 2013 17:22:50 +0200
Message-ID: <3422963.Ua6Z8kTtzN@avalon>
In-Reply-To: <20131013110313.GC7584@valkosipuli.retiisi.org.uk>
References: <524DEC22.5090107@gmail.com> <1381661924-26365-1-git-send-email-sakari.ailus@iki.fi> <20131013110313.GC7584@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 13 October 2013 14:03:13 Sakari Ailus wrote:
> On Sun, Oct 13, 2013 at 01:58:43PM +0300, Sakari Ailus wrote:
> > Pads that set this flag must be connected by an active link for the entity
> > to stream.
> 
> Oh --- btw. what has changed since v2:
> 
> - Rmoved the last sentence of MEDIA_PAD_FL_MUST_CONNECT documentation. The
>   sentence was about the flag having no effect on pads w/o links.

That change is part of 2/4. I believe that's a mistake.

> - Change Sylwester's e-mail address

-- 
Regards,

Laurent Pinchart

