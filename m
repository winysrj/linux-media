Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:38935 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbZCRVvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 17:51:50 -0400
Received: by qyk16 with SMTP id 16so358771qyk.33
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 14:51:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C133F6.3020202@freemail.hu>
References: <49C133F6.3020202@freemail.hu>
Date: Wed, 18 Mar 2009 17:45:09 -0400
Message-ID: <30353c3d0903181445i409604e8r33678f7ce09d0288@mail.gmail.com>
Subject: Re: [PATCH] gspca: add missing .type field check in VIDIOC_G_PARM
From: David Ellingsworth <david@identd.dyndns.org>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/3/18 Németh Márton <nm127@freemail.hu>:
> From: Márton Németh <nm127@freemail.hu>
>
> The gspca webcam driver does not check the .type field of struct v4l2_streamparm.
> This field is an input parameter for the driver according to V4L2 API specification,
> revision 0.24 [1]. Add the missing check.
>
> The missing check was recognised by v4l-test 0.10 [2] together with gspca_sunplus driver
> and with "Trust 610 LCD POWERC@M ZOOM" webcam. This patch was verified also with
> v4l-test 0.10.
>
> References:
> [1] V4L2 API specification, revision 0.24
>    http://v4l2spec.bytesex.org/spec/r11680.htm
>
> [2] v4l-test: Test environment for Video For Linux Two API
>    http://v4l-test.sourceforge.net/
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.29-rc8/drivers/media/video/gspca/gspca.c.orig     2009-03-14 12:29:38.000000000 +0100
> +++ linux-2.6.29-rc8/drivers/media/video/gspca/gspca.c  2009-03-18 16:51:03.000000000 +0100
> @@ -1320,6 +1320,9 @@ static int vidioc_g_parm(struct file *fi
>  {
>        struct gspca_dev *gspca_dev = priv;
>
> +       if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
>        memset(parm, 0, sizeof *parm);
>        parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
^^^^^^^^^^^^^^^^^^^
This line should be deleted as it's no longer needed.

>        parm->parm.capture.readbuffers = gspca_dev->nbufread;
>

Regards,

David Ellingsworth
