Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082ECC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C770620823
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfCZNyq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:54:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:49562 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZNyq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 09:54:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 06:54:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="286006541"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2019 06:54:40 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id C828A205E7; Tue, 26 Mar 2019 15:54:39 +0200 (EET)
Date:   Tue, 26 Mar 2019 15:54:39 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mickael GUENE <mickael.guene@st.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Petr Cvek <petrcvekcz@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Kao <ben.kao@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ricardo Ribalda Delgado <ricardo@ribalda.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v3 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Message-ID: <20190326135439.oju2k6idndjaulfj@paasikivi.fi.intel.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-3-git-send-email-mickael.guene@st.com>
 <20190326113308.mp5hqdw3ktbpcawu@paasikivi.fi.intel.com>
 <9c8fb935-5c67-d4aa-d0ba-2aae0edd2b55@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c8fb935-5c67-d4aa-d0ba-2aae0edd2b55@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mickael,

On Tue, Mar 26, 2019 at 12:57:03PM +0000, Mickael GUENE wrote:
...
> >> +static int mipid02_set_fmt(struct v4l2_subdev *sd,
> >> +			   struct v4l2_subdev_pad_config *cfg,
> >> +			   struct v4l2_subdev_format *format)
> >> +{
> >> +	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
> >> +	struct mipid02_dev *bridge = to_mipid02_dev(sd);
> >> +	struct i2c_client *client = bridge->i2c_client;
> >> +	struct v4l2_mbus_framefmt *fmt;
> >> +	int ret;
> >> +
> >> +	dev_dbg(&client->dev, "%s for %d", __func__, format->pad);
> >> +
> >> +	if (format->pad >= MIPID02_PAD_NB)
> >> +		return -EINVAL;
> >> +	/* second CSI-2 pad not yet supported */
> >> +	if (format->pad == 1)
> >> +		return -EINVAL;
> >> +
> >> +	mutex_lock(&bridge->lock);
> >> +
> >> +	if (bridge->streaming) {
> >> +		ret = -EBUSY;
> >> +		goto error;
> >> +	}
> >> +
> >> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> >> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> >> +	else
> >> +		fmt = &bridge->fmt;
> >> +
> >> +	*fmt = *mbus_fmt;
> > 
> > What are the limits of the hardware regarding the size of the image? Aren't
> > there any?
> > 
> There are no limits for image size.
> > The format on the sink pad needs to be propagated to the source pad as
> > well. I presume there's nothing to set on the sink pad for this device, is
> > there?
>  User only need to set format code so the driver can configure hardware.
>  In the mipid02 we have always the same format for sink and source. So I
>  only store one configuration during set_fmt when called from either pad0
> (sink) or pad2 (source). Is it the correct way to implement it ? or
> should I only accept set_fmt on pad0 ?
>  For get_fmt I return stored configuration for pad0 and pad2.

Only 76 or so characters per line, please.

For pad 0 (sink) the format must be settable freely (as you don't have any
hardware restrictions) and on the pad 2 (source) the driver converts the
format set on the pad 0 according to the hardware functionality. This is
what the link validation from the source pad onwards is based on.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
