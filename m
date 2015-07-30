Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36762 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbbG3Jjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 05:39:47 -0400
Received: by wicgb10 with SMTP id gb10so235605985wic.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 02:39:46 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:39:42 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 11/12] [media] tsin: c8sectpfe: Add Kconfig and Makefile
 for the driver.
Message-ID: <20150730093942.GA488@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
 <1435158670-7195-12-git-send-email-peter.griffin@linaro.org>
 <20150722185615.2033a1fb@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150722185615.2033a1fb@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for reviewing. Sending my reply again, as it looks like I dropped the
CC list on my first reply, and my second reply bounced on the mailing lists :-(

On Wed, 22 Jul 2015, Mauro Carvalho Chehab wrote:

> Em Wed, 24 Jun 2015 16:11:09 +0100
> Peter Griffin <peter.griffin@linaro.org> escreveu:
> 
> > This patch adds the Kconfig and Makefile for the c8sectpfe driver
> > so it will be built. It also selects additional demodulator and tuners
> > which are required by the supported NIM cards.
> > 
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  drivers/media/Kconfig                 |  1 +
> >  drivers/media/Makefile                |  1 +
> >  drivers/media/tsin/c8sectpfe/Kconfig  | 26 ++++++++++++++++++++++++++
> >  drivers/media/tsin/c8sectpfe/Makefile | 11 +++++++++++
> >  4 files changed, 39 insertions(+)
> >  create mode 100644 drivers/media/tsin/c8sectpfe/Kconfig
> >  create mode 100644 drivers/media/tsin/c8sectpfe/Makefile
> > 
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 1570992..82bc1dc 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -170,6 +170,7 @@ source "drivers/media/pci/Kconfig"
> >  source "drivers/media/platform/Kconfig"
> >  source "drivers/media/mmc/Kconfig"
> >  source "drivers/media/radio/Kconfig"
> > +source "drivers/media/tsin/c8sectpfe/Kconfig"
> >  
> >  comment "Supported FireWire (IEEE 1394) Adapters"
> >  	depends on DVB_CORE && FIREWIRE
> > diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> > index e608bbc..0a567b8 100644
> > --- a/drivers/media/Makefile
> > +++ b/drivers/media/Makefile
> > @@ -29,5 +29,6 @@ obj-y += rc/
> >  #
> >  
> >  obj-y += common/ platform/ pci/ usb/ mmc/ firewire/
> > +obj-$(CONFIG_DVB_C8SECTPFE) += tsin/c8sectpfe/
> 
> Hmm... why are you adding it at a new "tsin" directory? We're putting
> those SoC platform drivers under platform/.

I didn't realise that. I will move this under there in the V2 patchset then?

The rationale behind a new 'tsin' directory was that all the current DVB
drivers seemed to be grouped by the underlying bus on which TS
data enters the system (e.g. pci / usb).

As this didn't fit in with that scheme I created a new tsin directory for SoC's
which have dedicated hardware for Transport Stream INput (tsin) into the SoC.

regards,

Peter.

p.s. Mauro - appologies again for spaming you
