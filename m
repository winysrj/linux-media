Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38559 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbbIAH6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 03:58:15 -0400
Received: by wiclp12 with SMTP id lp12so21129394wic.1
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2015 00:58:14 -0700 (PDT)
Date: Tue, 1 Sep 2015 08:58:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	hugues.fruchet@st.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	valentinrothberg@gmail.com
Subject: Re: [PATCH v3 4/6] [media] c8sectpfe: Update binding to reset-gpios
Message-ID: <20150901075811.GK4796@x1>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
 <1440784362-31217-5-git-send-email-peter.griffin@linaro.org>
 <CAL_JsqLYes5L2Bg0R45ui24yYWgHzFSLgBPajieSLgLz09=1aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqLYes5L2Bg0R45ui24yYWgHzFSLgBPajieSLgLz09=1aw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 Aug 2015, Rob Herring wrote:

> On Fri, Aug 28, 2015 at 12:52 PM, Peter Griffin
> <peter.griffin@linaro.org> wrote:
> > gpio.txt documents that GPIO properties should be named
> > "[<name>-]gpios", with <name> being the purpose of this
> > GPIO for the device.
> >
> > This change has been done as one atomic commit.
> 
> dtb and kernel updates are not necessarily atomic, so you are breaking
> compatibility with older dtbs. You should certainly highlight that in
> the commit message.

Good idea.

> I only point this out. I'll leave it to platform
> maintainers whether or not this breakage is acceptable.

This driver is new.  The 'original' bindings are in next.  So this
binding is not even close to being ABI.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
