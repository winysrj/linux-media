Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37168 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753342Ab2IAJ5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 05:57:13 -0400
Date: Sat, 1 Sep 2012 12:57:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>,
	LMML <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Message-ID: <20120901095707.GB6348@valkosipuli.retiisi.org.uk>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com>
 <20120802000756.GM26642@valkosipuli.retiisi.org.uk>
 <502331F8.3050503@ti.com>
 <20120816162318.GZ29636@valkosipuli.retiisi.org.uk>
 <CA+V-a8tNnevox8OcXc_jxDzHdrxdF9Z-Nf2Rn0QaBsnM=n5CfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8tNnevox8OcXc_jxDzHdrxdF9Z-Nf2Rn0QaBsnM=n5CfA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Wed, Aug 29, 2012 at 08:11:50PM +0530, Prabhakar Lad wrote:
...
> >> >> +        unsigned short len;
> >> >> +        void *config;
> >> >> +    };
> >> >> +
> >> >> +5: IOCTL: VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS
> >> >> +Description:
> >> >> +    Sets/Gets the CCDC parameter
> >> >> +Parameter:
> >> >> +    /**
> >> >> +     * struct ccdc_config_params_raw - structure for configuring
> >> >> ccdc params
> >> >> +     * @linearize: linearization parameters for image sensor data input
> >> >> +     * @df_csc: data formatter or CSC
> >> >> +     * @dfc: defect Pixel Correction (DFC) configuration
> >> >> +     * @bclamp: Black/Digital Clamp configuration
> >> >> +     * @gain_offset: Gain, offset adjustments
> >> >> +     * @culling: Culling
> >> >> +     * @pred: predictor for DPCM compression
> >> >> +     * @horz_offset: horizontal offset for Gain/LSC/DFC
> >> >> +     * @vert_offset: vertical offset for Gain/LSC/DFC
> >> >> +     * @col_pat_field0: color pattern for field 0
> >> >> +     * @col_pat_field1: color pattern for field 1
> >> >> +     * @data_size: data size from 8 to 16 bits
> >> >> +     * @data_shift: data shift applied before storing to SDRAM
> >> >> +     * @test_pat_gen: enable input test pattern generation
> >> >> +     */
> >> >> +    struct ccdc_config_params_raw {
> >> >> +        struct ccdc_linearize linearize;
> >> >> +        struct ccdc_df_csc df_csc;
> >> >> +        struct ccdc_dfc dfc;
> >> >> +        struct ccdc_black_clamp bclamp;
> >> >> +        struct ccdc_gain_offsets_adj gain_offset;
> >> >> +        struct ccdc_cul culling;
> >> >> +        enum ccdc_dpcm_predictor pred;
> >> >> +        unsigned short horz_offset;
> >> >> +        unsigned short vert_offset;
> >> >> +        struct ccdc_col_pat col_pat_field0;
> >> >> +        struct ccdc_col_pat col_pat_field1;
> >> >> +        enum ccdc_data_size data_size;
> >> >> +        enum ccdc_datasft data_shift;
> >> >> +        unsigned char test_pat_gen;
> >> >
> >> > Are the struct definitions available somewhere? I bet more than the test
> >> > pattern Laurent suggested might be implementable as controls. The dpcm
> >> > predictor, for example.
> >> I will check on the DPSM test pattern. The definitions are available
> >> at:http://davinci-linux-open-source.1494791.n2.nabble.com/RESEND-RFC-PATCH-v4-00-15-RFC-for-Media-Controller-capture-driver-for-DM365-td7003648.html
> >
> > Thanks!
> >
> > I think the DPCM predictor should be made a control in the image processing
> > controls class. The test pattern would fit there as well I think.
> >
> For test pattern you meant control to enable/disable it ?

There are two approaches I can think of.

One is a menu control which can be used to choose the test pattern (or
disable it). The control could be standardised but the menu items would have
to be hardware-specific since the test patterns themselves are not
standardised.

The alternative is to have a boolean control to enable (and disable) the
test pattern and then a menu control to choose which one to use. Using or
implemeting the control to select the test pattern isn't even strictly
necessary to get a test pattern out of the device: one can enable it without
knowing which one it is.

So which one would be better? Similar cases include V4L2_CID_SCENE_MODE
which is used to choose the scene mode from a list of alternatives. The main
difference to this case is that the menu items of the scene mode control are
standardised, too.

I'd be inclined to have a single menu control, even if the other menu items
will be device-specific. The first value (0) still has to be documented to
mean the test pattern is disabled.

Laurent, Hans: what do you think?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
