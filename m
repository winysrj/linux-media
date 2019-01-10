Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E5DC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 16:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 022E420685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 16:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfAJQVu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 11:21:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:18350 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfAJQVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 11:21:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 08:17:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="107242978"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 10 Jan 2019 08:17:44 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 46E752050A; Thu, 10 Jan 2019 18:17:43 +0200 (EET)
Date:   Thu, 10 Jan 2019 18:17:43 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, bingbu.cao@intel.com
Subject: Re: [PATCH v2 1/1] media: Use common test pattern menu entries
Message-ID: <20190110161742.oyyby5g4fo6peg2f@paasikivi.fi.intel.com>
References: <20181204134042.21027-1-sakari.ailus@linux.intel.com>
 <20181204124142.1d3a8543@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204124142.1d3a8543@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Tue, Dec 04, 2018 at 12:41:42PM -0200, Mauro Carvalho Chehab wrote:
> Em Tue,  4 Dec 2018 15:40:42 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > While the test pattern menu itself is not standardised, many devices
> > support the same test patterns. Aligning the menu entries helps the user
> > space to use the interface, and adding macros for the menu entry strings
> > helps to keep them aligned.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > since v1:
> > 
> > - Fix indentation of menu strings
> > - Remove "8" from the macro names
> > 
> >  drivers/media/i2c/imx258.c             | 10 +++++-----
> >  drivers/media/i2c/imx319.c             | 10 +++++-----
> >  drivers/media/i2c/imx355.c             | 10 +++++-----
> >  drivers/media/i2c/ov2640.c             |  4 ++--
> >  drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++-----
> >  include/uapi/linux/v4l2-controls.h     |  5 +++++
> >  6 files changed, 27 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> > index f86ae18bc104..df5f016cebd9 100644
> > --- a/drivers/media/i2c/imx258.c
> > +++ b/drivers/media/i2c/imx258.c
> > @@ -498,11 +498,11 @@ static const struct imx258_reg mode_1048_780_regs[] = {
> >  };
> >  
> >  static const char * const imx258_test_pattern_menu[] = {
> > -	"Disabled",
> > -	"Solid Colour",
> > -	"Eight Vertical Colour Bars",
> > -	"Colour Bars With Fade to Grey",
> > -	"Pseudorandom Sequence (PN9)",
> > +	V4L2_TEST_PATTERN_DISABLED,
> > +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS_FADE_TO_GREY,
> > +	V4L2_TEST_PATTERN_PN9,
> >  };
> >  
> >  /* Configurations for supported link frequencies */
> > diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
> > index 17c2e4b41221..d9d4176b9d37 100644
> > --- a/drivers/media/i2c/imx319.c
> > +++ b/drivers/media/i2c/imx319.c
> > @@ -1647,11 +1647,11 @@ static const struct imx319_reg mode_1280x720_regs[] = {
> >  };
> >  
> >  static const char * const imx319_test_pattern_menu[] = {
> > -	"Disabled",
> > -	"Solid Colour",
> > -	"Eight Vertical Colour Bars",
> > -	"Colour Bars With Fade to Grey",
> > -	"Pseudorandom Sequence (PN9)",
> > +	V4L2_TEST_PATTERN_DISABLED,
> > +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS_FADE_TO_GREY,
> > +	V4L2_TEST_PATTERN_PN9,
> >  };
> >  
> >  /* supported link frequencies */
> > diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
> > index bed293b60e50..99138a291cb8 100644
> > --- a/drivers/media/i2c/imx355.c
> > +++ b/drivers/media/i2c/imx355.c
> > @@ -875,11 +875,11 @@ static const struct imx355_reg mode_820x616_regs[] = {
> >  };
> >  
> >  static const char * const imx355_test_pattern_menu[] = {
> > -	"Disabled",
> > -	"Solid Colour",
> > -	"Eight Vertical Colour Bars",
> > -	"Colour Bars With Fade to Grey",
> > -	"Pseudorandom Sequence (PN9)",
> > +	V4L2_TEST_PATTERN_DISABLED,
> > +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS_FADE_TO_GREY,
> > +	V4L2_TEST_PATTERN_PN9,
> >  };
> >  
> >  /* supported link frequencies */
> > diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> > index 5d2d6735cc78..65058d9a5d51 100644
> > --- a/drivers/media/i2c/ov2640.c
> > +++ b/drivers/media/i2c/ov2640.c
> > @@ -707,8 +707,8 @@ static int ov2640_reset(struct i2c_client *client)
> >  }
> >  
> >  static const char * const ov2640_test_pattern_menu[] = {
> > -	"Disabled",
> > -	"Eight Vertical Colour Bars",
> > +	V4L2_TEST_PATTERN_DISABLED,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS,
> >  };
> >  
> >  /*
> > diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> > index 58a45c353e27..5c9bcc9438ec 100644
> > --- a/drivers/media/i2c/smiapp/smiapp-core.c
> > +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> > @@ -409,11 +409,11 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
> >  }
> >  
> >  static const char * const smiapp_test_patterns[] = {
> > -	"Disabled",
> > -	"Solid Colour",
> > -	"Eight Vertical Colour Bars",
> > -	"Colour Bars With Fade to Grey",
> > -	"Pseudorandom Sequence (PN9)",
> > +	V4L2_TEST_PATTERN_DISABLED,
> > +	V4L2_TEST_PATTERN_SOLID_COLOUR,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS,
> > +	V4L2_TEST_PATTERN_VERT_COLOUR_BARS_FADE_TO_GREY,
> > +	V4L2_TEST_PATTERN_PN9,
> >  };
> >  
> >  static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index 998983a6e6b7..acb2a57fa5d6 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -1014,6 +1014,11 @@ enum v4l2_jpeg_chroma_subsampling {
> >  #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
> >  #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
> >  #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> 
> > +#define V4L2_TEST_PATTERN_DISABLED		"Disabled"
> > +#define V4L2_TEST_PATTERN_SOLID_COLOUR		"Solid Colour"
> > +#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	"Eight Vertical Colour Bars"
> > +#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS_FADE_TO_GREY "Colour Bars With Fade to Grey"
> > +#define V4L2_TEST_PATTERN_PN9			"Pseudorandom Sequence (PN9)"
> 
> I like the idea of using defines for those, but I wouldn't put them
> at the uAPI.
> 
> See, once we put anything there, it is set into a stone, and we will
> be bound forever to whatever name we place on it.
> 
> It would be a way better to have them at include/media/v4l2-ctrls.h.

The intent was to let the user space use these as well. As the menu
positions are not standardised (items are device specific), this would
still allow the user space to make an informed choice of what to select in
the menu: the functionality can still be the same for some entries.

In this case, especially the test patterns originating from the SMIA
specification are supported by many sensors, even if not otherwise SMIA
compliant.

> 
> >  #define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
> >  #define V4L2_CID_DIGITAL_GAIN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 5)
> >  
> 
> Thanks,
> Mauro

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
