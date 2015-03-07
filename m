Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35141 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbCGXWC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:22:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for v4.1] smiapp DT u64 property workaround removal
Date: Sun, 08 Mar 2015 01:22:02 +0200
Message-ID: <2889029.OECMz0WOKz@avalon>
In-Reply-To: <20150307232040.GF6539@valkosipuli.retiisi.org.uk>
References: <20150307220634.GD6539@valkosipuli.retiisi.org.uk> <1573085.ZVIDUf0yP4@avalon> <20150307232040.GF6539@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 08 March 2015 01:20:40 Sakari Ailus wrote:
> On Sun, Mar 08, 2015 at 01:15:38AM +0200, Laurent Pinchart wrote:
> > > Sakari Ailus (2):
> > >       Revert "[media] smiapp: Don't compile of_read_number() if
> > >       CONFIG_OF isn't defined"
> > >       smiapp: Use of_property_read_u64_array() to read a 64-bit number
> > >       array
> > 
> > Won't this cause a bisection breakage if CONFIG_OF isn't enabled ?
> 
> Technically you're right: it does "break" bisect if smiapp is compiled in on
> a non-DT platform. Such a platform is not supported in a mainline kernel so
> I don't think this is a really major issue.
> 
> I could combine the patches if you think this is an issue.

It would break bisection with allmodconfig on non-DT platforms for instance. I 
think combining the two patches would make sense.

-- 
Regards,

Laurent Pinchart

