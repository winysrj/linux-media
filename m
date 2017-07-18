Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60884 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751995AbdGRTw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:52:29 -0400
Date: Tue, 18 Jul 2017 22:52:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "H. Nikolaus Schaller" <hns@goldelico.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] [PATCH v2 0/7] Add support of OV9655 camera
Message-ID: <20170718195223.zrqfrefxxzqfsojd@valkosipuli.retiisi.org.uk>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
 <8157da84-1484-8375-1f2b-9831973915b4@kernel.org>
 <956f17e6-36dd-6733-0d35-9b801ed4244d@xs4all.nl>
 <BCD1BD18-96E3-4638-8935-B5C832D8EE52@goldelico.com>
 <2dd3402e-55b0-231d-878f-5ba95ee8cb36@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dd3402e-55b0-231d-878f-5ba95ee8cb36@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 18, 2017 at 12:53:12PM +0000, Hugues FRUCHET wrote:
> 
> 
> On 07/18/2017 02:17 PM, H. Nikolaus Schaller wrote:
> > Hi,
> > 
> >> Am 18.07.2017 um 13:59 schrieb Hans Verkuil <hverkuil@xs4all.nl>:
> >>
> >> On 12/07/17 22:01, Sylwester Nawrocki wrote:
> >>> Hi Hugues,
> >>>
> >>> On 07/03/2017 11:16 AM, Hugues Fruchet wrote:
> >>>> This patchset enables OV9655 camera support.
> >>>>
> >>>> OV9655 support has been tested using STM32F4DIS-CAM extension board
> >>>> plugged on connector P1 of STM32F746G-DISCO board.
> >>>> Due to lack of OV9650/52 hardware support, the modified related code
> >>>> could not have been checked for non-regression.
> >>>>
> >>>> First patches upgrade current support of OV9650/52 to prepare then
> >>>> introduction of OV9655 variant patch.
> >>>> Because of OV9655 register set slightly different from OV9650/9652,
> >>>> not all of the driver features are supported (controls). Supported
> >>>> resolutions are limited to VGA, QVGA, QQVGA.
> >>>> Supported format is limited to RGB565.
> >>>> Controls are limited to color bar test pattern for test purpose.
> >>>
> >>> I appreciate your efforts towards making a common driver but IMO it would be
> >>> better to create a separate driver for the OV9655 sensor.  The original driver
> >>> is 1576 lines of code, your patch set adds half of that (816).  There are
> >>> significant differences in the feature set of both sensors, there are
> >>> differences in the register layout.  I would go for a separate driver, we
> >>> would then have code easier to follow and wouldn't need to worry about possible
> >>> regressions.  I'm afraid I have lost the camera module and won't be able
> >>> to test the patch set against regressions.
> >>>
> >>> IMHO from maintenance POV it's better to make a separate driver. In the end
> >>> of the day we wouldn't be adding much more code than it is being done now.
> >>
> >> I agree. We do not have great experiences in the past with trying to support
> >> multiple variants in a single driver (unless the diffs are truly small).
> > 
> > Well,
> > IMHO the diffs in ov965x are smaller (but untestable because nobody seems
> > to have an ov9650/52 board) than within the bq27xxx chips, but I can dig out
> > an old pdata based separate ov9655 driver and extend that to become DT compatible.
> > 
> > I had abandoned that separate approach in favour of extending the ov965x driver.
> > 
> > Have to discuss with Hugues how to proceed.
> > 
> > BR and thanks,
> > Nikolaus
> > 
> 
> As Sylwester and Hans, I'm also in flavour of a separate driver, the 
> fact that register set seems similar but in fact is not and that we 
> cannot test for non-regression of 9650/52 are killer for me to continue 
> on a single driver.
> We can now restart from a new fresh state of the art sensor driver 
> getting rid of legacy (pdata, old gpio, etc...).

Agreed. I bet the result will look cleaner indeed although this wasn't one
of the complex drivers.

It'd be nice that someone was able to test the ov9650/2, too, drivers that
are never used tend to break...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
