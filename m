Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1418 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbeIYPjS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 11:39:18 -0400
Date: Tue, 25 Sep 2018 12:27:58 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Bing Bu Cao <bingbu.cao@linux.intel.com>
Cc: bingbu.cao@intel.com, linux-media@vger.kernel.org,
        tfiga@google.com, rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com
Subject: Re: [PATCH v6] media: add imx319 camera sensor driver
Message-ID: <20180925092758.u7hznrjnhtggclql@paasikivi.fi.intel.com>
References: <1537522915-3499-1-git-send-email-bingbu.cao@intel.com>
 <20180921120647.slvwe3jljupruo2z@kekkonen.localdomain>
 <93059dcc-6091-02a0-2f4e-3b4cf182aa56@linux.intel.com>
 <7680da82-8520-94b9-fab1-358bea077328@linux.intel.com>
 <20180925073300.4bcfgzcejrfes5ud@paasikivi.fi.intel.com>
 <cf5bc142-cd60-1672-2539-7cf903a41acc@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf5bc142-cd60-1672-2539-7cf903a41acc@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

On Tue, Sep 25, 2018 at 05:10:59PM +0800, Bing Bu Cao wrote:
...
> >>>>> +/* Initialize control handlers */
> >>>>> +static int imx319_init_controls(struct imx319 *imx319)
> >>>>> +{
> >>>>> +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> >>>>> +	struct v4l2_ctrl_handler *ctrl_hdlr;
> >>>>> +	s64 exposure_max;
> >>>>> +	s64 vblank_def;
> >>>>> +	s64 vblank_min;
> >>>>> +	s64 hblank;
> >>>>> +	s64 pixel_rate;
> >>>>> +	const struct imx319_mode *mode;
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	ctrl_hdlr = &imx319->ctrl_handler;
> >>>>> +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 10);
> >>>>> +	if (ret)
> >>>>> +		return ret;
> >>>>> +
> >>>>> +	ctrl_hdlr->lock = &imx319->mutex;
> >>>>> +	imx319->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr, &imx319_ctrl_ops,
> >>>>> +						   V4L2_CID_LINK_FREQ, 0, 0,
> >>>>> +						   imx319->hwcfg->link_freqs);
> >>>> Could you check that the link frequency matches with what the register
> >>>> lists assume?
> >>> Sakari, do you mean associate link frequency index with register list?
> > The driver should only allow using link frequencies that are explicitly
> > allowed for the system.
> Sakari, as current driver only support one link frequency, so I think once getting the link frequencies from firmware,
> driver can simply check and match the values with link_freq_menu_items[0] and only keep 1 item in the menu:

Please wrap the lines at around 76 characters, please.

> 
> max = ARRAY_SIZE(link_freq_menu_items) - 1;
> imx319->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr, &imx319_ctrl_ops,
> 					   V4L2_CID_LINK_FREQ, max, 0,
> 					   link_freq_menu_items);
> Is it OK?

"max" would be 0 in this case, I presume. Seems fine to me.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
