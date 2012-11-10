Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36582 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752232Ab2KJUWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Nov 2012 15:22:40 -0500
Date: Sat, 10 Nov 2012 22:22:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
Message-ID: <20121110202235.GI25623@valkosipuli.retiisi.org.uk>
References: <5097DF9F.6080603@gmx.net>
 <20121106215153.GE25623@valkosipuli.retiisi.org.uk>
 <509A4473.3080506@gmx.net>
 <4541060.0oGRVnU8K8@avalon>
 <20121108092905.GF25623@valkosipuli.retiisi.org.uk>
 <509E5B58.1020108@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509E5B58.1020108@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Sat, Nov 10, 2012 at 02:49:12PM +0100, Andreas Nagel wrote:
> Sakari Ailus schrieb am 08.11.2012 10:29:
> >On Thu, Nov 08, 2012 at 10:26:11AM +0100, Laurent Pinchart wrote:
> >>media-ctl doesn't show pad formats, that's a bit weird. Are you using a recent
> >>version ?
> >This could as well be an issue with the kernel API --- I think that kernel
> >has a version which isn't in mainline. So the IOCTL used to access the media
> >bus formats are quite possibly different.
> >
> >Regards,
> >
> 
> Hi Sakari,
> hi Laurent,
> 
> 
> first, I could resolve my issues.
> 
> When I allocated buffers with the CMEM library from TI (provides
> aligned and contiguous memory buffers), I was able to use user
> pointers. And VIDIOC_STREAMON just failed because of a wrong but
> similar written pixelformat. Since yesterday, I am now able to
> capture frames and save them as YUV data in a file.

Good to hear you got this resolved. Whether the memory is contiguous
shouldn't matter. The ISP has got an MMU. malloc() typically allocated only
page aligned buffer (AFAIR) but to be really sure, one can also use
posix_memalign for the purpose.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
