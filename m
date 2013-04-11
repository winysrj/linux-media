Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtp18-02-2.prod.phx3.secureserver.net ([173.201.193.184]:42708
	"EHLO p3plwbeout18-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3DKHVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 03:21:47 -0400
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Message-Id: <20130411002145.e7c3a0fec861aa4693105436139f36a5.dcced109aa.wbe@email18.secureserver.net>
From: <leo@lumanate.com>
To: "Hans Verkuil" <hansverk@cisco.com>, linux-media@vger.kernel.org
Cc: "Janne Grunau" <j@jannau.net>,
	"Hans Verkuil" <hans.verkuil@cisco.com>
Subject: RE: [REVIEWv2 PATCH 12/12] hdpvr: allow =?UTF-8?Q?g/s=5Fstd=20when=20in?=
 =?UTF-8?Q?=20legacy=20mode=2E?=
Date: Thu, 11 Apr 2013 00:21:45 -0700
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

The current HEAD is working for both MythTV and gstreamer!

Will you be doing more work on hdpvr? Should I start
looking into error handling and kmallocs?

Thank you,
-Leo.


-------- Original Message --------
Subject: Re: [REVIEWv2 PATCH 12/12] hdpvr: allow g/s_std when in legacy
mode.
From: Hans Verkuil <hansverk@cisco.com>
Date: Wed, April 10, 2013 10:25 am
To: linux-media@vger.kernel.org
Cc: leo@lumanate.com, Janne Grunau <j@jannau.net>, Hans Verkuil
<hans.verkuil@cisco.com>

On Wed April 10 2013 18:27:43 Hans Verkuil wrote:
> Leo, can you verify that this works for you as well? I tested it without
> problems with MythTV and gstreamer.
> 
> Thanks!
> 
> Hans
> 
> Both MythTV and gstreamer expect that they can set/get/query/enumerate the
> standards, even if the input is the component input for which standards
> really do not apply.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> drivers/media/usb/hdpvr/hdpvr-video.c | 40 ++++++++++++++++++++++++---------
> 1 file changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 4376309..38724d7 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c


> -static int vidioc_enum_input(struct file *file, void *priv,
> - struct v4l2_input *i)
> +static int vidioc_enum_input(struct file *file, void *_fh, struct v4l2_input *i)
> {
> + struct hdpvr_fh *fh = _fh;
> unsigned int n;
> 
> n = i->index;
> @@ -758,13 +761,15 @@ static int vidioc_enum_input(struct file *file, void *priv,
> 
> i->audioset = 1<<HDPVR_RCA_FRONT | 1><<HDPVR_RCA_BACK | 1><<HDPVR_SPDIF;
> 
> + if (fh->legacy_mode)
> + n = 1;

Oops, these two lines should be removed. Otherwise non-legacy apps like
qv4l2 will
break as they rely on accurate capability reporting.

> i->capabilities = n ? V4L2_IN_CAP_STD : V4L2_IN_CAP_DV_TIMINGS;
> i->std = n ? V4L2_STD_ALL : 0;
> 
> return 0;
> }

Regards,

 Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-media"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
