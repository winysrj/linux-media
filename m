Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39747 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704Ab0EBU5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 16:57:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ANNOUNCEMENT] Media controller tree updated
Date: Sun, 2 May 2010 22:58:24 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201004292307.04385.laurent.pinchart@ideasonboard.com> <4BDB7EFA.1020802@redhat.com>
In-Reply-To: <4BDB7EFA.1020802@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005022258.25293.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Saturday 01 May 2010 03:08:10 Mauro Carvalho Chehab wrote:
> Hi Laurent,
> 
> Laurent Pinchart wrote:
> > Hi everybody,
> > 
> > The next version of the media controller patches is available in git at
> > 
> > http://git.linuxtv.org/pinchartl/v4l-dvb-media.git
> > 
> > To avoid putting too much pressure on the linuxtv.org git server, please
> > make sure you reference an existing mainline Linux git tree when cloning
> > v4l-dvb- media (see the --reference option to git-clone).
> 
> I've made a small script that added the proper instructions to the existing
> clones of the kernel tree. Please check if it is ok.

Sounds good. Maybe we should also hint that people can clone the git tree 
using the --reference argument, that saves lots of disk space.

> The script is not automatic. When I have some time, I'll integrate it with
> some tool to run it automatically after a new tree is added there, but,
> for now, I need to run it after I notice that somebody created a new tree.
> The script has a basic test to discover that the tree is based on Kernel
> tree: it checks if a "v2.6.32" tag exist at the new tree (ok, I confess: I
> was very lazy when I wrote the script... it works with the current trees,
> but we need a more reliable way, if we want to run automatically).

-- 
Regards,

Laurent Pinchart
