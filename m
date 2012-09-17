Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40087 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754593Ab2IQJaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 05:30:11 -0400
Date: Mon, 17 Sep 2012 11:30:08 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new
 V4L2_CAP_MONOTONIC_TS capability.
Message-ID: <20120917093008.GA23361@minime.bse>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
 <2870315.6PlfZS62FS@avalon>
 <50564BCE.8010901@gmail.com>
 <4124728.lDo7VTRoK5@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4124728.lDo7VTRoK5@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 11:18:58AM +0200, Laurent Pinchart wrote:
> > >> Well, ALSA allows you to switch between gettimeofday and monotonic. So in
> > >> theory at least if an app selects gettimeofday for alsa, that app might
> > >> also want to select gettimeofday for v4l2.
> 
> Does it, in its kernel API ? The userspace ALSA library (or possibly 
> PulseAudio, I'd need to check) allows converting between clock sources, but I 
> don't think the kernel API supports several clock sources.

See snd_pcm_gettime in <sound/pcm.h>.
This header is not exported to userspace.

  Daniel
