Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38331 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2CHPGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 10:06:35 -0500
Received: by iagz16 with SMTP id z16so797094iag.19
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 07:06:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331215050-20823-2-git-send-email-sakari.ailus@iki.fi>
References: <1960253.l1xo097dr7@avalon>
	<1331215050-20823-2-git-send-email-sakari.ailus@iki.fi>
Date: Thu, 8 Mar 2012 16:06:34 +0100
Message-ID: <CAGGh5h37Rd9O1Hp6FHBo1KcQRdEb=2OJxGkA0aJmyWkEB9juGQ@mail.gmail.com>
Subject: Re: [PATCH v5.1 35/35] smiapp: Add driver
From: jean-philippe francois <jp.francois@cynove.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 8 mars 2012 14:57, Sakari Ailus <sakari.ailus@iki.fi> a écrit :
> Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
> three subdevs, pixel array, binner and scaler --- in case the device has a
> scaler.
>
> Currently it relies on the board code for external clock handling. There is
> no fast way out of this dependency before the ISP drivers (omap3isp) among
> others will be able to export that clock through the clock framework
> instead.
>
> +       case V4L2_CID_EXPOSURE:
> +               return smiapp_write(
> +                       client,
> +                       SMIAPP_REG_U16_COARSE_INTEGRATION_TIME, ctrl->val);
> +
At this point, knowing pixel clock and line length, it is possible
to get / set the exposure in useconds or millisecond value.

>From userspace, if for example you change the format and crop,
you can just set the expo to a value in msec or usec, and get the
same exposure after your format change.

The driver is IMO the place where we have all the info. Here is some
example code with usec. (The 522 constant is the fine integration register...)

static int  mt9j_expo_to_shutter(struct usb_ovfx2 * ov, u32 expo)
{
	int rc = 0;
	u32 expo_pix; // exposition in pixclk unit
	u16 coarse_expo;
	u16 row_time;
	expo_pix = expo * 96;   /// pixel clock in MHz
	MT9J_RREAD(ov, LINE_LENGTH_PCK, &row_time);
	expo_pix = expo_pix - 522;
	coarse_expo = (expo_pix + row_time/2)/ row_time;
	MT9J_RWRITE(ov, COARSE_EXPO_REG, coarse_expo);
	return rc;
}

static int  mt9j_shutter_to_expo(struct usb_ovfx2 * ov, u32  * expo)
{
	int rc = 0;
	u32 expo_pix; // exposition in pixclk unit
	u16 coarse_expo;
	u16 row_time;
	MT9J_RREAD(ov, LINE_LENGTH_PCK, &row_time);
	MT9J_RREAD(ov, COARSE_EXPO_REG, &coarse_expo);
	expo_pix = row_time * coarse_expo + 522;
	*expo = expo_pix / (96);
	return rc;
}

Maybe you have enough on your plate for now, and this can
wait after inclusion, but it is a nice abstraction to have  from
userspace point of view.
