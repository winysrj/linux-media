Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35467 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdFZS4j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 14:56:39 -0400
Date: Mon, 26 Jun 2017 13:56:32 -0500
From: Rob Herring <robh@kernel.org>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
Message-ID: <20170626185632.bfwuogm62ouo5y2j@rob-hp-laptop>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
 <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 23, 2017 at 12:25:33PM +0200, H. Nikolaus Schaller wrote:
> Hi Hugues,
> 
> > Am 22.06.2017 um 17:05 schrieb Hugues Fruchet <hugues.fruchet@st.com>:
> > 
> > From: "H. Nikolaus Schaller" <hns@goldelico.com>
> > 
> > This adds documentation of device tree bindings
> > for the OV965X family camera sensor module.
> > 
> > Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> > Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> > ---
> > .../devicetree/bindings/media/i2c/ov965x.txt       | 37 ++++++++++++++++++++++
> > 1 file changed, 37 insertions(+)
> > create mode 100644 Documentation/devicetree/bindings/media/i2c/ov965x.txt

[...]

> > +Optional Properties:
> > +- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
> > +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
> 
> Here I wonder why you did split that up into two gpios. Each "*-gpios" can have
> multiple entries and if one is not used, a 0 can be specified to make it being ignored.
> 
> But it is up to DT maintainers what they prefer: separate single gpios or a single gpio array.

I think that is pretty clear if you survey a number of bindings (hint: 
it's the former).

Rob
