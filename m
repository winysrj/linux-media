Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54009
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750988AbdDJBiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 21:38:13 -0400
Date: Sun, 9 Apr 2017 22:38:03 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Cc: kbuild test robot <lkp@intel.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>
Subject: Re: [PATCH 2/5] media: Add support for CXD2880 SPI I/F
Message-ID: <20170409223803.25da1a43@vento.lan>
In-Reply-To: <02699364973B424C83A42A84B04FDA8533BC79@JPYOKXMS113.jp.sony.com>
References: <1491465339-9483-1-git-send-email-Yasunari.Takiguchi@sony.com>
        <201704071447.DmxQl53a%fengguang.wu@intel.com>
        <02699364973B424C83A42A84B04FDA8533BC79@JPYOKXMS113.jp.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 7 Apr 2017 08:19:58 +0000
"Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com> escreveu:

> Dear All
> 
> Our patches consists of the following items.
>   [PATCH 1/5] dt-bindings: media: Add document file for CXD2880 SPI I/F
>   [PATCH 2/5] media: Add support for CXD2880 SPI I/F
>   [PATCH 3/5] media: Add suppurt for CXD2880
>   [PATCH 4/5] media: Add suppurt for CXD2880 DVB-T2/T functions
>   [PATCH 5/5] media: Update MAINTAINERS file for CXD2880

Didn't review your patch series yet. It should take a while to
review 14K lines ;)

> It is necessary to apply all patches before compiling kernel with our code.
> 
> Could you re-compile after applying above the patches.

The kbuild test robot is... a machine. It won't read or answer to
your reply :-)

It automatically tests all patches sent to the ML and apply them at the 
order the patches are found at the tree, one by one.

The rule is that no patch can cause compilation breakages, as
this breaks Kernel bisectability.

So, you have to ensure, when sending a patch series, that every single
patch is compilable, and won't cause runtime issues.

In the specific case of this patch:

> > drivers/media/spi/Kconfig       |   14 +
> > drivers/media/spi/Makefile      |    5 +
> > drivers/media/spi/cxd2880-spi.c |  727 +++++++++++++++++++++++++++++++++++++++
> > 3 files changed, 746 insertions(+)
> > create mode 100644 drivers/media/spi/cxd2880-spi.c

If cxd2880-spi.c need something else in order to be built, you
should not add it at Kconfig/Makefile yet. Just add the files, 
using an order that makes it easier to be reviewed. In this
particular case, if it needs a header file, the patch containing
the header file should ideally be sent together with it
(or a previous patch, if adding it together wouldn't work).

Also, what I usually do when submitting drivers is that I don't
touch Kconfig/Makefile too early, putting such changes by the end
of the patch series.

E. g. you could break this patch on two separate patches, where the
first one would be just adding the cxd2880-spi.c (and cxd2880.h). Another
possibility would be to move this patch to the end, if the other patches
don't break git bisect (e. g. if they all compile without problems) and if
they're good enough to be reviewed by someone using the patch order.


Thanks,
Mauro
