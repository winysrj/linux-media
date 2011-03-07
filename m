Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1CGNiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 08:38:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Mon, 7 Mar 2011 14:38:24 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103052148.06603.laurent.pinchart@ideasonboard.com> <4D74C82A.9050406@redhat.com>
In-Reply-To: <4D74C82A.9050406@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201103071438.25685.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Monday 07 March 2011 12:57:30 Mauro Carvalho Chehab wrote:
> Em 05-03-2011 17:48, Laurent Pinchart escreveu:

[snip]

> Added both patches and folded them as requested, and added the remaining
> patches after my review. The new tree is at:
> 
> http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/med
> ia_controller
> 
> The pending issues for merging it to the main devel branch are:
> 	- omap3isp private control description;

Still working on that, I expect to send it this evening.

> 	- a chapter describing how *MBUS* and fourcc formats are related;

This still needs to be discussed, there's no agreement on that yet.

> 	- a description about how to lock between MBUS/fourcc get/set format;

>From Documentation/media-framework.txt:

"If other operations need to be disallowed on streaming entities (such as
changing entities configuration parameters) drivers can explictly check the
media_entity stream_count field to find out if an entity is streaming. This
operation must be done with the media_device graph_mutex held."

So it's already there :-) And the media_entity_pipeline_start() function makes 
it easy to implement in bridge driver.

> 	- a renaming patch to make directory name and file names consistent.

Done. I've pushed the modified patches to the media-2.6.39-0005-omap3isp 
branch.

The media-2.6.39-0004-v4l-misc branch has also been rebased to squash the 
format documentation patches as you did in your tree. There's no need to pull 
anything from it.

-- 
Regards,

Laurent Pinchart
