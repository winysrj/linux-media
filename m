Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33968 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1CKPsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 10:48:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Fri, 11 Mar 2011 16:48:49 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D74C82A.9050406@redhat.com> <4D7A427A.3060303@redhat.com>
In-Reply-To: <4D7A427A.3060303@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111648.49658.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Friday 11 March 2011 16:40:42 Mauro Carvalho Chehab wrote:
> Em 07-03-2011 08:57, Mauro Carvalho Chehab escreveu:
> > Em 05-03-2011 17:48, Laurent Pinchart escreveu:
> > 
> > Added both patches and folded them as requested, and added the remaining
> > patches after my review. The new tree is at:
> > 
> > http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/m
> > edia_controller
> > 
> > The pending issues for merging it to the main devel branch are:
> > 	- omap3isp private control description;
> > 	- a renaming patch to make directory name and file names consistent.
> 
> Tree updated with the patches from:
> 	git://linuxtv.org/pinchartl/media.git media-for-mauro

Thanks.

> > 	- a chapter describing how *MBUS* and fourcc formats are related;
> 
> Still needed. For now, I'll merge what we currently have at the master
> devel tree, but we still need such chapter to be written, in order to have
> the media controller for .39.

I plan to discuss this topic during the brainstorming meeting.

> > 	- a description about how to lock between MBUS/fourcc get/set format;
> 
> We had some discussions about it, but we didn't reach to a conclusion.

Documentation/media-framework.txt already states that

"If other operations need to be disallowed on streaming entities (such as
changing entities configuration parameters) drivers can explictly check the
media_entity stream_count field to find out if an entity is streaming. This
operation must be done with the media_device graph_mutex held."

> I'd like to see something documented at the v4l framework about that. IMO,
> this is a good theme for the V4L "brainstorm" meeting.
>
> I also like to have a patch adding such docs for .39.

OK, we'll discuss the topic during the meeting and I'll work on documentation.
 
> Could you please double-check if everything went fine on my merge at:
> 	http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/me
> dia_controller Before I merge it at the media-tree?

Everything is there. Thanks a lot.

-- 
Regards,

Laurent Pinchart
