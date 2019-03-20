Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18097C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D00BA206BA
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553091549;
	bh=jUkUX2MkRTmPSI/J3twy3hAFphcGa6RqhfvJk8dRIRE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=PaI5n6ZXEtp3GITNsd1KTjQ8X2TlSd1wqYk5Cn1dnhPAns/XF3iMRPtVTXeUh4I81
	 /ugwp7QtHmsqeyBfsBxj/NAGVYeFpd1pqZPHYoNTO4KuM460xY6gOHfYKyoWJESnK5
	 zn9U6FibxL30/L2Nms8P/yHOj9iGm6a02jxlPSOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfCTOTJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:19:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:39456 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbfCTOTJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wzFi9IS0O/D+QXmQSKO06hqofS9jDCRoUvuu/NHU+Ls=; b=Se/L5pIFjJxAc6uxGPM2NtDFi3
        k28xZLTIuk7Dta3SVMCPi2PUm+l2fW/kPOmcamekV57uY6VOUxAUakSCsfjFKcOKJMDHc2Vcq9sX7
        AjAuhWZV7u0zKJe21y/45Hqrh/J8fb/gQ3a2Aq1f8KEehVRF3sEyPfDHJcxN6Yd1h65FWyEi6cb61
        6nbBsCSOl5fq/j8kVDQwIyleHwGMF6RXn8DUcu4RnX/NlI8EBcjko3K+QKpSOYup+8Ck8xLlS4eGr
        Y3W2ujHEyDKg/1rQAhKtg3p26Sk4Oq5RFw3LN8Z426JhLhyFWaDqHXxw7D3kJLL0nUNTa91g3oOdJ
        WI9f+gog==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6c3V-0000tU-3I; Wed, 20 Mar 2019 14:18:57 +0000
Date:   Wed, 20 Mar 2019 11:18:51 -0300
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     robh+dt@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 5/5] media: tvp5150: add support to limit tv norms on
 connector
Message-ID: <20190320111851.1749c9ac@coco.lan>
In-Reply-To: <20190202121004.9014-6-m.felsch@pengutronix.de>
References: <20190202121004.9014-1-m.felsch@pengutronix.de>
        <20190202121004.9014-6-m.felsch@pengutronix.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sat,  2 Feb 2019 13:10:04 +0100
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> The tvp5150 accepts NTSC(M,J,4.43), PAL (B,D,G,H,I,M,N) and SECAM video
> data and is able to auto-detect the input signal. 

Hmm... I'm afraid of this change. As far as I remember, I tested some
weird format variants like V4L2_STD_PAL_60 a long time ago, but there's
no way to force video to use those. The format selection logic simply
places the device on auto-detect mode for those weirdos, and that
works fine at the devices I know.

A change like that may break things. So I would actually have a quirk
to optionally disable auto-detection on devices that this is not know
to work.

> The auto-detection
> does not work if the connector does not receive an input signal and the
> tvp5150 might not be configured correctly. This misconfiguration leads
> into wrong decoded video streams if the tvp5150 gets powered on before
> the video signal is present.
> 
> Limit the supported tv norms according to the actual selected connector
> to avoid a misconfiguration.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  drivers/media/i2c/tvp5150.c | 42 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index f3a2ad00a40d..7619793dee67 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -32,6 +32,13 @@
>  #define TVP5150_MBUS_FMT	MEDIA_BUS_FMT_UYVY8_2X8
>  #define TVP5150_FIELD		V4L2_FIELD_ALTERNATE
>  #define TVP5150_COLORSPACE	V4L2_COLORSPACE_SMPTE170M
> +#define TVP5150_STD_MASK	(V4L2_STD_NTSC     | \
> +				 V4L2_STD_NTSC_443 | \
> +				 V4L2_STD_PAL      | \
> +				 V4L2_STD_PAL_M    | \
> +				 V4L2_STD_PAL_N    | \
> +				 V4L2_STD_PAL_Nc   | \
> +				 V4L2_STD_SECAM)
>  
>  MODULE_DESCRIPTION("Texas Instruments TVP5150A/TVP5150AM1/TVP5151 video decoder driver");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> @@ -74,6 +81,7 @@ struct tvp5150 {
>  	struct media_pad pads[TVP5150_NUM_PADS];
>  	int pads_state[TVP5150_NUM_PADS];
>  	struct tvp5150_connector *connectors;
> +	struct tvp5150_connector *cur_connector;
>  	int connectors_num;
>  	bool modify_second_link;
>  #endif
> @@ -794,17 +802,27 @@ static int tvp5150_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
>  static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
>  {
>  	struct tvp5150 *decoder = to_tvp5150(sd);
> +	v4l2_std_id supported_norms =
> +		decoder->cur_connector->base.connector.analog.supported_tvnorms;
>  
>  	if (decoder->norm == std)
>  		return 0;
>  
> +	/*
> +	 * check if requested std or group of std's is/are supported by the
> +	 * connector
> +	 */
> +	if ((supported_norms & std) == 0)
> +		return -EINVAL;
> +
>  	/* Change cropping height limits */
>  	if (std & V4L2_STD_525_60)
>  		decoder->rect.height = TVP5150_V_MAX_525_60;
>  	else
>  		decoder->rect.height = TVP5150_V_MAX_OTHERS;
>  
> -	decoder->norm = std;
> +	/* set only the specific supported std in case of group of std's */
> +	decoder->norm = supported_norms & std;
>  
>  	return tvp5150_set_std(sd, std);
>  }
> @@ -1298,6 +1316,7 @@ static int tvp5150_link_setup(struct media_entity *entity,
>  	int *pad_state = &decoder->pads_state[0];
>  	int i, active_pad, ret = 0;
>  	bool is_svideo = false;
> +	bool update_cur_connector = false;
>  
>  	/*
>  	 * The tvp state is determined by the enabled sink pad link.
> @@ -1344,10 +1363,12 @@ static int tvp5150_link_setup(struct media_entity *entity,
>  				decoder->modify_second_link = false;
>  				tvp5150_s_routing(sd, TVP5150_SVIDEO,
>  						  TVP5150_NORMAL, 0);
> +				update_cur_connector = true;
>  			}
>  		} else {
>  			tvp5150_s_routing(sd, tvp5150_pad->index,
>  					  TVP5150_NORMAL, 0);
> +			update_cur_connector = true;
>  		}
>  	} else {
>  		/*
> @@ -1376,6 +1397,14 @@ static int tvp5150_link_setup(struct media_entity *entity,
>  					  active_pad, TVP5150_BLACK_SCREEN, 0);
>  		decoder->modify_second_link = false;
>  	}
> +
> +	if (update_cur_connector) {
> +		/* Update tvnorm according to connector */
> +		decoder->cur_connector =
> +			container_of(remote, struct tvp5150_connector, pad);
> +		tvp5150_s_std(sd,
> +			decoder->cur_connector->base.connector.analog.supported_tvnorms);
> +	}
>  out:
>  	return ret;
>  }
> @@ -1605,6 +1634,9 @@ static int tvp5150_registered(struct v4l2_subdev *sd)
>  			}
>  			tvp5150_selmux(sd);
>  			decoder->modify_second_link = false;
> +			decoder->cur_connector = &decoder->connectors[i];
> +			tvp5150_s_std(sd,
> +				decoder->connectors[i].base.connector.analog.supported_tvnorms);
>  		}
>  	}
>  #endif
> @@ -1925,6 +1957,14 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
>  				ret = -EINVAL;
>  				goto err;
>  			}
> +			if (!(c.connector.analog.supported_tvnorms &
> +			    TVP5150_STD_MASK)) {
> +				dev_err(dev,
> +					"Invalid tv norm(s) on connector %s.\n",
> +					c.label);
> +				ret = -EINVAL;
> +				goto err;
> +			}
>  			in++;
>  			break;
>  		case TVP5150_PAD_VID_OUT:



Thanks,
Mauro
