Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1860 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCKS16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 14:27:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for March 11 (staging/multimedia)
Date: Wed, 11 Mar 2009 19:27:50 +0100
Cc: Greg KH <gregkh@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
References: <20090311225913.51589223.sfr@canb.auug.org.au> <20090311181153.GA11088@suse.de> <49B80140.5000304@oracle.com>
In-Reply-To: <49B80140.5000304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111927.51015.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 11 March 2009 19:21:52 Randy Dunlap wrote:
> Greg KH wrote:
> > On Wed, Mar 11, 2009 at 10:12:39AM -0700, Randy Dunlap wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20090310:
> >>
> >> drivers/staging/go7007/go7007-v4l2.c:1830: error: 'VID_TYPE_CAPTURE'
> >> undeclared here (not in a function)
> >
> > Odd, nothing has changed in this driver, is this a v4l api change?
>
> I don't know if the vl4 API changed, but this error has been around
> for some time now.  Just because it's just now being reported is one
> change.  Surely other people build these drivers.  ???
>
>
> I do know that other video drivers (with one exception) don't set:
> 	.vfl_type	= VID_TYPE_CAPTURE,
> at all, so maybe it's not needed (?).

That's correct, this assignment isn't needed. The error appears now since 
VID_TYPE_CAPTURE has been made inaccessible for V4L2 drivers. Only old V4L1 
drivers can use it.

This change was very recent and before that it compiled fine. Although even 
then that code was wrong (but harmless).

Just remove that line and it will compile fine again. Although unless 
someone will take this driver to the next level it will probably break 
again once the old autoprobing i2c API is removed (and that's slated for 
2.6.30 if all goes well).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
