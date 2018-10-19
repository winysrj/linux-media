Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42114 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbeJTE1F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 00:27:05 -0400
Date: Fri, 19 Oct 2018 23:19:21 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Akinobu Mita <akinobu.mita@gmail.com>, petrcvekcz@gmail.com
Subject: Re: [PATCH] media: rename soc_camera I2C drivers
Message-ID: <20181019201920.6sdqpnxsgjpgtaa2@kekkonen.localdomain>
References: <3e42194ffb936ec9d0a4d361f06c6a4b0e88173f.1539949382.git.mchehab+samsung@kernel.org>
 <fa7f6ef2-af25-a554-2ecc-e99c9fb1e68d@cisco.com>
 <20181019093146.195d0be5@coco.lan>
 <7bd0c2fd-f852-e880-f1ae-85f27b44fc9b@cisco.com>
 <20181019125851.kch2qxv6mjshwk76@kekkonen.localdomain>
 <20181019131328.GG11703@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181019131328.GG11703@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Fri, Oct 19, 2018 at 03:13:28PM +0200, jacopo mondi wrote:
> Hi Mauro, Hans, Sakari,
> 
> On Fri, Oct 19, 2018 at 03:58:51PM +0300, Sakari Ailus wrote:
> > Hi Hans, Mauro,
> >
> > On Fri, Oct 19, 2018 at 02:39:27PM +0200, Hans Verkuil wrote:
> > > On 10/19/18 14:31, Mauro Carvalho Chehab wrote:
> > > > Em Fri, 19 Oct 2018 13:45:32 +0200
> > > > Hans Verkuil <hansverk@cisco.com> escreveu:
> > > >
> > > >> On 10/19/18 13:43, Mauro Carvalho Chehab wrote:
> > > >>> Those drivers are part of the legacy SoC camera framework.
> > > >>> They're being converted to not use it, but sometimes we're
> > > >>> keeping both legacy any new driver.
> > > >>>
> > > >>> This time, for example, we have two drivers on media with
> > > >>> the same name: ov772x. That's bad.
> > > >>>
> > > >>> So, in order to prevent that to happen, let's prepend the SoC
> > > >>> legacy drivers with soc_.
> > > >>>
> > > >>> No functional changes.
> > > >>>
> > > >>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > >>
> > > >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > >
> > > > For now, let's just avoid the conflict if one builds both modules and
> > > > do a modprobe ov772x.
> > > >
> > > >> Let's kill all of these in the next kernel. I see no reason for keeping
> > > >> them around.
> > > >
> > > > While people are doing those SoC conversions, I would keep it. We
> > >
> > > Which people are doing SoC conversions? Nobody is using soc-camera anymore.
> > > It is a dead driver. The only reason it hasn't been removed yet is lack of
> > > time since it is not just removing the driver, but also patching old board
> > > files that use soc_camera headers. Really left-overs since the corresponding
> > > soc-camera drivers have long since been removed.
> > >
> > > > could move it to staging, to let it clear that those drivers require
> > > > conversion, and give people some time to work on it.
> > >
> > > There is nobody working on it. These are old sensors, and few will have
> > > the hardware to test it. If someone needs such a sensor driver, then they
> > > can always look at an older kernel version. It's still in git after all.
> > >
> > > Just kill it rather then polluting the media tree.
> >
> > I remember at least Jacopo has been doing some. There was someone else as
> > well, but I don't remember right now who it was. That said, I'm not sure if
> > there's anything happening to the rest.
> 
> Yes, I did port a few drivers and there are patches for others coming.
> 
> [PATCH v2 0/4] media: soc_camera: ov9640: switch driver to v4l2_async
> from Peter Cvek (now in Cc)
> >
> > Is there something that prevents removing these right away? As you said
> > it's not functional and people can always check old versions if they want
> > to port the driver to V4L2 sub-device framework.
> 
> All dependencies should have been solved so far, but given that
> someone might want to do the porting at some point, I don't see how
> bad would it be to have them in staging, even if people could look
> into the git history...

The atomisp driver was removed on similar basis --- it was not functional
and no-one was actively working on it. And there was lots of work to keep
the codebase compiling (not as much the case with these drivers though).
I think that decision regarding atomisp was a correct one, and I don't see
much difference between that and these drivers.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
