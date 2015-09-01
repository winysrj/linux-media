Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37477 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbbIAKfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 06:35:03 -0400
Received: by wicfx3 with SMTP id fx3so7435461wic.0
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2015 03:35:01 -0700 (PDT)
Date: Tue, 1 Sep 2015 11:34:58 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Lee Jones <lee.jones@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	valentinrothberg@gmail.com, hugues.fruchet@st.com
Subject: Re: [PATCH v3 4/6] [media] c8sectpfe: Update binding to reset-gpios
Message-ID: <20150901103458.GA9149@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
 <1440784362-31217-5-git-send-email-peter.griffin@linaro.org>
 <CABxcv=nM7MBK2EcD1-YK5y0J1hBtxV+6Wu812C23pNkAzigu7g@mail.gmail.com>
 <20150901090916.GM4796@x1>
 <CABxcv==iC+mkVGKi_9LSidPjFa2WTooARMCOcWW1Nyr80UYJgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABxcv==iC+mkVGKi_9LSidPjFa2WTooARMCOcWW1Nyr80UYJgw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, 01 Sep 2015, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> On Tue, Sep 1, 2015 at 11:09 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Tue, 01 Sep 2015, Javier Martinez Canillas wrote:
> >> On Fri, Aug 28, 2015 at 7:52 PM, Peter Griffin <peter.griffin@linaro.org> wrote:
> >> > gpio.txt documents that GPIO properties should be named
> >> > "[<name>-]gpios", with <name> being the purpose of this
> >> > GPIO for the device.
> >> >
> >> > This change has been done as one atomic commit.
> >> >
> >> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> >> > Acked-by: Lee Jones <lee.jones@linaro.org>
> >> > ---
> >> >  Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt | 6 +++---
> >> >  arch/arm/boot/dts/stihxxx-b2120.dtsi                          | 4 ++--
> >> >  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 2 +-
> >> >  3 files changed, 6 insertions(+), 6 deletions(-)
> >> >
> >> > diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> >> > index d4def76..e70d840 100644
> >> > --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> >> > +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> >> > @@ -35,7 +35,7 @@ Required properties (tsin (child) node):
> >> >
> >> >  - tsin-num     : tsin id of the InputBlock (must be between 0 to 6)
> >> >  - i2c-bus      : phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
> >> > -- rst-gpio     : reset gpio for this tsin channel.
> >> > +- reset-gpios  : reset gpio for this tsin channel.
> >>
> >> The documentation is a bit outdated, the GPIO subsystem supports both
> >> -gpio and -gpios, see commit:
> >>
> >> dd34c37aa3e8 ("gpio: of: Allow -gpio suffix for property names")
> >>
> >> So it makes sense to me to use -gpio instead of -gpios in this case
> >> since is a single GPIO. Also rst is already a descriptive name since
> >> that's how many datasheets name a reset pin. I'm not saying I'm
> >> against this patch, just pointing out since the commit message is a
> >> bit misleading.

Ok thanks for pointing that out. It's nice to know the original binding was
actually OK.

> >
> > As I suggested this patch, I feel I must comment.
> >
> > My order of preference would be:
> >
> >  reset-gpio
> >  reset-gpios
> >  rst-gpio
> >  rst-gpios
> >
> > This current patch is No2, so it's okay to stay IMHO.
> >
> 
> If the property is being changed anyways, why not going with No1 then?

I've changed to No1 in v4.

> 
> As I said, I'm not against the patch but I think the commit message
> has to be reworded since implies that the problem is that the -gpio
> sufix is being used instead of -gpios. But since both are supported by
> the GPIO subsystem, the commit should mention that "reset" is more
> clear and easier to read than "rst" or something along those lines.

I've re-worded the commit message like you suggest in v4

> 
> BTW, I just posted a patch for the GPIO doc to mention that -gpio is
> also supported:
> 
> https://patchwork.kernel.org/patch/7103761/

Ok thanks for the pointer.

regards,

Peter.
