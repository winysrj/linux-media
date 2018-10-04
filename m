Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45227 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbeJEEN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 00:13:57 -0400
Date: Thu, 4 Oct 2018 23:18:44 +0200
From: ektor5 <ek5.chimenti@gmail.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: hverkuil@xs4all.nl, luca.pisani@udoo.org, jose.abreu@synopsys.com,
        sean@mess.org, sakari.ailus@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] Add SECO Boards CEC device driver
Message-ID: <20181004211842.qxfvojrcbsl7llsx@Ettosoft-T55>
References: <cover.1538474121.git.ek5.chimenti@gmail.com>
 <757ab7a8-4bb2-4573-5870-eae2b9745650@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757ab7a8-4bb2-4573-5870-eae2b9745650@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 04, 2018 at 02:29:32PM +0200, Neil Armstrong wrote:
> Hi Ettore,
> 
> On 02/10/2018 18:59, ektor5 wrote:
> > This series of patches aims to add CEC functionalities to SECO
> > devices, in particular UDOO X86.
> > 
> > The communication is achieved via Braswell SMBus (i2c-i801) to the
> > onboard STM32 microcontroller that handles the CEC signals. The driver
> > use direct access to the PCI addresses, due to the limitations of the
> > specific driver in presence of ACPI calls.
> > 
> > The basic functionalities are tested with success with cec-ctl and
> > cec-compliance.
> 
> Glad to see another user of the i915 cec notifier !

Thanks to you for the patch! It works really well!

Ettore

> 
> Neil
> 
> > 
> > Ettore Chimenti (2):
> >   media: add SECO cec driver
> >   seco-cec: add Consumer-IR support
> > 
> >  MAINTAINERS                                |   6 +
> >  drivers/media/platform/Kconfig             |  21 +
> >  drivers/media/platform/Makefile            |   4 +
> >  drivers/media/platform/seco-cec/Makefile   |   1 +
> >  drivers/media/platform/seco-cec/seco-cec.c | 859 +++++++++++++++++++++
> >  drivers/media/platform/seco-cec/seco-cec.h | 143 ++++
> >  6 files changed, 1034 insertions(+)
> >  create mode 100644 drivers/media/platform/seco-cec/Makefile
> >  create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
> >  create mode 100644 drivers/media/platform/seco-cec/seco-cec.h
> > 
> 
