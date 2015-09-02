Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38146 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbbIBPDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2015 11:03:06 -0400
Received: by wiclp12 with SMTP id lp12so22438328wic.1
        for <linux-media@vger.kernel.org>; Wed, 02 Sep 2015 08:03:04 -0700 (PDT)
Date: Wed, 2 Sep 2015 16:03:01 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Valentin Rothberg <valentinrothberg@gmail.com>,
	hugues.fruchet@st.com
Subject: Re: [PATCH v3 4/6] [media] c8sectpfe: Update binding to reset-gpios
Message-ID: <20150902150301.GA15477@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
 <1440784362-31217-5-git-send-email-peter.griffin@linaro.org>
 <CABxcv=nM7MBK2EcD1-YK5y0J1hBtxV+6Wu812C23pNkAzigu7g@mail.gmail.com>
 <CAL_JsqLccRKCnASOK-tAUn=ifZpQ3hCEJ1eg1hmrei=3vEpzFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLccRKCnASOK-tAUn=ifZpQ3hCEJ1eg1hmrei=3vEpzFA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Tue, 01 Sep 2015, Rob Herring wrote:

> On Tue, Sep 1, 2015 at 3:32 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
> > Hello Peter,
> >
> > On Fri, Aug 28, 2015 at 7:52 PM, Peter Griffin <peter.griffin@linaro.org> wrote:
> >> gpio.txt documents that GPIO properties should be named
> >> "[<name>-]gpios", with <name> being the purpose of this
> >> GPIO for the device.
> >>
> >> This change has been done as one atomic commit.
> >>
> >> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> >> Acked-by: Lee Jones <lee.jones@linaro.org>
> >> ---
> >>  Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt | 6 +++---
> >>  arch/arm/boot/dts/stihxxx-b2120.dtsi                          | 4 ++--
> >>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 2 +-
> >>  3 files changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> >> index d4def76..e70d840 100644
> >> --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> >> +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> >> @@ -35,7 +35,7 @@ Required properties (tsin (child) node):
> >>
> >>  - tsin-num     : tsin id of the InputBlock (must be between 0 to 6)
> >>  - i2c-bus      : phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
> >> -- rst-gpio     : reset gpio for this tsin channel.
> >> +- reset-gpios  : reset gpio for this tsin channel.
> >
> > The documentation is a bit outdated, the GPIO subsystem supports both
> > -gpio and -gpios, see commit:
> >
> > dd34c37aa3e8 ("gpio: of: Allow -gpio suffix for property names")
> 
> Yes, because we have lots of them.
> 
> > So it makes sense to me to use -gpio instead of -gpios in this case
> > since is a single GPIO. Also rst is already a descriptive name since
> > that's how many datasheets name a reset pin. I'm not saying I'm
> > against this patch, just pointing out since the commit message is a
> > bit misleading.
> 
> I believe that this has been discussed at length and it was decided
> that new bindings should use "-gpios" even for 1. Just like "clocks"
> is always plural.

Doh! Ok I will change back again to 'reset-gpios'.

regards,

Peter.
