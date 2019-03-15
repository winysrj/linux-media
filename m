Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ACBC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 19:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEDD218D0
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 19:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfCOTcd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 15:32:33 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49672 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfCOTcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 15:32:31 -0400
Received: from [IPv6:2804:431:9718:4c54:5b9b:61a:a071:48bc] (unknown [IPv6:2804:431:9718:4c54:5b9b:61a:a071:48bc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 9BF3628143A;
        Fri, 15 Mar 2019 19:32:25 +0000 (GMT)
Subject: Re: [PATCH 14/16] media: vimc: sca: Add support for multiplanar
 formats
To:     =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, lucmaga@gmail.com,
        linux-kernel@vger.kernel.org, kernel@collabora.com
References: <20190315164359.626-1-andrealmeid@collabora.com>
 <20190315164359.626-15-andrealmeid@collabora.com>
From:   Helen Koike <helen.koike@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 mQINBFmOMD4BEADb2nC8Oeyvklh+ataw2u/3mrl+hIHL4WSWtii4VxCapl9+zILuxFDrxw1p
 XgF3cfx7g9taWBrmLE9VEPwJA6MxaVnQuDL3GXxTxO/gqnOFgT3jT+skAt6qMvoWnhgurMGH
 wRaA3dO4cFrDlLsZIdDywTYcy7V2bou81ItR5Ed6c5UVX7uTTzeiD/tUi8oIf0XN4takyFuV
 Rf09nOhi24bn9fFN5xWHJooFaFf/k2Y+5UTkofANUp8nn4jhBUrIr6glOtmE0VT4pZMMLT63
 hyRB+/s7b1zkOofUGW5LxUg+wqJXZcOAvjocqSq3VVHcgyxdm+Nv0g9Hdqo8bQHC2KBK86VK
 vB+R7tfv7NxVhG1sTW3CQ4gZb0ZugIWS32Mnr+V+0pxci7QpV3jrtVp5W2GA5HlXkOyC6C7H
 Ao7YhogtvFehnlUdG8NrkC3HhCTF8+nb08yGMVI4mMZ9v/KoIXKC6vT0Ykz434ed9Oc9pDow
 VUqaKi3ey96QczfE4NI029bmtCY4b5fucaB/aVqWYRH98Jh8oIQVwbt+pY7cL5PxS7dQ/Zuz
 6yheqDsUGLev1O3E4R8RZ8jPcfCermL0txvoXXIA56t4ZjuHVcWEe2ERhLHFGq5Zw7KC6u12
 kJoiZ6WDBYo4Dp+Gd7a81/WsA33Po0j3tk/8BWoiJCrjXzhtRwARAQABtCdIZWxlbiBLb2lr
 ZSA8aGVsZW4ua29pa2VAY29sbGFib3JhLmNvbT6JAlQEEwEKAD4CGwEFCwkIBwMFFQoJCAsF
 FgIDAQACHgECF4AWIQSofQA6zrItXEgHWTzAfqwo9yFiXQUCXEz3bwUJBKaPRQAKCRDAfqwo
 9yFiXdUCD/4+WZr503hQ13KB4DijOW76ju8JDPp4p++qoPxtoAsld3yROoTI+VPWmt7ojHrr
 TZc7sTLxOFzaUC8HjGTb3r9ilIhIKf/M9KRLkpIJ+iLA+VoUbcSOMYWoVNfgLmbnqoezjPcy
 OHJwVw9dzEeYpvG6nkY6E4UktANySp27AniSXNuHOvYsOsXmUOqU1ScdsrQ9s732p/OGdTyw
 1yd3gUMLZvCKFOBVHILH59HCRJgpwUPiws8G4dGMs4GTRvHT2s2mDQdQ0HEvcM9rvCRVixuC
 5ZeOymZNi6lDIUIysgiZ+yzk6i5l/Ni6r7v20N3JppZvhPK6LqtaYceyAGyc3jjnOqoHT/qR
 kPjCwzmKiPtXjLw6HbRXtGgGtP5m3y8v6bfHH+66zd2vGCY0Z9EsqcnK4DCqRkLncFLPM2gn
 9cZcCmO4ZqXUhTyn1nHM494kd5NX1Op4HO+t9ErnpufkVjoMUeBwESdQwwwHT3rjUueGmCrn
 VJK69/qhA4La72VTxHutl+3Z0Xy20HWsZS8Gsam39f95/LtPLzbBwnOOi5ZoXnm97tF8HrAZ
 2h+kcRLMWw3BXy5q4gic+oFZMZP9oq1G9XTFld4FGgJ9ys8aGmhLM+uB1pFxb3XFtWQ2z4AJ
 iEp2VLl34quwfD6Gg4csiZe2KzvQHUe0w8SJ9LplrHPPprkCDQRZjjChARAAzISLQaHzaDOv
 ZxcoCNBk/hUGo2/gsmBW4KSj73pkStZ+pm3Yv2CRtOD4jBlycXjzhwBV7/70ZMH70/Y25dJa
 CnJKl/Y76dPPn2LDWrG/4EkqUzoJkhRIYFUTpkPdaVYznqLgsho19j7HpEbAum8r3jemYBE1
 AIuVGg4bqY3UkvuHWLVRMuaHZNy55aYwnUvd46E64JH7O990mr6t/nu2a1aJ0BDdi8HZ0RMo
 Eg76Avah+YR9fZrhDFmBQSL+mcCVWEbdiOzHmGYFoToqzM52wsNEpo2aStH9KLk8zrCXGx68
 ohJyQoALX4sS03RIWh1jFjnlw2FCbEdj/HDX0+U0i9COtanm54arYXiBTnAnx0F7LW7pv7sb
 6tKMxsMLmprP/nWyV5AfFRi3jxs5tdwtDDk/ny8WH6KWeLR/zWDwpYgnXLBCdg8l97xUoPQO
 0VkKSa4JEXUZWZx9q6kICzFGsuqApqf9gIFJZwUmirsxH80Fe04Tv+IqIAW7/djYpOqGjSyk
 oaEVNacwLLgZr+/j69/1ZwlbS8K+ChCtyBV4kEPzltSRZ4eU19v6sDND1JSTK9KSDtCcCcAt
 VGFlr4aE00AD/aOkHSylc93nPinBFO4AGhcs4WypZ3GGV6vGWCpJy9svfWsUDhSwI7GS/i/v
 UQ1+bswyYEY1Q3DjJqT7fXcAEQEAAYkEcgQYAQoAJgIbAhYhBKh9ADrOsi1cSAdZPMB+rCj3
 IWJdBQJcTPfVBQkEpo7hAkDBdCAEGQEKAB0WIQSomGMEg78Cd/pMshveCRfNeJ05lgUCWY4w
 oQAKCRDeCRfNeJ05lp0gD/49i95kPKjpgjUbYeidjaWuINXMCA171KyaBAp+Jp2Qrun4sIJB
 Z6srMj6O/gC34AhZln2sXeQdxe88sNbg6HjlN+4AkhTd6DttjOfUwnamLDA7uw+YIapGgsgN
 lznjLnqOaQ9mtEwRbZMUOdyRf9osSuL14vHl4ia3bYNJ52WYre6gLMu4K+Ghd02og+ILgIio
 Q827h0spqIJYHrR3Ynnhxdlv5GPCobh+AKsQMdTIuCzR6JSCBk6GHkg33SiWScKMUzT8B/cn
 ypLfGnfV/LDZ9wS2TMzIlK/uv0Vd4C0OGDd/GCi5Gwu/Ot0aY7fzZo2CiRV+/nJBWPRRBTji
 bE4FG2rt7WSRLO/QmH2meIW4f0USDiHeNwznHkPei59vRdlMyQdsxrmgSRDuX9Y3UkERxbgd
 uscqC8Cpcy5kpF11EW91J8aGpcxASc+5Pa66/+7CrpBC2DnfcfACdMAje7yeMn9XlHrqXNlQ
 GaglEcnGN2qVqRcKgcjJX+ur8l56BVpBPFYQYkYkIdQAuhlPylxOvsMcqI6VoEWNt0iFF3dA
 //0MNb8fEqw5TlxDPOt6BDhDKowkxOGIA9LOcF4PkaR9Qkvwo2P4vA/8fhCnMqlSPom4xYdk
 Ev8P554zDoL/XMHl+s7A0MjIJzT253ejZKlWeO68pAbNy/z7QRn2lFDnjwkQwH6sKPchYl2f
 0g//Yu3vDkqk8+mi2letP3XBl2hjv2eCZjTh34VvtgY5oeL2ROSJWNd18+7O6q3hECZ727EW
 gIb3LK9g4mKF6+Rch6Gwz1Y4fmC5554fd2Y2XbVzzz6AGUC6Y+ohNg7lTAVO4wu43+IyTB8u
 ip5rX/JDGFv7Y1sl6tQJKAVIKAJE+Z3Ncqh3doQr9wWHl0UiQYKbSR9HpH1lmC1C3EEbTpwK
 fUIpZd1eQNyNJl1jHsZZIBYFsAfVNH/u6lB1TU+9bSOsV5SepdIb88d0fm3oZ4KzjhRHLFQF
 RwNUNn3ha6x4fbxYcwbvu5ZCiiX6yRTPoage/LUNkgQNX2PtPcur6CdxK6Pqm8EAI7PmYLfN
 NY3y01XhKNRvaVZoH2FugfUkhsBITglTIpI+n6YU06nDAcbeINFo67TSE0iL6Pek5a6gUQQC
 6w+hJCaMr8KYud0q3ccHyU3TlAPDe10En3GsVz7Y5Sa3ODGdbmkfjK8Af3ogGNBVmpV16Xl8
 4rETFv7POSUB2eMtbpmBopd+wKqHCwUEy3fx1zDbM9mp+pcDoL73rRZmlgmNfW/4o4qBzxRf
 FYTQLE69wAFU2IFce9PjtUAlBdC+6r3X24h3uD+EC37s/vWhxuKj2glaU9ONrVJ/SPvlqXOO
 WR1Zqw57vHMKimLdG3c24l8PkSw1usudgAA5OyO5Ag0EWY4wyQEQAMVp0U38Le7d80Mu6AT+
 1dMes87iKn30TdMuLvSg2uYqJ1T2riRBF7zU6u74HF6zps0rPQviBXOgoSuKa1hnS6OwFb9x
 yQPlk76LY96SUB5jPWJ3fO78ZGSwkVbJFuG9gpD/41n8Unn1hXgDb2gUaxD0oXv/723EmTYC
 vSo3z6Y8A2aBQNr+PyhQAPDazvVQ+P7vnZYq1oK0w+D7aIix/Bp4mo4VbgAeAeMxXWSZs8N5
 NQtXeTBgB7DqrfJP5wWwgCsROfeds6EoddcYgqhG0zVU9E54C8JcPOA0wKVs+9+gt2eyRNtx
 0UhFbah7qXuJGhWy/0CLXvVoCoS+7qpWz070TBAlPZrg9D0o2gOw01trQgoKAYBKKgJhxaX/
 4gzi+5Ccm33LYH9lAVTdzdorejuV1xWdsnNyc8OAPeoXBf9RIIWfQVmbhVXBp2DAPjV6/kIJ
 Eml7MNJfEvqjV9zKsWF9AFlsqDWZDCyUdqR96ahTSD34pRwb6a9H99/GrjeowKaaL95DIVZT
 C6STvDNL6kpys4sOe2AMmQGv2MMcJB3aYLzH8f1sEQ9S0UMX7/6CifEG6JodG6Y/W/lLo1Vv
 DxeDA+u4Lgq6qxlksp8M78FjcmxFVlf4cpCi2ucbZxurhlBkjtZZ8MVAEde3hlqjcBl2Ah6Q
 D826FTxscOGlHEfNABEBAAGJAjwEGAEKACYCGwwWIQSofQA6zrItXEgHWTzAfqwo9yFiXQUC
 XEz31QUJBKaOuQAKCRDAfqwo9yFiXUvnEACBWe8wSnIvSX+9k4LxuLq6GQTOt+RNfliZQkCW
 5lT3KL1IJyzzOm4x+/slHRBl8bF7KEZyOPinXQXyJ/vgIdgSYxDqoZ7YZn3SvuNe4aT6kGwL
 EYYEV8Ecj4ets15FR2jSUNnVv5YHWtZ7bP/oUzr2LT54fjRcstYxgwzoj8AREtHQ4EJWAWCO
 ZuEHTSm5clMFoi41CmG4DlJbzbo4YfilKYm69vwh50Y8WebcRN31jh0g8ufjOJnBldYYBLwN
 Obymhlfy/HKBDIbyCGBuwYoAkoJ6LR/cqzl/FuhwhuDocCGlXyYaJOwXgHaCvVXI3PLQPxWZ
 +vPsD+TSVHc9m/YWrOiYDnZn6aO0Uk1Zv/m9+BBkWAwsreLJ/evn3SsJV1omNBTITG+uxXcf
 JkgmmesIAw8mpI6EeLmReUJLasz8QkzhZIC7t5rGlQI94GQG3Jg2dC+kpaGWOaT5G4FVMcBj
 iR1nXfMxENVYnM5ag7mBZyD/kru5W1Uj34L6AFaDMXFPwedSCpzzqUiHb0f+nYkfOodf5xy0
 46+3THy/NUS/ZZp/rI4F7Y77+MQPVg7vARfHHX1AxYUKfRVW5j88QUB70txn8Vgi1tDrOr4J
 eD+xr0CvIGa5lKqgQacQtGkpOpJ8zY4ObSvpNubey/qYUE3DCXD0n2Xxk4muTvqlkFpOYA==
Message-ID: <f84caa28-347d-57e0-839b-3dc64c6dfbeb@collabora.com>
Date:   Fri, 15 Mar 2019 16:32:21 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190315164359.626-15-andrealmeid@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 3/15/19 1:43 PM, André Almeida wrote:
> Change the scaling functions in order to scale planes. This change makes
> easier to support multiplanar pixel formats.
> 
> Signed-off-by: André Almeida <andrealmeid@collabora.com>
> ---
>  drivers/media/platform/vimc/vimc-scaler.c | 110 ++++++++++++++--------
>  1 file changed, 69 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> index 65519495ecca..15fbb0914056 100644
> --- a/drivers/media/platform/vimc/vimc-scaler.c
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -35,10 +35,14 @@ MODULE_PARM_DESC(sca_mult, " the image size multiplier");
>  #define IS_SRC(pad)	(pad)
>  #define MAX_ZOOM	8
>  
> +/* TODO: enum only scalable formats */

why is this a TODO? Isn't what it is doing already?

>  static const u32 vimc_sca_supported_pixfmt[] = {
>  	V4L2_PIX_FMT_BGR24,
>  	V4L2_PIX_FMT_RGB24,
>  	V4L2_PIX_FMT_ARGB32,
> +	V4L2_PIX_FMT_YUV420,
> +	V4L2_PIX_FMT_YUV420M,
> +	V4L2_PIX_FMT_NV12M,
>  };
>  
>  struct vimc_sca_device {
> @@ -51,8 +55,8 @@ struct vimc_sca_device {
>  	struct v4l2_mbus_framefmt sink_fmt;
>  	/* Values calculated when the stream starts */
>  	struct vimc_frame src_frame;
> -	unsigned int src_line_size;
> -	unsigned int bpp;
> +	unsigned int src_line_size[TPG_MAX_PLANES];
> +	unsigned int bpp[TPG_MAX_PLANES];
>  };
>  
>  static const struct v4l2_mbus_framefmt sink_fmt_default = {
> @@ -207,10 +211,10 @@ static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
>  static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
> +	unsigned int i;
>  
>  	if (enable) {
>  		u32 pixelformat = vsca->ved.stream->producer_pixfmt;
> -		const struct v4l2_format_info *pix_info;
>  		unsigned int frame_size;
>  
>  		if (!vimc_sca_is_pixfmt_supported(pixelformat)) {
> @@ -219,32 +223,41 @@ static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
>  			return -EINVAL;
>  		}
>  
> -		/* Save the bytes per pixel of the sink */
> -		pix_info = v4l2_format_info(pixelformat);
> -		vsca->bpp = pix_info->bpp[0];
> -
> -		/* Calculate the width in bytes of the src frame */
> -		vsca->src_line_size = vsca->sink_fmt.width *
> -				      sca_mult * vsca->bpp;
> -
> -		/* Calculate the frame size of the source pad */
> -		frame_size = vsca->src_line_size * vsca->sink_fmt.height *
> -			     sca_mult;
> -
> -		/* Allocate the frame buffer. Use vmalloc to be able to
> -		 * allocate a large amount of memory
> -		 */
> -		vsca->src_frame.plane_addr[0] = vmalloc(frame_size);
> -		vsca->src_frame.sizeimage[0] = frame_size;
> -		if (!vsca->src_frame.plane_addr[0])
> -			return -ENOMEM;
> +		vimc_fill_frame(&vsca->src_frame, pixelformat,
> +				vsca->sink_fmt.width, vsca->sink_fmt.height);
> +
> +		for (i = 0; i < vsca->src_frame.num_planes; i++) {
> +			/* Save the bytes per pixel of the sink */
> +			vsca->bpp[i] = vsca->src_frame.bpp[i];
> +
> +			/* Calculate the width in bytes of the src frame */
> +			vsca->src_line_size[i] =
> +				vsca->src_frame.bytesperline[i] * sca_mult;
> +
> +			/* Calculate the frame size of the source pad */
> +			frame_size = vsca->src_frame.sizeimage[i] *
> +			     sca_mult * sca_mult;
> +
> +			/* Allocate the frame buffer. Use vmalloc to be able to
> +			 * allocate a large amount of memory
> +			 */

I know this comment was already like this, but could you please also
correct the style of this comment? It should start with
/*
 * Allocate ...

Regards,
Helen

> +			vsca->src_frame.plane_addr[i] = vmalloc(frame_size);
> +			if (!vsca->src_frame.plane_addr[i]) {
> +				for (i -= 1; i >= 0; i--)
> +					vfree(vsca->src_frame.plane_addr[i]);
> +				return -ENOMEM;
> +			}
> +			vsca->src_frame.sizeimage[i] = frame_size;
> +		}
>  
>  	} else {
>  		if (!vsca->src_frame.plane_addr[0])
>  			return 0;
>  
> -		vfree(vsca->src_frame.plane_addr[0]);
> -		vsca->src_frame.plane_addr[0] = NULL;
> +		for (i = 0; i < vsca->src_frame.num_planes; i++) {
> +			vfree(vsca->src_frame.plane_addr[i]);
> +			vsca->src_frame.plane_addr[i] = NULL;
> +		}
>  	}
>  
>  	return 0;
> @@ -270,18 +283,19 @@ static void vimc_sca_fill_pix(u8 *const ptr,
>  		ptr[i] = pixel[i];
>  }
>  
> -static void vimc_sca_scale_pix(const struct vimc_sca_device *const vsca,
> +/* TODO: parallelize this function */
> +static void vimc_sca_scale_plane(const struct vimc_sca_device *const vsca,
>  			       const unsigned int lin, const unsigned int col,
> -			       const u8 *const sink_frame)
> +			       const struct vimc_frame *sink_frame,
> +			       u8 num_plane, u32 width)
> +
>  {
>  	unsigned int i, j, index;
>  	const u8 *pixel;
>  
>  	/* Point to the pixel value in position (lin, col) in the sink frame */
> -	index = VIMC_FRAME_INDEX(lin, col,
> -				 vsca->sink_fmt.width,
> -				 vsca->bpp);
> -	pixel = &sink_frame[index];
> +	index = VIMC_FRAME_INDEX(lin, col, width, vsca->bpp[num_plane]);
> +	pixel = &sink_frame->plane_addr[num_plane][index];
>  
>  	dev_dbg(vsca->dev,
>  		"sca: %s: --- scale_pix sink pos %dx%d, index %d ---\n",
> @@ -291,7 +305,7 @@ static void vimc_sca_scale_pix(const struct vimc_sca_device *const vsca,
>  	 * in the scaled src frame
>  	 */
>  	index = VIMC_FRAME_INDEX(lin * sca_mult, col * sca_mult,
> -				 vsca->sink_fmt.width * sca_mult, vsca->bpp);
> +				 width * sca_mult, vsca->bpp[num_plane]);
>  
>  	dev_dbg(vsca->dev, "sca: %s: scale_pix src pos %dx%d, index %d\n",
>  		vsca->sd.name, lin * sca_mult, col * sca_mult, index);
> @@ -301,32 +315,46 @@ static void vimc_sca_scale_pix(const struct vimc_sca_device *const vsca,
>  		/* Iterate through each beginning of a
>  		 * pixel repetition in a line
>  		 */
> -		for (j = 0; j < sca_mult * vsca->bpp; j += vsca->bpp) {
> +		unsigned int bpp = vsca->bpp[num_plane];
> +
> +		for (j = 0; j < sca_mult * bpp; j += bpp) {
>  			dev_dbg(vsca->dev,
>  				"sca: %s: sca: scale_pix src pos %d\n",
>  				vsca->sd.name, index + j);
>  
>  			/* copy the pixel to the position index + j */
>  			vimc_sca_fill_pix(
> -				&vsca->src_frame.plane_addr[0][index + j],
> -				pixel, vsca->bpp);
> +				&vsca->src_frame.plane_addr[num_plane][index + j],
> +				pixel, bpp);
>  		}
>  
>  		/* move the index to the next line */
> -		index += vsca->src_line_size;
> +		index += vsca->src_line_size[num_plane];
>  	}
>  }
>  
>  static void vimc_sca_fill_src_frame(const struct vimc_sca_device *const vsca,
> -				    const u8 *const sink_frame)
> +				    const struct vimc_frame *sink_frame)
>  {
> -	unsigned int i, j;
> +	u32 i, j, width, height;
> +	unsigned int num_plane;
> +	const struct v4l2_format_info *info;
> +
> +	info = v4l2_format_info(sink_frame->pixelformat);
>  
>  	/* Scale each pixel from the original sink frame */
>  	/* TODO: implement scale down, only scale up is supported for now */
> -	for (i = 0; i < vsca->sink_fmt.height; i++)
> -		for (j = 0; j < vsca->sink_fmt.width; j++)
> -			vimc_sca_scale_pix(vsca, i, j, sink_frame);
> +	for (num_plane = 0; num_plane < info->comp_planes; num_plane++) {
> +		width = vsca->sink_fmt.width /
> +					((num_plane == 0) ? 1 : info->vdiv);
> +		height = vsca->sink_fmt.height /
> +					((num_plane == 0) ? 1 : info->hdiv);
> +
> +		for (i = 0; i < height; i++)
> +			for (j = 0; j < width; j++)
> +				vimc_sca_scale_plane(vsca, i, j, sink_frame,
> +						     num_plane, width);
> +	}
>  }
>  
>  static struct vimc_frame *vimc_sca_process_frame(struct vimc_ent_device *ved,
> @@ -339,7 +367,7 @@ static struct vimc_frame *vimc_sca_process_frame(struct vimc_ent_device *ved,
>  	if (!ved->stream)
>  		return ERR_PTR(-EINVAL);
>  
> -	vimc_sca_fill_src_frame(vsca, sink_frame->plane_addr[0]);
> +	vimc_sca_fill_src_frame(vsca, sink_frame);
>  
>  	return &vsca->src_frame;
>  };
> 
