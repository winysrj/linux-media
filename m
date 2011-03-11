Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab1CKPk4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 10:40:56 -0500
Message-ID: <4D7A427A.3060303@redhat.com>
Date: Fri, 11 Mar 2011 12:40:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103051402.34416.laurent.pinchart@ideasonboard.com> <4D727F64.7040805@redhat.com> <201103052148.06603.laurent.pinchart@ideasonboard.com> <4D74C82A.9050406@redhat.com>
In-Reply-To: <4D74C82A.9050406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-03-2011 08:57, Mauro Carvalho Chehab escreveu:
> Em 05-03-2011 17:48, Laurent Pinchart escreveu:

> Added both patches and folded them as requested, and added the remaining
> patches after my review. The new tree is at:
> 
> http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/media_controller
> 
> The pending issues for merging it to the main devel branch are:
> 	- omap3isp private control description;
> 	- a renaming patch to make directory name and file names consistent.

Tree updated with the patches from:
	git://linuxtv.org/pinchartl/media.git media-for-mauro

> 	- a chapter describing how *MBUS* and fourcc formats are related;

Still needed. For now, I'll merge what we currently have at the master devel tree,
but we still need such chapter to be written, in order to have the media controller
for .39.

> 	- a description about how to lock between MBUS/fourcc get/set format;

We had some discussions about it, but we didn't reach to a conclusion. I'd like
to see something documented at the v4l framework about that. IMO, this is a good
theme for the V4L "brainstorm" meeting.

I also like to have a patch adding such docs for .39.

Could you please double-check if everything went fine on my merge at:
	http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/media_controller
Before I merge it at the media-tree?

Thanks,
Mauro.

