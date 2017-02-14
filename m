Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35158 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbdBNU7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 15:59:12 -0500
Received: by mail-oi0-f42.google.com with SMTP id j15so77530031oih.2
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2017 12:59:11 -0800 (PST)
MIME-Version: 1.0
From: Martin Herrman <martin.herrman@gmail.com>
Date: Tue, 14 Feb 2017 21:59:10 +0100
Message-ID: <CADR1r6hbvri8qMYP2S7Pe9sxGsjh5iE2zWTUybYwcoRsbpgXFA@mail.gmail.com>
Subject: Cine CT V6.1 code change request
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

I have a Cine CT V6.1 in my fedora 25 based media center. It is now
running a default fedora 4.9 kernel. I install the driver as follows:

hg clone https://linuxtv.org/hg/~endriss/media_build_experimental
cd media_build_experimental
make download
make untar
make menuconfig
make
make install

However, I have to make two changes to the source to make it work.

Change 1: in media_build_experimental/v4l/Kconfig line 6936 I have to
remove the whitespace in '--- help ---', otherwise make menuconfig
fails.
Change 2: during compilation the following error occurs (since about
kernel 4.5?):

make -C /lib/modules/4.9.7-201.fc25.x86_64/build
SUBDIRS=/home/htpc/Downloads/media_build_experimental/v4l  modules
make[2]: Entering directory '/usr/src/kernels/4.9.7-201.fc25.x86_64'
  CC [M]  /home/htpc/Downloads/media_build_experimental/v4l/tuner-xc2028.o
In file included from <command-line>:0:0:
/home/htpc/Downloads/media_build_experimental/v4l/compat.h:1463:1:
error: redefinition of 'pci_zalloc_consistent'
 pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
 ^~~~~~~~~~~~~~~~~~~~~
In file included from ./include/linux/pci.h:2145:0,
                 from
/home/htpc/Downloads/media_build_experimental/v4l/compat.h:1459,
                 from <command-line>:0:
./include/linux/pci-dma-compat.h:23:1: note: previous definition of
'pci_zalloc_consistent' was here
 pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
 ^~~~~~~~~~~~~~~~~~~~~
In file included from <command-line>:0:0:
/home/htpc/Downloads/media_build_experimental/v4l/compat.h:1552:0:
warning: "DMA_ATTR_SKIP_CPU_SYNC" redefined
 #define DMA_ATTR_SKIP_CPU_SYNC 0

In file included from ./include/linux/pci-dma-compat.h:7:0,
                 from ./include/linux/pci.h:2145,
                 from
/home/htpc/Downloads/media_build_experimental/v4l/compat.h:1459,
                 from <command-line>:0:
./include/linux/dma-mapping.h:47:0: note: this is the location of the
previous definition
 #define DMA_ATTR_SKIP_CPU_SYNC  (1UL << 5)

scripts/Makefile.build:299: recipe for target
'/home/htpc/Downloads/media_build_experimental/v4l/tuner-xc2028.o'
failed
make[3]: *** [/home/htpc/Downloads/media_build_experimental/v4l/tuner-xc2028.o]
Error 1
Makefile:1494: recipe for target
'_module_/home/htpc/Downloads/media_build_experimental/v4l' failed
make[2]: *** [_module_/home/htpc/Downloads/media_build_experimental/v4l] Error 2
make[2]: Leaving directory '/usr/src/kernels/4.9.7-201.fc25.x86_64'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/htpc/Downloads/media_build_experimental/v4l'
Makefile:28: recipe for target 'all' failed
make: *** [all] Error 2

Which I fix by commenting out lines 1462 up to 1468 in
media_build_experimental/v4l/compat.h:

//static inline void *
//pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
// dma_addr_t *dma_handle)
//{
// return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
// size, dma_handle, GFP_ATOMIC | __GFP_ZERO);
//}

Now it compiles and works fine. I still get these warnings:

media_build_experimental/v4l/compat.h:1552:0: warning:
"DMA_ATTR_SKIP_CPU_SYNC" redefined
 #define DMA_ATTR_SKIP_CPU_SYNC 0

Which I can easily remove by commenting out the specific line as well.

Now my questions are:
- is this the correct way to fix these compile errors? (I'm definately
not a professional developer)
- what can I do to have this solved in the source?

Besides that, I'm also wondering if these drivers have any change of
getting into kernel mainline?

Regards,

Martin
