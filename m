Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752647AbdFPLsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 07:48:12 -0400
Date: Fri, 16 Jun 2017 14:48:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170616114807.GO12407@valkosipuli.retiisi.org.uk>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
 <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Mon, Jun 12, 2017 at 06:59:18PM +0900, Tomasz Figa wrote:
> Hi Yong,
> 
> Please see my comments inline.
> 
> On Wed, Jun 7, 2017 at 10:34 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> > This patch adds CIO2 CSI-2 device driver for
> > Intel's IPU3 camera sub-system support.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/Kconfig                |    2 +
> >  drivers/media/pci/Makefile               |    3 +-
> >  drivers/media/pci/intel/Makefile         |    5 +
> >  drivers/media/pci/intel/ipu3/Kconfig     |   17 +
> >  drivers/media/pci/intel/ipu3/Makefile    |    1 +
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1788 ++++++++++++++++++++++++++++++
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.h |  424 +++++++
> >  7 files changed, 2239 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/media/pci/intel/Makefile
> >  create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
> >  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
> [snip]
> > diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
> > new file mode 100644
> > index 0000000..2a895d6
> > --- /dev/null
> > +++ b/drivers/media/pci/intel/ipu3/Kconfig
> > @@ -0,0 +1,17 @@
> > +config VIDEO_IPU3_CIO2
> > +       tristate "Intel ipu3-cio2 driver"
> > +       depends on VIDEO_V4L2 && PCI
> > +       depends on MEDIA_CONTROLLER
> > +       depends on HAS_DMA
> > +       depends on ACPI
> 
> I wonder if it wouldn't make sense to make this depend on X86 (||
> COMPILE_TEST) as well. Are we expecting a standalone PCI(e) card with
> this device in the future?

All I'm aware of are integrated with the CPU (or the chipset).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
