Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51814 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbcFIXWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 19:22:54 -0400
Date: Fri, 10 Jun 2016 02:22:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Rafael =?iso-8859-1?Q?Louren=E7o?= de Lima Chehab
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH 2/2] [media] media-device: dynamically allocate struct
 media_devnode
Message-ID: <20160609232249.GB26360@valkosipuli.retiisi.org.uk>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
 <83247b8a21c292a08949b3fe619cc56dc4709896.1462633500.git.mchehab@osg.samsung.com>
 <20160606084500.GW26360@valkosipuli.retiisi.org.uk>
 <57560388.7030903@osg.samsung.com>
 <20160607101133.5f13426c@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160607101133.5f13426c@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Jun 07, 2016 at 10:11:33AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 6 Jun 2016 17:13:12 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
> > > A few general comments on the patch --- I agree we've had the problem from
> > > the day one, but it's really started showing up recently. I agree with the
> > > taken approach of separating the lifetimes of both media device and the
> > > devnode. However, I don't think the patch as such is enough.
> 
> Do you or Laurent has an alternative patchset to fix those issues? From 
> where I sit, we have a serious bug that it is already known for a while,
> but nobody really tried to fix so far, except for Shuah and myself.

If I had, I would have posted it. :-I

> So, if you don't have any alternative patch ready to be merged, I'll
> apply what we have later today, together with the patch that fixes cdev
> livetime management:
> 	https://patchwork.linuxtv.org/patch/34201/
> 
> This will allow it to be tested to a broader audience and check if
> the known issues will be fixed. I'll add a C/C stable, but my plan is
> to not send it as a fix for 4.7. Instead, to keep the fixes on our tree
> up to the next merge window, giving us ~5 weeks for testing.
> 
> As this is a Kernel only issue, it can be changed later if someone pops
> up with a better approach.

Ok. I haven't had time to review Shuah's patch but the direction taken sound
good.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
