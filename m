Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43484 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751505AbeA2VBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 16:01:20 -0500
Date: Mon, 29 Jan 2018 23:01:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 11/12] v4l2-compat-ioctl32.c: don't copy back the result
 for certain errors
Message-ID: <20180129210118.icliqckuldp3jfwx@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-12-hverkuil@xs4all.nl>
 <20180129095608.d3opjq5zkp72u43e@valkosipuli.retiisi.org.uk>
 <460b8543-8f5b-e5e6-9f4b-578b38695d60@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460b8543-8f5b-e5e6-9f4b-578b38695d60@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 11:02:56AM +0100, Hans Verkuil wrote:
> On 01/29/2018 10:56 AM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Fri, Jan 26, 2018 at 01:43:26PM +0100, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Some ioctls need to copy back the result even if the ioctl returned
> >> an error. However, don't do this for the error codes -ENOTTY, -EFAULT
> >> and -ENOIOCTLCMD. It makes no sense in those cases.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Shouldn't such a change be made to video_usercopy() as well? Doesn't need
> > to be in this set though.
> 
> Good point. I'll add that for v2. This is not actually a bug as such, but
> it's just weird to copy back results if the ioctl wasn't implemented at all.
> 
> I realize that I need to drop the -EFAULT check: if you call VIDIOC_G_EXT_CTRLS
> with an incorrect userspace buffer for the payload, then the control framework
> will set error_idx to the index of the control with the wrong buffer. So you do
> need to copy back the data in case of -EFAULT.
> 
> I can also drop -ENOIOCTLCMD since video_usercopy() converts that to -ENOTTY.

Agreed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
