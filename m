Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2116 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GGTLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 15:11:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] v4l2-ioctl: Don't assume file->private_data always points to a v4l2_fh
Date: Sat, 7 Jul 2012 21:11:11 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1341686781-2013-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1341686781-2013-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207072111.11951.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat July 7 2012 20:46:21 Hans de Goede wrote:
> Commit efbceecd4522a41b8442c6b4f68b4508d57d1ccf, adds a number of helper
> functions for ctrl related ioctls to v4l2-ioctl.c, these helpers assume that
> if file->private_data != NULL, it points to a v4l2_fh, which is only the case
> for drivers which actually use v4l2_fh.
> 
> This breaks for example bttv which use the "filedata" pointer for its own uses,
> and now all the ctrl ioctls try to use whatever its filedata points to as
> v4l2_fh and think it has a ctrl_handler, leading to:
> 
> [  142.499214] BUG: unable to handle kernel NULL pointer dereference at 0000000000000021
> [  142.499270] IP: [<ffffffffa01cb959>] v4l2_queryctrl+0x29/0x230 [videodev]
> [  142.514649]  [<ffffffffa01c7a77>] v4l_queryctrl+0x47/0x90 [videodev]
> [  142.517417]  [<ffffffffa01c58b1>] __video_do_ioctl+0x2c1/0x420 [videodev]
> [  142.520116]  [<ffffffffa01c7ee6>] video_usercopy+0x1a6/0x470 [videodev]
> ...
> 
> This patch adds the missing test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) tests
> to the ctrl ioctl helpers v4l2_fh paths, fixing the issues with for example
> the bttv driver.

Urgh, I didn't test with a 'old' driver. Thanks for catching this. But I would
prefer a simpler patch (although effectively the same) like this:

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 70e0efb..bbcb4f6 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1486,7 +1486,7 @@ static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_queryctrl *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	if (vfh && vfh->ctrl_handler)
 		return v4l2_queryctrl(vfh->ctrl_handler, p);
@@ -1502,7 +1502,7 @@ static int v4l_querymenu(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_querymenu *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	if (vfh && vfh->ctrl_handler)
 		return v4l2_querymenu(vfh->ctrl_handler, p);
@@ -1518,7 +1518,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_control *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
 
@@ -1551,7 +1551,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_control *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
 
@@ -1579,7 +1579,7 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_ext_controls *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
@@ -1597,7 +1597,7 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_ext_controls *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
@@ -1615,7 +1615,7 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_ext_controls *p = arg;
-	struct v4l2_fh *vfh = fh;
+	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)

Regards,

	Hans

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 70e0efb..3c498b2 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1488,7 +1488,8 @@ static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_queryctrl *p = arg;
>  	struct v4l2_fh *vfh = fh;
>  
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_queryctrl(vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_queryctrl(vfd->ctrl_handler, p);
> @@ -1504,7 +1505,8 @@ static int v4l_querymenu(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_querymenu *p = arg;
>  	struct v4l2_fh *vfh = fh;
>  
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_querymenu(vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_querymenu(vfd->ctrl_handler, p);
> @@ -1522,7 +1524,8 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_ext_controls ctrls;
>  	struct v4l2_ext_control ctrl;
>  
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_g_ctrl(vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_g_ctrl(vfd->ctrl_handler, p);
> @@ -1555,7 +1558,8 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_ext_controls ctrls;
>  	struct v4l2_ext_control ctrl;
>  
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_s_ctrl(NULL, vfd->ctrl_handler, p);
> @@ -1582,7 +1586,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_fh *vfh = fh;
>  
>  	p->error_idx = p->count;
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
> @@ -1600,7 +1605,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_fh *vfh = fh;
>  
>  	p->error_idx = p->count;
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
> @@ -1618,7 +1624,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_fh *vfh = fh;
>  
>  	p->error_idx = p->count;
> -	if (vfh && vfh->ctrl_handler)
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	                vfh && vfh->ctrl_handler)
>  		return v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
>  	if (vfd->ctrl_handler)
>  		return v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
> 
