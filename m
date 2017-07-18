Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34250 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752070AbdGRVq0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 17:46:26 -0400
Date: Wed, 19 Jul 2017 00:46:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required
 regulators can't be obtained
Message-ID: <20170718214622.eftjn6zz2fqo3khl@valkosipuli.retiisi.org.uk>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-5-sakari.ailus@linux.intel.com>
 <1652763.9EYemjAvaH@avalon>
 <20170718100352.GA28481@amd>
 <20170718101702.qi72355jjjuq7jjs@valkosipuli.retiisi.org.uk>
 <20170718210228.GA13046@amd>
 <20170718211640.qzplt2sx7gjlgqox@valkosipuli.retiisi.org.uk>
 <20170718212712.GA19771@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718212712.GA19771@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 18, 2017 at 11:27:12PM +0200, Pavel Machek wrote:
> Hi!

EHLO

> 
> > > No idea really. I only have N900 working with linux at the moment. I'm
> > > trying to get N9 and N950 working, but no luck so far.
> > 
> > Still no? :-(
> > 
> > Do you know if you get the kernel booting? Do you have access to the serial
> > console? I might have seen the e-mail chain but I lost the track. What
> > happens after the flasher has pushed the kernel to RAM and the boot starts?
> > It's wonderful for debugging if something's wrong...
> 
> Still no. No serial cable, unfortunately. Flasher seems to run the
> kernel, but I see no evidence new kernel started successfully. I was
> told display is not expected to work, and on USB I see bootloader
> disconnecting and that's it.
> 
> If you had a kernel binary that works for you, and does something I
> can observe, that would be welcome :-).

I put my .config I use for N9 here:

<URL:http://www.retiisi.org.uk/v4l2/tmp/config.n9>

The root filesystem is over NFS root with usbnet. You should see something
like this in dmesg:

[35792.056138] usb 2-2: new high-speed USB device number 58 using ehci-pci
[35792.206238] usb 2-2: New USB device found, idVendor=0525, idProduct=a4a1
[35792.206247] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[35792.206252] usb 2-2: Product: Ethernet Gadget
[35792.206257] usb 2-2: Manufacturer: Linux 4.13.0-rc1-00089-g4c341695f3b6 with musb-hdrc

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
