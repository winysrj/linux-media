Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33077 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1LJKUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 05:20:40 -0500
Date: Sat, 10 Dec 2011 12:20:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	riverful.kim@samsung.com
Subject: Re: [RFC/PATCH 0/5] v4l: New camera controls
Message-ID: <20111210102035.GE1967@valkosipuli.localdomain>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <201112061334.45936.laurent.pinchart@ideasonboard.com>
 <4EDF40C6.3010900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDF40C6.3010900@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all!

On Wed, Dec 07, 2011 at 11:32:38AM +0100, Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 12/06/2011 01:34 PM, Laurent Pinchart wrote:
> > On Sunday 04 December 2011 16:16:11 Sylwester Nawrocki wrote:
> >> Hi All,
> >>
> >> I put some effort in preparing a documentation for a couple of new controls
> >> in the camera control class. It's a preeliminary work, it's mainly just
> >> documentation. There is yet no patches for any driver using these controls.
> >> I just wanted to get some possible feedback on them, if this sort of stuff
> >> is welcome and what might need to be done differently.
> > 
> > Thanks for the patches.
> > 
> > Regarding patches 3/5, 4/5 and 5/5, we should perhaps try to brainstorm this a 
> > bit. There's more to exposure setting than just those controls, maybe it's 
> > time to think about a proper exposure API. We could start by gathering 
> > requirements on the list, and maybe have an IRC meeting if needed.
> 
> Certainly the existing support for exposure setting in V4L2 is not sufficient
> even for mobile camera control. I'll try to prepare a list of requirements.
> It would be great to have a brainstorming session with more people experienced
> in this field.

IRC meeting?

The proposed controls seem useful for high level control --- for example,
ISO means a combination of digital and analog gain, and also the unit is
different. In general, I think that even if the three are concerned with
similar issues, the ISO control definitely should belong to a different
class: it requires making policy decisions rather than just providing access
to the sensor features.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
