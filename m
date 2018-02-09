Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48878 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752089AbeBIMqq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 07:46:46 -0500
Date: Fri, 9 Feb 2018 14:46:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 11/15] media-device.c: zero reserved field
Message-ID: <20180209124644.a6ygvfuamuspaqkm@valkosipuli.retiisi.org.uk>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-12-hverkuil@xs4all.nl>
 <20180209121700.67gibke64bgcewkn@valkosipuli.retiisi.org.uk>
 <8203381a-c3f1-d836-4ed1-54874ac7845e@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8203381a-c3f1-d836-4ed1-54874ac7845e@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 09, 2018 at 01:20:41PM +0100, Hans Verkuil wrote:
> On 02/09/18 13:17, Sakari Ailus wrote:
> > On Thu, Feb 08, 2018 at 09:36:51AM +0100, Hans Verkuil wrote:
> >> MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
> >> struct. Do so in media_device_setup_link().
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/media-device.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >> index e79f72b8b858..afbf23a19e16 100644
> >> --- a/drivers/media/media-device.c
> >> +++ b/drivers/media/media-device.c
> >> @@ -218,6 +218,8 @@ static long media_device_setup_link(struct media_device *mdev,
> >>  	if (link == NULL)
> >>  		return -EINVAL;
> >>  
> >> +	memset(linkd->reserved, 0, sizeof(linkd->reserved));
> >> +
> > 
> > Doesn't media_device_enum_links() need the same for its reserved field?
> 
> enum_links() already zeroes this (actually the whole media_link_desc struct is zeroed).

I can't see that being done in here and I also don't mean the compat
variant. Can you point me to it?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
