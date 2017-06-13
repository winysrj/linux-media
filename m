Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40610 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753245AbdFMPaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 11:30:04 -0400
Date: Tue, 13 Jun 2017 18:29:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Hsu, Cedric" <cedric.hsu@intel.com>
Subject: Re: [PATCH v10 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <20170613152928.GE12407@valkosipuli.retiisi.org.uk>
References: <1497315360-29216-1-git-send-email-hyungwoo.yang@intel.com>
 <1497315360-29216-2-git-send-email-hyungwoo.yang@intel.com>
 <20170613101745.GC12407@valkosipuli.retiisi.org.uk>
 <7A4F467111FEF64486F40DFE7DF3500A03EBA69F@ORSMSX111.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A4F467111FEF64486F40DFE7DF3500A03EBA69F@ORSMSX111.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyungwoo,

On Tue, Jun 13, 2017 at 02:29:25PM +0000, Yang, Hyungwoo wrote:
> 
> 
> Here is the _DSD for 19.2Mhz

If you attached it, the list server most likely removed the attachment.
Could you send it again in-line?

> 
> 
> 
> 
> 
> i've inlined my comments.
> 
> 
> 
> -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
> > Sent: Tuesday, June 13, 2017 3:18 AM
> > To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
> > Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>; tfiga@chromium.org; Hsu, Cedric <cedric.hsu@intel.com>
> > Subject: Re: [PATCH v10 1/1] [media] i2c: add support for OV13858 sensor
> > 
> > Hi Hyungwoo,
> > 
> > On Mon, Jun 12, 2017 at 05:56:00PM -0700, Hyungwoo Yang wrote:
...
> > > +	if (ret)
> > > +		return ret;
> > > +	ov13858->num_of_skip_frames = val;
> > > +
> > > +	device_for_each_child_node(dev, child) {
> > > +		if (!fwnode_property_present(child, "link"))
> > > +			continue;
> > 
> > You shouldn't need these here.
> > 
> 
> ?? just get child and see if the expected property is found ?
> Acked

Your child nodes shouldn't look like that, nor an individual driver should
need to be directly interested in them.

Please see Documentation/acpi/dsd/graph.txt .

> > > +		if (ret) {
> > > +			dev_err(dev, "link-rate error : %d\n",  ret);
> > > +			goto error;
> > > +		}
> > > +		link_freq_menu_items[freq_id] = val;
> > > +
> > > +		freq_cfg = &link_freq_configs[freq_id];
> > > +		ret = fwnode_property_read_u32(fwn_freq, "pixel-rate", &val);
> > 
> > This is something a sensor driver needs to know. It may not be present in device firmware.
> > 
> 
> Real frequency of the link can be different from input clock frequency so
> pixel reate which is dependent on link frequency should be here.

The pixel rate does depend on the link frequency, but you can either
calculate it in the driver OR make it specific your sensor configuration.

> 
> > > +		if (ret) {
> > > +			dev_err(dev, "pixel-rate error : %d\n",  ret);
> > > +			goto error;
> > > +		}
> > > +		freq_cfg->pixel_rate = val;
> > > +
> > > +		num_of_values = fwnode_property_read_u32_array(fwn_freq,
> > > +							       "pll-regs",
> > 
> > This is something that could go to device firmware but I don't really see a reason for that at the moment. Can this continue to be a part of the driver for now?
> > 
> > Could you also check that the external clock frequency matches with what your register lists assume? The property should be called "clock-frequency"
> > and it's a u32.
> 
> Are you saying, for now, let's remove pll reg/value pairs from _DSD  and
> just support only one input clock frequency ?

That would help getting the driver merged during this merge window. It's
always possible to add support for different configurations later on.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
