Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22424 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbcBCExU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2016 23:53:20 -0500
Date: Wed, 3 Feb 2016 07:53:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bparrot@ti.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] media: ti-vpe: Add CAL v4l2 camera capture driver
Message-ID: <20160203045306.GA20472@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Benoit Parrot,

The patch 343e89a792a5: "[media] media: ti-vpe: Add CAL v4l2 camera
capture driver" from Jan 6, 2016, leads to the following static
checker warning:

	drivers/media/platform/ti-vpe/cal.c:1218 cal_enum_frameintervals()
	info: ignoring unreachable code.

drivers/media/platform/ti-vpe/cal.c
  1197  /* timeperframe is arbitrary and continuous */
  1198  static int cal_enum_frameintervals(struct file *file, void *priv,
  1199                                     struct v4l2_frmivalenum *fival)
  1200  {
  1201          struct cal_ctx *ctx = video_drvdata(file);
  1202          const struct cal_fmt *fmt;
  1203          struct v4l2_subdev_frame_size_enum fse;
  1204          int ret;
  1205  
  1206          if (fival->index)
  1207                  return -EINVAL;
  1208  
  1209          fmt = find_format_by_pix(ctx, fival->pixel_format);
  1210          if (!fmt)
  1211                  return -EINVAL;
  1212  
  1213          /* check for valid width/height */
  1214          ret = 0;
  1215          fse.pad = 0;
  1216          fse.code = fmt->code;
  1217          fse.which = V4L2_SUBDEV_FORMAT_ACTIVE;
  1218          for (fse.index = 0; ; fse.index++) {
                                      ^^^^^^^^^^^
We never do this increment.  Is this stub code that was accidentally
committed or how is this loop supposed to work?

  1219                  ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_size,
  1220                                         NULL, &fse);
  1221                  if (ret)
  1222                          return -EINVAL;
  1223  
  1224                  if ((fival->width == fse.max_width) &&
  1225                      (fival->height == fse.max_height))
  1226                          break;
  1227                  else if ((fival->width >= fse.min_width) &&
  1228                           (fival->width <= fse.max_width) &&
  1229                           (fival->height >= fse.min_height) &&
  1230                           (fival->height <= fse.max_height))
  1231                          break;
  1232  
  1233                  return -EINVAL;
  1234          }
  1235  
  1236          fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
  1237          fival->discrete.numerator = 1;
  1238          fival->discrete.denominator = 30;
  1239  
  1240          return 0;

regards,
dan carpenter
