Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6461C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 09:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C81320850
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 09:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfCUJxe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 05:53:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46439 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfCUJxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 05:53:34 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h6uO5-0003yY-Eh; Thu, 21 Mar 2019 10:53:25 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h6uO3-0003D3-Fp; Thu, 21 Mar 2019 10:53:23 +0100
Date:   Thu, 21 Mar 2019 10:53:23 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     robh+dt@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 5/5] media: tvp5150: add support to limit tv norms on
 connector
Message-ID: <20190321095323.qu5mwlzwvzxzqd2i@pengutronix.de>
References: <20190202121004.9014-1-m.felsch@pengutronix.de>
 <20190202121004.9014-6-m.felsch@pengutronix.de>
 <20190320111851.1749c9ac@coco.lan>
 <20190320163650.ua6cx3jwffm36p3m@pengutronix.de>
 <20190320142931.4a4b91fd@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320142931.4a4b91fd@coco.lan>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:34:37 up 61 days, 14:16, 53 users,  load average: 0.01, 0.08,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On 19-03-20 14:29, Mauro Carvalho Chehab wrote:
> Em Wed, 20 Mar 2019 17:36:50 +0100
> Marco Felsch <m.felsch@pengutronix.de> escreveu:
> 
> > Hi Mauro,
> > 
> > On 19-03-20 11:18, Mauro Carvalho Chehab wrote:
> > > Em Sat,  2 Feb 2019 13:10:04 +0100
> > > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> > >   
> > > > The tvp5150 accepts NTSC(M,J,4.43), PAL (B,D,G,H,I,M,N) and SECAM video
> > > > data and is able to auto-detect the input signal.   
> > > 
> > > Hmm... I'm afraid of this change. As far as I remember, I tested some
> > > weird format variants like V4L2_STD_PAL_60 a long time ago, but there's
> > > no way to force video to use those. The format selection logic simply
> > > places the device on auto-detect mode for those weirdos, and that
> > > works fine at the devices I know.  
> > 
> > Sorry I didn't get this. The format is set to autodetect during probe().
> 
> Yes, but apps will change based on G_FMT, TRY_FMT and S_FMT.
> 
> See, my main concern here is with existing tvp5150 non-platform
> drivers, as a change there would be a regression.

Of course I won't break existing stuff too :)

> > If there is no format limitation this won't be changed during
> > media.link_setup(). You're right I forgot to check if the cur_connector
> > is available during tvp5150_s_std(), in case of pdata related devices.
> 
> Yeah, that's what I'm talking about.

So are you with me with the following lines? This should avoid breaking
exisiting drivers.

 static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id supported_norms = decoder->cur_connector ?
+		decoder->cur_connector->base.connector.analog.supported_tvnorms :
+		V4L2_STD_ALL;

 ...

 }

> > In such a case we should set supported_norms to V4L2_STD_ALL as it is
> > done by v4l2_fwnode_parse_connector() if no limitations are given.
> > 
> > Btw, how does it look with the other patchset?
> 
> I asked Hans to take a look at the patch series, as he's sub-maintaining
> the v4l2 stuff.

Cheers.

> I'm intending to take
> a deeper look at patch 2/7 v4 from the past series.

That would be great. I'm looking forward for your feedback :)

Regards,
Marco

> > 
> > Regards,
> > Marco
> > 
> > > 
> > > A change like that may break things. So I would actually have a quirk
> > > to optionally disable auto-detection on devices that this is not know
> > > to work.
> > >   
> > > > The auto-detection
> > > > does not work if the connector does not receive an input signal and the
> > > > tvp5150 might not be configured correctly. This misconfiguration leads
> > > > into wrong decoded video streams if the tvp5150 gets powered on before
> > > > the video signal is present.
> > > > 
> > > > Limit the supported tv norms according to the actual selected connector
> > > > to avoid a misconfiguration.
> > > > 
> > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > ---
> > > >  drivers/media/i2c/tvp5150.c | 42 ++++++++++++++++++++++++++++++++++++-
> > > >  1 file changed, 41 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > > index f3a2ad00a40d..7619793dee67 100644
> > > > --- a/drivers/media/i2c/tvp5150.c
> > > > +++ b/drivers/media/i2c/tvp5150.c
> > > > @@ -32,6 +32,13 @@
> > > >  #define TVP5150_MBUS_FMT	MEDIA_BUS_FMT_UYVY8_2X8
> > > >  #define TVP5150_FIELD		V4L2_FIELD_ALTERNATE
> > > >  #define TVP5150_COLORSPACE	V4L2_COLORSPACE_SMPTE170M
> > > > +#define TVP5150_STD_MASK	(V4L2_STD_NTSC     | \
> > > > +				 V4L2_STD_NTSC_443 | \
> > > > +				 V4L2_STD_PAL      | \
> > > > +				 V4L2_STD_PAL_M    | \
> > > > +				 V4L2_STD_PAL_N    | \
> > > > +				 V4L2_STD_PAL_Nc   | \
> > > > +				 V4L2_STD_SECAM)
> > > >  
> > > >  MODULE_DESCRIPTION("Texas Instruments TVP5150A/TVP5150AM1/TVP5151 video decoder driver");
> > > >  MODULE_AUTHOR("Mauro Carvalho Chehab");
> > > > @@ -74,6 +81,7 @@ struct tvp5150 {
> > > >  	struct media_pad pads[TVP5150_NUM_PADS];
> > > >  	int pads_state[TVP5150_NUM_PADS];
> > > >  	struct tvp5150_connector *connectors;
> > > > +	struct tvp5150_connector *cur_connector;
> > > >  	int connectors_num;
> > > >  	bool modify_second_link;
> > > >  #endif
> > > > @@ -794,17 +802,27 @@ static int tvp5150_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
> > > >  static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> > > >  {
> > > >  	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > +	v4l2_std_id supported_norms =
> > > > +		decoder->cur_connector->base.connector.analog.supported_tvnorms;
> > > >  
> > > >  	if (decoder->norm == std)
> > > >  		return 0;
> > > >  
> > > > +	/*
> > > > +	 * check if requested std or group of std's is/are supported by the
> > > > +	 * connector
> > > > +	 */
> > > > +	if ((supported_norms & std) == 0)
> > > > +		return -EINVAL;
> > > > +
> > > >  	/* Change cropping height limits */
> > > >  	if (std & V4L2_STD_525_60)
> > > >  		decoder->rect.height = TVP5150_V_MAX_525_60;
> > > >  	else
> > > >  		decoder->rect.height = TVP5150_V_MAX_OTHERS;
> > > >  
> > > > -	decoder->norm = std;
> > > > +	/* set only the specific supported std in case of group of std's */
> > > > +	decoder->norm = supported_norms & std;
> > > >  
> > > >  	return tvp5150_set_std(sd, std);
> > > >  }
> > > > @@ -1298,6 +1316,7 @@ static int tvp5150_link_setup(struct media_entity *entity,
> > > >  	int *pad_state = &decoder->pads_state[0];
> > > >  	int i, active_pad, ret = 0;
> > > >  	bool is_svideo = false;
> > > > +	bool update_cur_connector = false;
> > > >  
> > > >  	/*
> > > >  	 * The tvp state is determined by the enabled sink pad link.
> > > > @@ -1344,10 +1363,12 @@ static int tvp5150_link_setup(struct media_entity *entity,
> > > >  				decoder->modify_second_link = false;
> > > >  				tvp5150_s_routing(sd, TVP5150_SVIDEO,
> > > >  						  TVP5150_NORMAL, 0);
> > > > +				update_cur_connector = true;
> > > >  			}
> > > >  		} else {
> > > >  			tvp5150_s_routing(sd, tvp5150_pad->index,
> > > >  					  TVP5150_NORMAL, 0);
> > > > +			update_cur_connector = true;
> > > >  		}
> > > >  	} else {
> > > >  		/*
> > > > @@ -1376,6 +1397,14 @@ static int tvp5150_link_setup(struct media_entity *entity,
> > > >  					  active_pad, TVP5150_BLACK_SCREEN, 0);
> > > >  		decoder->modify_second_link = false;
> > > >  	}
> > > > +
> > > > +	if (update_cur_connector) {
> > > > +		/* Update tvnorm according to connector */
> > > > +		decoder->cur_connector =
> > > > +			container_of(remote, struct tvp5150_connector, pad);
> > > > +		tvp5150_s_std(sd,
> > > > +			decoder->cur_connector->base.connector.analog.supported_tvnorms);
> > > > +	}
> > > >  out:
> > > >  	return ret;
> > > >  }
> > > > @@ -1605,6 +1634,9 @@ static int tvp5150_registered(struct v4l2_subdev *sd)
> > > >  			}
> > > >  			tvp5150_selmux(sd);
> > > >  			decoder->modify_second_link = false;
> > > > +			decoder->cur_connector = &decoder->connectors[i];
> > > > +			tvp5150_s_std(sd,
> > > > +				decoder->connectors[i].base.connector.analog.supported_tvnorms);
> > > >  		}
> > > >  	}
> > > >  #endif
> > > > @@ -1925,6 +1957,14 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
> > > >  				ret = -EINVAL;
> > > >  				goto err;
> > > >  			}
> > > > +			if (!(c.connector.analog.supported_tvnorms &
> > > > +			    TVP5150_STD_MASK)) {
> > > > +				dev_err(dev,
> > > > +					"Invalid tv norm(s) on connector %s.\n",
> > > > +					c.label);
> > > > +				ret = -EINVAL;
> > > > +				goto err;
> > > > +			}
> > > >  			in++;
> > > >  			break;
> > > >  		case TVP5150_PAD_VID_OUT:  
> > > 
> > > 
> > > 
> > > Thanks,
> > > Mauro
> > >   
> > 
> 
> 
> 
> Thanks,
> Mauro
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
