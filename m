Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24160 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731832AbeIUDMn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 23:12:43 -0400
Date: Fri, 21 Sep 2018 00:26:30 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Sylwester Nawrocki <snawrocki@kernel.org>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RESEND PATCH 1/1] v4l: samsung, ov9650: Rely on V4L2-set
 sub-device names
Message-ID: <20180920212629.ag6igxtrzusdb5uc@kekkonen.localdomain>
References: <20180915225213.12946-1-sakari.ailus@linux.intel.com>
 <7d4b3c0e-5199-7283-ed21-ce063f7ed970@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <7d4b3c0e-5199-7283-ed21-ce063f7ed970@kernel.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Sep 20, 2018 at 11:01:26PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 09/16/2018 12:52 AM, Sakari Ailus wrote:
> > v4l2_i2c_subdev_init() sets the name of the sub-devices (as well as
> > entities) to what is fairly certainly known to be unique in the system,
> > even if there were more devices of the same kind.
> > 
> > These drivers (m5mols, noon010pc30, ov9650, s5c73m3, s5k4ecgx, s5k6aa) set
> > the name to the name of the driver or the module while omitting the
> > device's I²C address and bus, leaving the devices with a static name and
> > effectively limiting the number of such devices in a media device to 1.
> > 
> > Address this by using the name set by the V4L2 framework.
> > 
> > Signed-off-by: Sakari Ailus<sakari.ailus@linux.intel.com>
> > Reviewed-by: Akinobu Mita<akinobu.mita@gmail.com>  (ov9650)
> 
> I'm not against this patch but please don't expect an ack from me as this
> patch breaks existing user space code, scripts using media-ctl, etc. will 
> need to be updated after kernel upgrade. I'm mostly concerned about ov9650
> as other drivers are likely only used by Samsung or are obsoleted.

That is a fair point and also why I originally sent the patch out as RFC...

I checked that OV9650 is around 14 years (!) old now, so it's unlikely to
appear in modern hardware in dual configurations.

I think this patch thus probably causes more trouble than it has chances of
fixing anything. I'll submit one that adds a note that the convention is
not to be used in new drivers instead --- unless someone strongly feels
this patch really should be merged.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
