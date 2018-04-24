Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52735 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756662AbeDXLzi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 07:55:38 -0400
Date: Tue, 24 Apr 2018 14:55:34 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 02/12] media: ov5640: Add light frequency control
Message-ID: <20180424115534.ycu5zxkxftgfpkph@paasikivi.fi.intel.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-3-maxime.ripard@bootlin.com>
 <1757295.VWosiQ25QR@avalon>
 <20180420190410.v34fjtmcs57otbcg@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180420190410.v34fjtmcs57otbcg@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 09:04:10PM +0200, Maxime Ripard wrote:
> Hi Laurent,
> 
> On Thu, Apr 19, 2018 at 12:44:18PM +0300, Laurent Pinchart wrote:
> > On Monday, 16 April 2018 15:36:51 EEST Maxime Ripard wrote:
> > > From: Mylène Josserand <mylene.josserand@bootlin.com>
> > > 
> > > Add the light frequency control to be able to set the frequency
> > > to manual (50Hz or 60Hz) or auto.
> > > 
> > > Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >  drivers/media/i2c/ov5640.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > > 
> > > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > > index a33e45f8e2b0..28122341fc35 100644
> > > --- a/drivers/media/i2c/ov5640.c
> > > +++ b/drivers/media/i2c/ov5640.c
> > > @@ -189,6 +189,7 @@ struct ov5640_ctrls {
> > >  	};
> > >  	struct v4l2_ctrl *auto_focus;
> > >  	struct v4l2_ctrl *brightness;
> > > +	struct v4l2_ctrl *light_freq;
> > >  	struct v4l2_ctrl *saturation;
> > >  	struct v4l2_ctrl *contrast;
> > >  	struct v4l2_ctrl *hue;
> > > @@ -2163,6 +2164,21 @@ static int ov5640_set_ctrl_focus(struct ov5640_dev
> > > *sensor, int value) BIT(1), value ? BIT(1) : 0);
> > >  }
> > > 
> > > +static int ov5640_set_ctl_light_freq(struct ov5640_dev *sensor, int value)
> > 
> > To stay consistent with the other functions, I propose calling this 
> > ov5640_set_ctrl_light_freq().
> > 
> > Apart from that,
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Consider it fixed in the next iteration, thanks!
> Maxime

Applied patches 2--7 with the following diff to the first applied patch,
i.e. this one:

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index dc3950c20c62..e480e53b369b 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2178,7 +2178,7 @@ static int ov5640_set_ctrl_test_pattern(struct ov5640_dev *sensor, int value)
 			      0xa4, value ? 0xa4 : 0);
 }
 
-static int ov5640_set_ctl_light_freq(struct ov5640_dev *sensor, int value)
+static int ov5640_set_ctrl_light_freq(struct ov5640_dev *sensor, int value)
 {
 	int ret;
 
@@ -2262,7 +2262,7 @@ static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = ov5640_set_ctrl_test_pattern(sensor, ctrl->val);
 		break;
 	case V4L2_CID_POWER_LINE_FREQUENCY:
-		ret = ov5640_set_ctl_light_freq(sensor, ctrl->val);
+		ret = ov5640_set_ctrl_light_freq(sensor, ctrl->val);
 		break;
 	default:
 		ret = -EINVAL;

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
