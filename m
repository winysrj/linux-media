Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:60555 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080Ab2K0QzT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:55:19 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 08:54:17 -0800
Subject: RE: [PATCH 11/15] [media] marvell-ccic: add soc_camera support in
 mcam core
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C91F@SC-VEXCH1.marvell.com>
References: <1353677659-24324-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271516010.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C90C@SC-VEXCH1.marvell.com>
 <Pine.LNX.4.64.1211271740410.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271740410.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks
Albert Wang
86-21-61092656


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 28 November, 2012 00:50
>To: Albert Wang
>Cc: corbet@lwn.net; Linux Media Mailing List; Libin Yang
>Subject: RE: [PATCH 11/15] [media] marvell-ccic: add soc_camera support in mcam
>core
>
>On Tue, 27 Nov 2012, Albert Wang wrote:
>
>[snip]
>
>> >> +static int mcam_camera_set_fmt(struct soc_camera_device *icd,
>> >> +                    struct v4l2_format *f) {
>> >> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> >> +    struct mcam_camera *mcam = ici->priv;
>> >> +    const struct soc_camera_format_xlate *xlate = NULL;
>> >> +    struct v4l2_mbus_framefmt mf;
>> >> +    struct v4l2_pix_format *pix = &f->fmt.pix;
>> >> +    int ret = 0;
>> >
>> >No need to initialise ret.
>> >
>> Yes, but it looks there is no "bad" impact if we initialize it. :) I
>> just want to keep the rule: initialize it before use it. :)
>
>No, please, don't. Firstly, it adds bloat. Secondly, such "blind"
>initialisation can hide real bugs: the variable is initialised, so the compiler doesn't
>complain, then you use it in your code, but in reality, the value, that you used is
>meaningless in your context and you get a hidden bug.
>
I have to agree with you at the second reason.
So, I will double check them in our patches and remove them in the next version.

>[snip]
>
>> >> +static int mcam_camera_try_fmt(struct soc_camera_device *icd,
>> >> +                    struct v4l2_format *f) {
>> >> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> >> +    struct mcam_camera *mcam = ici->priv;
>> >> +    const struct soc_camera_format_xlate *xlate;
>> >> +    struct v4l2_pix_format *pix = &f->fmt.pix;
>> >> +    struct v4l2_mbus_framefmt mf;
>> >> +    __u32 pixfmt = pix->pixelformat;
>> >> +    int ret = 0;
>> >
>> >No need to initialise ret.
>> >
>> >> +
>> >> +    xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> >> +    if (!xlate) {
>> >> +            cam_err(mcam, "camera: format: %c not found\n",
>> >> +                    pix->pixelformat);
>> >> +            return -EINVAL;
>> >
>> >You shouldn't fail .try_fmt() (unless something really bad happens).
>> >Just pick up a default supported format.
>> >
>> Do you means we just need pick up the default supported format when try_fmt()?
>
>If you don't find the requested format - yes, just pick up any format, that you can
>support.
>
OK.

>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
