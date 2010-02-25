Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1122 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab0BYUef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 15:34:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for February 22 (media/video/tvp7002)
Date: Thu, 25 Feb 2010 21:34:09 +0100
Cc: linux-next@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Santiago Nunez-Corrales" <santiago.nunez@ridgerun.com>
References: <20100222172218.4fd82a45.sfr@canb.auug.org.au> <4B82AF18.3030107@oracle.com> <20100225085205.9cf68ce9.randy.dunlap@oracle.com>
In-Reply-To: <20100225085205.9cf68ce9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002252134.10071.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 25 February 2010 17:52:05 Randy Dunlap wrote:
> On Mon, 22 Feb 2010 08:21:44 -0800 Randy Dunlap wrote:
> 
> > On 02/21/10 22:22, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20100219:
> > 
> > 
> > drivers/media/video/tvp7002.c:896: error: 'struct tvp7002' has no member named 'registers'
> 
> same problem in linux-next-20100225.
> 
> so where are these registers??

Hmm, that code is a remnant from older revisions of this driver. Unfortunately,
when I compiled this driver before creating my pull request I forgot to turn on
the CONFIG_VIDEO_ADV_DEBUG option and so I never saw it.

Anyway, below is a patch that fixes this. Please apply.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Santiago, I've also fixed the g_register function: it never returned a register
value in the original code.

Regards,

	Hans

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index 0f0270b..5a878bc 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -859,13 +859,17 @@ static int tvp7002_g_register(struct v4l2_subdev *sd,
 						struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u8 val;
+	int ret;
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	return reg->val < 0 ? -EINVAL : 0;
+	ret = tvp7002_read(sd, reg->reg & 0xff, &val);
+	reg->val = val;
+	return ret;
 }
 
 /*
@@ -881,21 +885,13 @@ static int tvp7002_s_register(struct v4l2_subdev *sd,
 						struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct tvp7002 *device = to_tvp7002(sd);
-	int wres;
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	wres = tvp7002_write(sd, reg->reg & 0xff, reg->val & 0xff);
-
-	/* Update the register value in device's table */
-	if (!wres)
-		device->registers[reg->reg].value = reg->val;
-
-	return wres < 0 ? -EINVAL : 0;
+	return tvp7002_write(sd, reg->reg & 0xff, reg->val & 0xff);
 }
 #endif
 


> 
> thanks,
> ---
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
