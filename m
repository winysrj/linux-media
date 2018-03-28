Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:31332 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbeC1DOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 23:14:42 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>
Subject: RE: [PATCH v4 00/12] Intel IPU3 ImgU patchset
Date: Wed, 28 Mar 2018 03:14:40 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A597303587A@FMSMSX114.amr.corp.intel.com>
References: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
        <6F87890CF0F5204F892DEA1EF0D77A5972FD4195@FMSMSX114.amr.corp.intel.com>
 <20171220115744.591a12e2@vento.lan>   
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding Tomasz...

> -----Original Message-----
> From: Mani, Rajmohan
> Sent: Tuesday, February 20, 2018 5:56 PM
> To: 'Mauro Carvalho Chehab' <mchehab@s-opensource.com>
> Cc: Zhi, Yong <yong.zhi@intel.com>; 'linux-media@vger.kernel.org' <linux-
> media@vger.kernel.org>; 'sakari.ailus@linux.intel.com'
> <sakari.ailus@linux.intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>;
> Toivonen, Tuukka <tuukka.toivonen@intel.com>; Hu, Jerry W
> <jerry.w.hu@intel.com>; 'arnd@arndb.de' <arnd@arndb.de>; 'hch@lst.de'
> <hch@lst.de>; 'robin.murphy@arm.com' <robin.murphy@arm.com>;
> 'iommu@lists.linux-foundation.org' <iommu@lists.linux-foundation.org>
> Subject: RE: [PATCH v4 00/12] Intel IPU3 ImgU patchset
> 
> Hi Mauro,
> 
> > > > Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
> > > >
> > > > Hi,
> > > >
> > > > Em Fri, 17 Nov 2017 02:58:56 +0000 "Mani, Rajmohan"
> > > > <rajmohan.mani@intel.com> escreveu:
> > > >
> > > > > Here is an update on the IPU3 documentation that we are
> > > > > currently working
> > > > on.
> > > > >
> > > > > Image processing in IPU3 relies on the following.
> > > > >
> > > > > 1) HW configuration to enable ISP and
> > > > > 2) setting customer specific 3A Tuning / Algorithm Parameters to
> > > > > achieve
> > > > desired image quality.
> > > > >
> > > > > We intend to provide documentation on ImgU driver programming
> > > > > interface
> > > > to help users of this driver to configure and enable ISP HW to
> > > > meet their needs.  This documentation will include details on
> > > > complete
> > > > V4L2 Kernel driver interface and IO-Control parameters, except for
> > > > the ISP internal algorithm and its parameters (which is Intel proprietary
> IP).
> > > >
> > > > Sakari asked me to take a look on this thread, specifically on
> > > > this email. I took a look on the other e-mails from this thread
> > > > that are discussing about this IP block.
> > > >
> > > > I understand that Intel wants to keep their internal 3A algorithm
> > > > protected, just like other vendors protect their own algos. It was
> > > > never a requirement to open whatever algorithm are used inside a
> > > > hardware (or firmware). The only requirement is that firmwares
> > > > should be licensed with redistribution permission, ideally merged
> > > > at linux-firmware
> > > git tree.
> > > >
> > > > Yet, what I don't understand is why Intel also wants to also
> > > > protect the interface for such 3A hardware/firmware algorithm. The
> > > > parameters that are passed from an userspace application to Intel
> > > > ISP logic doesn't contain the algorithm itself. What's the issue
> > > > of documenting the meaning of each parameter?
> > > >
> > >
> > > Thanks for looking into this.
> > >
> > > To achieve improved image quality using IPU3, 3A (Auto White
> > > balance, Auto Focus and Auto Exposure) Tuning parameters specific to
> > > a given camera sensor module, are converted to Intel ISP algorithm
> > > parameters in user space camera HAL using AIC (Automatic ISP
> Configuration) library.
> > >
> > > As a unique design of Intel ISP, it exposes very detailed algorithm
> > > parameters (~ 10000 parameters) to configure ISP's image processing
> > > algorithm per each image fame in runtime. Typical Camera SW
> > > developers (including those at
> > > Intel) are not expected to fully understand and directly set these
> > > parameters to configure the ISP algorithm blocks. Due to the above,
> > > a user space AIC library (in binary form) is provided to generate
> > > ISP Algorithm specific parameters, for a given set of 3A tuning
> > > parameters. It significantly reduces the efforts of SW development
> > > in ISP HW
> > configuration.
> > >
> > > On the other hand, the ISP algorithm details could be deduced
> > > readily through these detailed parameters by other ISP experts outside
> Intel.
> > > This is the reason that we want to keep these parameter definitions
> > > as Intel
> > proprietary IP.
> > >
> > > We are fully aware of your concerns on how to enable open source
> > > developers to use Intel ISP through up-streamed Kernel Driver.
> > > Internally, we are working on the license for this AIC library
> > > release now (as Hans said NDA license is not acceptable). We believe
> > > this will be more efficient way to help open source developers.
> > >
> > > This AIC library release would be a binary-only release. This AIC
> > > library does not use any kernel uAPIs directly. The user space
> > > Camera HAL that uses kernel uAPIs is available at
> > > https://chromium.googlesource.com/chromiumos/platform/arc-
> > > camera/+/master
> > >
> 
> The AIC library (in binary form) is available here.
> https://storage.googleapis.com/chromeos-localmirror/distfiles/intel-3a-libs-
> bin-2017.09.27.tbz2
> 
> Licensing information can be found in ./LICENSE.intel_3a_library file after
> unzipping the tar file.
> 
> >
> > Just pinging to know your thoughts on this.
> >
> > Thanks
> > Raj
