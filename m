Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51085 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbcFQWjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 18:39:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	pali.rohar@gmail.com, sre@kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Add camera voice coil lens control class, current control
Date: Sat, 18 Jun 2016 01:39:58 +0300
Message-ID: <1475378.4YrS70O1yW@avalon>
In-Reply-To: <20160617221149.GB31380@amd>
References: <20160527205140.GA26767@amd> <575DD89F.20607@gmail.com> <20160617221149.GB31380@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Saturday 18 Jun 2016 00:11:49 Pavel Machek wrote:
> Hi!
> 
> >> I also don't think the FOCUS_ABSOLUTE controls is a really good one for
> >> the voice coil lens current. I expect more voice coil lens controls
> >> (linear vs. PWM mode, ringing compensation...) to be needed so I think
> >> it's worth a new class.
> 
> Well, I do agree that that the new class is fine (and have no problem
> with your proposal), but I'd like to understand why FOCUS_ABSOLUTE is
> unsuitable. I'm actually thinking about writing very simple userspace
> camera, without autofocus, where user would just select
> "infinity"/"1m"/"50cm" ... and for that FOCUS_ABSOLUTE is equivalent
> to VOICE_COIL_CURRENT...
> 
> > Right, I still think movement mode should be standard control :)
> 
> What options would you like to see for movement mode?

I've discussed this with Sakari offline a few days ago. I won't nack this 
patch, but to ack it I'd like to have a better understanding of the big 
picture when it comes to focus and lens control. The proposed new control can 
make sense when taken in isolation, but I can't tell whether it still would 
when associated with the other controls that would be needed to properly 
control a voice coil lens.

If someone has analyzed the existing voice coil lens controllers and could 
share the result, in term of what parameters need to be controlled by the 
system and how they should be controlled, that would be very appreciated. Even 
better would be a real userspace implementation of a voice coil lens control 
algorithm.

-- 
Regards,

Laurent Pinchart

