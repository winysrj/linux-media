Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39954 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbcFQWLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 18:11:52 -0400
Date: Sat, 18 Jun 2016 00:11:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pali.rohar@gmail.com,
	sre@kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20160617221149.GB31380@amd>
References: <20160527205140.GA26767@amd>
 <1465764110-7736-1-git-send-email-sakari.ailus@linux.intel.com>
 <575DD89F.20607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <575DD89F.20607@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> >I also don't think the FOCUS_ABSOLUTE controls is a really good one for
> >the voice coil lens current. I expect more voice coil lens controls
> >(linear vs. PWM mode, ringing compensation...) to be needed so I think
> >it's worth a new class.

Well, I do agree that that the new class is fine (and have no problem
with your proposal), but I'd like to understand why FOCUS_ABSOLUTE is
unsuitable. I'm actually thinking about writing very simple userspace
camera, without autofocus, where user would just select
"infinity"/"1m"/"50cm" ... and for that FOCUS_ABSOLUTE is equivalent
to VOICE_COIL_CURRENT...

> Right, I still think movement mode should be standard control :)

What options would you like to see for movement mode?

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
