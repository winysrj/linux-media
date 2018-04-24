Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55454 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756653AbeDXKdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:33:05 -0400
Date: Tue, 24 Apr 2018 13:33:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        slongerbeam@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        dragonboard@lists.96boards.org,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [RESEND PATCH] media: i2c: ov5640: Add pixel clock support
Message-ID: <20180424103303.rrgv2d33stnll2cx@valkosipuli.retiisi.org.uk>
References: <1522335300-13467-1-git-send-email-manivannan.sadhasivam@linaro.org>
 <1522335300-13467-2-git-send-email-manivannan.sadhasivam@linaro.org>
 <CAMZdPi-VCsct6S4cYCvN_XniFB9=pJqC8hnTdQnvL5H_CU2a8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi-VCsct6S4cYCvN_XniFB9=pJqC8hnTdQnvL5H_CU2a8Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 11:01:18AM +0200, Loic Poulain wrote:
> On 29 March 2018 at 16:55, Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> > Some of the camera subsystems like camss in Qualcommm MSM chipsets
> > require pixel clock support in camera sensor drivers. So, this commit
> > adds a default pixel clock rate of 96MHz to OV5640 camera sensor driver.
> >
> > According to the datasheet, 96MHz can be used as a pixel clock rate for
> > most of the modes.
> >
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Tested-by: Loic Poulain <loic.poulain@linaro.org>
> 
> It works for me on Dragonboard 410c + D3 camera mezzanine (ov5640) .
> 
> Any comments on this change?

<URL:https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Maxime+Ripard&state=*&q=ov5640>

There's also another set that adds PIXEL_CLOCK (as well as LINK_FREQ)
support to the driver, that seems more complete than this patch but
requires a rebase on Maxime's patches:

<URL:https://patchwork.linuxtv.org/project/linux-media/list/?submitter=7218&state=*&q=ov5640>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
