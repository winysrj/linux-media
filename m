Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35583 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbcFUHRa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 03:17:30 -0400
Date: Tue, 21 Jun 2016 15:16:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Philip Li <philip.li@intel.com>
Subject: Re: ERROR: "bad_dma_ops" [sound/core/snd-pcm.ko] undefined!
Message-ID: <20160621071658.GA7025@wfg-t540p.sh.intel.com>
References: <201606191246.rRvhiD2z%fengguang.wu@intel.com>
 <5768E84E.9040400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5768E84E.9040400@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > config: m32r-allmodconfig (attached as .config)
> > compiler: m32r-linux-gcc (GCC) 4.9.0
> 
> You are using 4.9.0 ? If you want you can get 5.3.0 from:
> http://chat.vectorindia.net/crosstool/x86_64/5.3.0/m32r-linux.tar.xz

Glad to know that! Philip will help pull the new version.

Thanks,
Fengguang
