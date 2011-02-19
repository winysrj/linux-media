Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54673 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1BSMJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 07:09:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH v9 01/12] media: Media device node support
Date: Sat, 19 Feb 2011 13:09:13 +0100
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686067-9666-2-git-send-email-laurent.pinchart@ideasonboard.com> <20110218223337.GC25168@sirena.org.uk>
In-Reply-To: <20110218223337.GC25168@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102191309.13896.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mark,

On Friday 18 February 2011 23:33:37 Mark Brown wrote:
> On Mon, Feb 14, 2011 at 01:20:56PM +0100, Laurent Pinchart wrote:
> > +	  Enable the media controller API used to query media devices internal
> > +	  topology and configure it dynamically.
> > +
> > +	  This API is mostly used by camera interfaces in embedded platforms.
> 
> I'd expect this comment is going to bitrot very soon once the framework
> goes in.

Thanks for the comment. I can remove this now, but wouldn't it be better to 
update the description when removing the experimental flag ? We will 
(hopefully) have more users then.

-- 
Regards,

Laurent Pinchart
