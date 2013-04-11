Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:34779 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3DKHsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 03:48:35 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: leo@lumanate.com
Subject: Re: [REVIEWv2 PATCH 12/12] hdpvr: allow g/s_std when in legacy mode.
Date: Thu, 11 Apr 2013 09:47:57 +0200
Cc: linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <20130411002145.e7c3a0fec861aa4693105436139f36a5.dcced109aa.wbe@email18.secureserver.net>
In-Reply-To: <20130411002145.e7c3a0fec861aa4693105436139f36a5.dcced109aa.wbe@email18.secureserver.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304110947.57864.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 11 April 2013 09:21:45 leo@lumanate.com wrote:
> Hans,
> 
> The current HEAD is working for both MythTV and gstreamer!
> 
> Will you be doing more work on hdpvr? Should I start
> looking into error handling and kmallocs?

No, that's it. I'll post a pull request with all this tomorrow.

Feel free to work on improvements, but they'll be queued for kernel 3.11
since tomorrow is the last chance for patches for 3.10.

Thanks for your help testing this! Much appreciated.

Regards,

	Hans

> 
> Thank you,
> -Leo.
> 
> 
> -------- Original Message --------
> Subject: Re: [REVIEWv2 PATCH 12/12] hdpvr: allow g/s_std when in legacy
> mode.
> From: Hans Verkuil <hansverk@cisco.com>
> Date: Wed, April 10, 2013 10:25 am
> To: linux-media@vger.kernel.org
> Cc: leo@lumanate.com, Janne Grunau <j@jannau.net>, Hans Verkuil
> <hans.verkuil@cisco.com>
> 
> On Wed April 10 2013 18:27:43 Hans Verkuil wrote:
> > Leo, can you verify that this works for you as well? I tested it without
> > problems with MythTV and gstreamer.
> > 
> > Thanks!
> > 
> > Hans
> > 
> > Both MythTV and gstreamer expect that they can set/get/query/enumerate the
> > standards, even if the input is the component input for which standards
> > really do not apply.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> > drivers/media/usb/hdpvr/hdpvr-video.c | 40 ++++++++++++++++++++++++---------
> > 1 file changed, 29 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> > index 4376309..38724d7 100644
> > --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> > +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> 
> 
> > -static int vidioc_enum_input(struct file *file, void *priv,
> > - struct v4l2_input *i)
> > +static int vidioc_enum_input(struct file *file, void *_fh, struct v4l2_input *i)
> > {
> > + struct hdpvr_fh *fh = _fh;
> > unsigned int n;
> > 
> > n = i->index;
> > @@ -758,13 +761,15 @@ static int vidioc_enum_input(struct file *file, void *priv,
> > 
> > i->audioset = 1<<HDPVR_RCA_FRONT | 1><<HDPVR_RCA_BACK | 1><<HDPVR_SPDIF;
> > 
> > + if (fh->legacy_mode)
> > + n = 1;
> 
> Oops, these two lines should be removed. Otherwise non-legacy apps like
> qv4l2 will
> break as they rely on accurate capability reporting.
> 
> > i->capabilities = n ? V4L2_IN_CAP_STD : V4L2_IN_CAP_DV_TIMINGS;
> > i->std = n ? V4L2_STD_ALL : 0;
> > 
> > return 0;
> > }
> 
> Regards,
> 
>  Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 
