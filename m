Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43232 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbeIYDV2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 23:21:28 -0400
MIME-Version: 1.0
References: <20180912150142.157913-1-arnd@arndb.de> <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath> <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath> <20180918175952.GJ11367@ziepe.ca>
 <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com> <20180924203505.GC6008@ziepe.ca>
In-Reply-To: <20180924203505.GC6008@ziepe.ca>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 24 Sep 2018 23:17:01 +0200
Message-ID: <CAK8P3a1Bh9NnncbcT0X4fKWC7B0FnqYyEMUwB6MvmzaNO7VhFQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to generic_compat_ioctl_ptrarg
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Darren Hart <dvhart@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qat-linux@intel.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-iio@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-pci <linux-pci@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-fbdev@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 24, 2018 at 10:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Mon, Sep 24, 2018 at 10:18:52PM +0200, Arnd Bergmann wrote:
> > On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > > > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > We already do this inside of some subsystems, notably drivers/media/,
> > and it simplifies the implementation of the ioctl handler function
> > significantly. We obviously cannot do this in general, both because of
> > traditional drivers that have 16-bit command codes (drivers/tty and others)
> > and also because of drivers that by accident defined the commands
> > incorrectly and use the wrong type or the wrong direction in the
> > definition.
>
> That could work well, but the first idea could be done globally and
> mechanically, while this would require very careful per-driver
> investigation.
>
> Particularly if the core code has worse performance.. ie due to
> kmalloc calls or something.
>
> I think it would make more sense to start by having the core do the
> case to __user and then add another entry point to have the core do
> the copy_from_user, and so on.

Having six separate callback pointers to implement a single
system call seems a bit excessive though.

        Arnd
