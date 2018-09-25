Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:14770 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeIZEEY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 00:04:24 -0400
Date: Wed, 26 Sep 2018 00:54:43 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Chen, Ping-chung" <ping-chung.chen@intel.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "sylwester.nawrocki@gmail.com" <sylwester.nawrocki@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180925215442.dugem7hcywaopl6s@kekkonen.localdomain>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
 <20180920205658.xv57qcmya7xubgyf@valkosipuli.retiisi.org.uk>
 <1961986.b6erRuqaPp@avalon>
 <CAPybu_2pCy4EJnih+1pmr43gdh5J0BS_Z0Owb5qpJVkYcDHtyQ@mail.gmail.com>
 <5E40A82D0551C84FA2888225EDABBE093FACCF63@PGSMSX105.gar.corp.intel.com>
 <20180925092527.4apdggynxleigvbv@paasikivi.fi.intel.com>
 <5E40A82D0551C84FA2888225EDABBE093FACD5E5@PGSMSX105.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E40A82D0551C84FA2888225EDABBE093FACD5E5@PGSMSX105.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ping-chung,

On Tue, Sep 25, 2018 at 10:17:48AM +0000, Chen, Ping-chung wrote:
...
> > > > Controls that have a documented unit use that unit --- as long as 
> > > > that's the unit used by the hardware. If it's not, it tends to be 
> > > > that another unit is used but the user space has currently no way 
> > > > of knowing this. And the digital gain control is no exception to this.
> > > >
> > > > So if we want to improve the user space's ability to be informed 
> > > > how the control values reflect to device configuration, we do need 
> > > > to provide more information to the user space. One way to do that 
> > > > would be through VIDIOC_QUERY_EXT_CTRL. The IOCTL struct has 
> > > > plenty of reserved fields --- just for purposes such as this one.
> > >
> > > I don't think we can come up with a good way to expose arbitrary 
> > > mathematical formulas through an ioctl. In my opinion the question 
> > > is how far we want to go, how precise we need to be.
> > >
> > > > > Any opinions or better ideas?
> > 
> > >My 0.02 DKK.  On a similar situation, where userspace was running a close loop calibration:
> > 
> > >We have implemented two extra control: eposure_next exposure_pre that tell us which one is the next value. Perhaps we could embebed such functionality in QUERY_EXT_CTRL.
> > 
> > >Cheers
> > 
> > How about creating an additional control to handle the case of 
> > V4L2_CID_GAIN in the imx208 driver? HAL can set AG and DG separately 
> > for the general sensor usage by V4L2_CID_ANALOGUE_GAIN and 
> > V4L2_CID_DIGITAL_GAIN but call V4L2_CID_GAIN for the condition of 
> > setting total_gain=AGxDG.
> 
> >How do you update the two other controls if the user updates the V4L2_CID_GAIN control?
> 
> In imx208 driver:
> 
> Add two pointers *digital_gain and *analog_gain of v4l2_ctrl in the global structure imx208.
> static int imx208_init_controls(struct imx208 *imx208) {
> Imx208->digital_gain = v4l2_ctrl_new_std(..., V4L2_CID_DIGITAL_GAIN, ...);
> Imx208->analog_gain = v4l2_ctrl_new_std(...,V4L2_CID_ANALOGUE_GAIN, ...);
> 
> static int imx208_set_ctrl(struct v4l2_ctrl *ctrl)
> {
> ...
> 	case V4L2_CID_ANALOGUE_GAIN:
> 		ret = imx208_write_reg(imx208, IMX208_REG_ANALOG_GAIN, 2, ctrl->val);
> 		break;
> 	case V4L2_CID_DIGITAL_GAIN:
> 		ret = imx208_update_digital_gain(imx208, 2, ctrl->val);
> 		break;
> 	case V4L2_CID_ GAIN:
> 		ret = imx208_update_gain(imx208, 2, ctrl->val);  // total gain
> 		break;
> }
> 
> Then the implementation of imx208_update_gain():
> static int imx208_update_gain(struct imx208 *imx208, u32 len, u32 val)
> {
> 	digital_gain = (val - 1) / ag_max;
> 	digital_gain = map_to_real_DG(digital_gain);  		// map to 1x, 2x, 4x, 8x, 16x
> 	digital_gain_code = digital_gain << 8			//  DGx256 for DG_code
> 	ret = imx208_update_digital_gain(imx208, 2, digital_gain_code); 
> 	imx208->digital_gain->val = digital_gain_code;
> 	analog_gain = val/digital_gain;
> 	analog_gain_code = SMIA_AG_to_Code(analog_gain);  // AG = 256/(256-ag_code)
> 	ret = imx208_write_reg(imx208, IMX208_REG_ANALOG_GAIN, 2, analog_gain_code);
> 	imx208->digital_gain->val = analog_gain_code;

How about putting this piece of code to the user space instead?

Some work would be needed to generalise it in order for it to work on other
sensors that do need digital gain applied, too --- assuming it'd be
combined with the TRY_EXT_CTRLS rounding flags.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
