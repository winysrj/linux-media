Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:45604 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbeEIKFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 06:05:38 -0400
Received: by mail-vk0-f48.google.com with SMTP id 203-v6so21461552vka.12
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 03:05:38 -0700 (PDT)
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com. [209.85.213.46])
        by smtp.gmail.com with ESMTPSA id s39sm10371019uac.36.2018.05.09.03.05.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 May 2018 03:05:36 -0700 (PDT)
Received: by mail-vk0-f46.google.com with SMTP id x66-v6so16923505vka.11
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 03:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com> <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
In-Reply-To: <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 09 May 2018 10:05:25 +0000
Message-ID: <CAAFQd5CvPCfFx6Nxb26JdSAfD_YNe=-hvyJ=iKLcTA0LpxC4_g@mail.gmail.com>
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
To: "Chen, JasonX Z" <jasonx.z.chen@intel.com>
Cc: "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,

On Wed, May 9, 2018 at 6:28 PM Chen, JasonX Z <jasonx.z.chen@intel.com>
wrote:

> Hello Tomasz

> >> +/* Test Pattern Control */
> >> +#define IMX258_REG_TEST_PATTERN                0x0600
> >> +#define IMX258_TEST_PATTERN_DISABLE    0
> >> +#define IMX258_TEST_PATTERN_SOLID_COLOR        1
> >> +#define IMX258_TEST_PATTERN_COLOR_BARS 2 #define
> >> +IMX258_TEST_PATTERN_GREY_COLOR 3
> >> +#define IMX258_TEST_PATTERN_PN9                4
> >> +
> >> +/* Orientation */
> >> +#define REG_MIRROR_FLIP_CONTROL                0x0101
> >> +#define REG_CONFIG_MIRROR_FLIP         0x03
> >> +#define REG_CONFIG_FLIP_TEST_PATTERN   0x02
> >
> >The names are inconsistent here. All other register addresses start with
IMX258_REG and values with IMX258_<field name> (no REG).
> >
> >[snip]

> We will update at next patch.

Thanks. (As Sakari's said, please send an incremental patch, not resend.)


> >> +static const char * const imx258_test_pattern_menu[] = {
> >> +       "Disabled",
> >> +       "Color Bars",
> >> +       "Solid Color",
> >> +       "Grey Color Bars",
> >> +       "PN9"
> >> +};
> >> +
> >> +static const int imx258_test_pattern_val[] = {
> >> +       IMX258_TEST_PATTERN_DISABLE,
> >> +       IMX258_TEST_PATTERN_COLOR_BARS,
> >> +       IMX258_TEST_PATTERN_SOLID_COLOR,
> >> +       IMX258_TEST_PATTERN_GREY_COLOR,
> >> +       IMX258_TEST_PATTERN_PN9,
> >> +};
> >
> >By reordering imx258_test_pattern_menu[], this array can be removed and
> >ctrl->val can be used directly. It is validated by control framework to
> >ctrl->be
> >within menu range and so safe to be used for programming hardware.
> >
> >[snip]

> IPU3 HAL has a handler to bind test_pattern mode.
> The COLOR BAR MODE in HAL has been configured to 1 when APP requests to
output color bar image.
> However Sony sensor's COLOR BAR MODE is designed as 2 in register table.
(grey color bars as 1).
> When HAL sends handler to driver to switch test pattern mode (to COLOR
BAR - val: 1), it will be grey color, since driver still set
TEST_PATTERN_MODE reg value to 1, those it is not what we expected.

> That is why we have to make an array with index to arrange the order of
the test pattern items, so driver will choose COLOR BAR correctly when HAL
send test_pattern message (with 1).
> The concept is the test_pattern_menu could be listed in driver per real
requirement, no matter how the sensor register is designed.


V4L2 specification does not define any particular order of menu entries in
V4L2_CID_TEST_PATTERN. The application should query the strings in the menu
and determine the option it needs based on that. If it hardcodes particular
index, it's a bug.

> >> +       case V4L2_CID_TEST_PATTERN:
> >> +               ret = imx258_write_reg(imx258, IMX258_REG_TEST_PATTERN,
> >> +                               IMX258_REG_VALUE_16BIT,
> >> +                               imx258_test_pattern_val[ctrl->val]);
> >> +
> >> +               ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> >> +                               IMX258_REG_VALUE_08BIT,
> >> +                               ctrl->val == imx258_test_pattern_val
> >> +                               [IMX258_TEST_PATTERN_DISABLE] ?
> >> +                               REG_CONFIG_MIRROR_FLIP :
> >> +                               REG_CONFIG_FLIP_TEST_PATTERN);
> >
> >The comparison above doesn't make any sense. ctrl->val is an index into
imx258_test_pattern_val[], but
imx258_test_pattern_val[IMX258_TEST_PATTERN_DISABLE] is a register value.
> >Moreover, IMX258_TEST_PATTERN_DISABLE is also a register value, so it
doesn't make sense to use it for indexing the array. I'd suggest simply
checking for (!ctrl->val).
> >

> We will update at next patch.

Thanks.

Best regards,
Tomasz
