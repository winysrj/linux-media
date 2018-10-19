Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24068 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbeJSVE7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 17:04:59 -0400
Date: Fri, 19 Oct 2018 15:58:51 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] media: rename soc_camera I2C drivers
Message-ID: <20181019125851.kch2qxv6mjshwk76@kekkonen.localdomain>
References: <3e42194ffb936ec9d0a4d361f06c6a4b0e88173f.1539949382.git.mchehab+samsung@kernel.org>
 <fa7f6ef2-af25-a554-2ecc-e99c9fb1e68d@cisco.com>
 <20181019093146.195d0be5@coco.lan>
 <7bd0c2fd-f852-e880-f1ae-85f27b44fc9b@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd0c2fd-f852-e880-f1ae-85f27b44fc9b@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Mauro,

On Fri, Oct 19, 2018 at 02:39:27PM +0200, Hans Verkuil wrote:
> On 10/19/18 14:31, Mauro Carvalho Chehab wrote:
> > Em Fri, 19 Oct 2018 13:45:32 +0200
> > Hans Verkuil <hansverk@cisco.com> escreveu:
> > 
> >> On 10/19/18 13:43, Mauro Carvalho Chehab wrote:
> >>> Those drivers are part of the legacy SoC camera framework.
> >>> They're being converted to not use it, but sometimes we're
> >>> keeping both legacy any new driver.
> >>>
> >>> This time, for example, we have two drivers on media with
> >>> the same name: ov772x. That's bad.
> >>>
> >>> So, in order to prevent that to happen, let's prepend the SoC
> >>> legacy drivers with soc_.
> >>>
> >>> No functional changes.
> >>>
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>  
> >>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > For now, let's just avoid the conflict if one builds both modules and
> > do a modprobe ov772x.
> > 
> >> Let's kill all of these in the next kernel. I see no reason for keeping
> >> them around.
> > 
> > While people are doing those SoC conversions, I would keep it. We
> 
> Which people are doing SoC conversions? Nobody is using soc-camera anymore.
> It is a dead driver. The only reason it hasn't been removed yet is lack of
> time since it is not just removing the driver, but also patching old board
> files that use soc_camera headers. Really left-overs since the corresponding
> soc-camera drivers have long since been removed.
> 
> > could move it to staging, to let it clear that those drivers require
> > conversion, and give people some time to work on it.
> 
> There is nobody working on it. These are old sensors, and few will have
> the hardware to test it. If someone needs such a sensor driver, then they
> can always look at an older kernel version. It's still in git after all.
> 
> Just kill it rather then polluting the media tree.

I remember at least Jacopo has been doing some. There was someone else as
well, but I don't remember right now who it was. That said, I'm not sure if
there's anything happening to the rest.

Is there something that prevents removing these right away? As you said
it's not functional and people can always check old versions if they want
to port the driver to V4L2 sub-device framework.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
