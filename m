Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50260 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751219AbeA3LOL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 06:14:11 -0500
Date: Tue, 30 Jan 2018 13:14:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/12] v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
Message-ID: <20180130111407.rt244fw4intfs3mb@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-3-hverkuil@xs4all.nl>
 <20180126144141.zvl2n4pzxjbyethh@valkosipuli.retiisi.org.uk>
 <816f94a0-e627-2045-63af-69cdae7ec83a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <816f94a0-e627-2045-63af-69cdae7ec83a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 30, 2018 at 09:44:25AM +0100, Hans Verkuil wrote:
> On 01/26/2018 03:41 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Fri, Jan 26, 2018 at 01:43:17PM +0100, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Don't duplicate the buffer type checks in enum/g/s/try_fmt.
> >> The check_fmt function does that already.
> >>
> >> It is hard to keep the checks in sync for all these functions and
> >> in fact the check for VBI was wrong in the _fmt functions as it
> >> allowed SDR types as well. This caused a v4l2-compliance failure
> >> for /dev/swradio0 using vivid.
> >>
> >> This simplifies the code and keeps the check in one place and
> >> fixes the SDR/VBI bug.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 140 ++++++++++++++---------------------
> >>  1 file changed, 54 insertions(+), 86 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> index 59d2100eeff6..c7f6b65d3ad7 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> @@ -1316,52 +1316,50 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
> >>  				struct file *file, void *fh, void *arg)
> >>  {
> >>  	struct v4l2_fmtdesc *p = arg;
> >> -	struct video_device *vfd = video_devdata(file);
> >> -	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> >> -	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> >> -	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
> >> -	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
> >> -	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> >> -	int ret = -EINVAL;
> >> +	int ret = check_fmt(file, p->type);
> > 
> > I'd separate this from the variable declaration. The function is doing more
> > than just fetch something to be used as a shorthand locally. I.e.
> > 
> > 	int ret;
> > 
> > 	ret = check_fmt(file, p->type);
> > 
> > Same elsewhere.
> 
> I'm not making this change. It's been like that since forever, and I don't
> feel I should change this in this patch. I personally don't really care one
> way or another, and especially in smaller functions like v4l_qbuf it
> actually looks kind of weird to change it.
> 
> In any case, a change like that doesn't belong here.

Ack, let's address that separately if we decide to change it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
