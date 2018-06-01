Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:44642 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbeFAJ4Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 05:56:16 -0400
Date: Fri, 1 Jun 2018 12:56:12 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Bing Bu Cao <bingbu.cao@linux.intel.com>
Cc: bingbu.cao@intel.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, tian.shu.qiu@intel.com,
        rajmohan.mani@intel.com, tfiga@chromium.org
Subject: Re: [RESEND PATCH V2 2/2] media: ak7375: Add ak7375 lens voice coil
 driver
Message-ID: <20180601095612.bip7m5bmwd24btke@paasikivi.fi.intel.com>
References: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
 <1527242135-22866-2-git-send-email-bingbu.cao@intel.com>
 <20180601093416.i5mnos5titb5ggiz@paasikivi.fi.intel.com>
 <a0f63669-db91-7174-1f88-761bff6af0d3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0f63669-db91-7174-1f88-761bff6af0d3@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 01, 2018 at 05:54:30PM +0800, Bing Bu Cao wrote:
> > > +AKM AK7375 LENS VOICE COIL DRIVER
> > > +M:	Tianshu Qiu <tian.shu.qiu@intel.com>
> > > +L:	linux-media@vger.kernel.org
> > > +T:	git git://linuxtv.org/media_tree.git
> > > +S:	Maintained
> > > +F:	drivers/media/i2c/ak7375.c
> > > +F:	Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt
> > The name of the file also needs to match. Currently it doesn't. How about
> > "asahi-kasei,ak7375.txt"?
> Ack.
> Does it make sense if just change the compatible string to
> "asahi-kasei,ak7375" and keep the file name unchanged?

Most binding files in the directory seem to use the chip name rather than
the full compatible string (including the vendor). I guess both are fine.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
