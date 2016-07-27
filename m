Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51495
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbcG0NwQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2016 09:52:16 -0400
Date: Wed, 27 Jul 2016 10:52:10 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.8-rc1] media updates part II: documentation
Message-ID: <20160727105210.1e1233c2@recife.lan>
In-Reply-To: <d3a51c25-fe71-46b1-1274-d24da9f8d3c5@xs4all.nl>
References: <20160727062313.375a5cad@recife.lan>
	<d3a51c25-fe71-46b1-1274-d24da9f8d3c5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Jul 2016 11:53:16 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro, Linus,
> 
> On 07/27/2016 11:23 AM, Mauro Carvalho Chehab wrote:
> > Hi Linus,
> > 
> > Please pull from:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-4
> > 
> > For media documentation updates.
> > 
> > This patch series does the conversion of all media documentation stuff
> > to Restrutured Text markup format and add them to the Documentation/index.rst
> > file. The media documentation was grouped into 4 books:
> > 	- media uAPI;
> > 	- media kAPI;
> > 	- V4L driver-specific documentation;
> > 	- DVB driver-specific documentation.
> > 
> > It also contains several documentation improvements and one fixup patch for
> > a core issue with cropcap.  
> 
> FYI: the cropcap fixup patch (v4l2-ioctl: fix stupid mistake in cropcap condition)
> is already upstream (it got merged just before 4.7 was released).
> 
> So that patch can be dropped.

True. Will resend the pull request without that patch.

> 
> Regards,
> 
> 	Hans

-- 
Thanks,
Mauro
