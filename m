Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64787 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaGIUeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 16:34:13 -0400
Date: Wed, 9 Jul 2014 22:34:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian.molton@codethink.co.uk>
cc: linux-media@vger.kernel.org,
	William Towle <william.towle@codethink.co.uk>,
	mchehab@redhat.com, hans.verkuil@cisco.com,
	sylvester.nawrocki@gmail.com, vladimir.barinov@cogentembedded.com
Subject: Re: RFC: soc_camera, rcar_vin, and adv7604
In-Reply-To: <20140709174225.63a742ce09418cff539bb70a@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1407091955080.25501@axis700.grange>
References: <20140709174225.63a742ce09418cff539bb70a@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

(disclaimer: I was away for the last two weeks with no proper access to my 
email, so, will be slowly fighting through my mail backlog, I know there 
have been a few mails re: soc-camera + DT etc., please, bear with me)

On Wed, 9 Jul 2014, Ian Molton wrote:

> Hi folks,
> 
> My colleague and I are trying to work out what to do to support the 
> following combination:
> 
> soc_camera + rcar_vin for capture, and the mainline adv7604 driver 
> (which we have modified to successfully drive the adv7612).
> 
> The problem we face is that the 7604 driver uses the new "pads" API, but 
> soc_camera based drivers like rcar_vin do not.

I'm not a huge expert in the pad-level API, but from what I understand 
there are at least two aspects to it:

1. subdevice pad-level API, which is just a newer, than the used by 
soc-camera subdevice API.

2. pad-level ioctl()s, exported to the user space, IIUC, as a part of the 
media controller API.

For (2) - yes, soc-camera core support would need to be added, possibly 
with larger changes. Whereas for (1) it's only the host that has to use 
the pad-level API to access subdevice drivers. Interaction between camera 
host and subdevice drivers in soc-camera is direct, so, no soc-camera core 
modifications would be needed. Maybe we dould add some support, say, to 
help with (fake) file handles just to aid the transition. We might also 
add wrappers for subdev drivers, not implementing the pad-level API to 
avoid having host drivers support both APIs, but those are just 
convenience modifications.

I might well be wrong. Please, correct me if so.

Thanks
Guennadi

> Obviously, there are a few approaches we could take, but we could use 
> some guidance on this.
> 
> One approach would be to bodge some non-pads older API support into the 
> 7604 driver. This would probably be the easiest solution.
> 
> A better approach might be to add pad API support to soc_camera, but it 
> seems to me that the soc_camera API does not abstract away all of the 
> areas that might need to be touched, which would lead to much 
> pad-related churn in all the other soc_camera drivers.
> 
> The codebase is rather large, and we're struggling to see a clear path 
> through this. Whatever we do, we would like to be acceptable upstream, 
> so we'd like to open a discussion.
> 
> Perhaps a soc_camera2 with pads support?
> 
> -- 
> Ian Molton <ian.molton@codethink.co.uk>
> 
