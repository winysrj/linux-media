Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:53351 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbeJPTkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 15:40:39 -0400
Date: Tue, 16 Oct 2018 14:50:21 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        bingbu.cao@linux.intel.com,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Subject: Re: [PATCH v7] media: add imx319 camera sensor driver
Message-ID: <20181016115020.6ptv7mzuwukeeus7@mara.localdomain>
References: <1537929738-27745-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5Cv1r_d01ZM2z4wwyGNtrgXnfVivGXxqoVO5eiCQhPauQ@mail.gmail.com>
 <20181012075839.76xr3gu4jkpyf3yb@paasikivi.fi.intel.com>
 <CAAFQd5DbPEWSU0Q3okdx1hDwgPya2NEPNmraTK-O2OR8KuRFXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DbPEWSU0Q3okdx1hDwgPya2NEPNmraTK-O2OR8KuRFXg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Fri, Oct 12, 2018 at 05:06:56PM +0900, Tomasz Figa wrote:
> On Fri, Oct 12, 2018 at 4:58 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> >
> > Hi Tomasz,
> >
> > On Fri, Oct 12, 2018 at 01:51:10PM +0900, Tomasz Figa wrote:
> > > Hi Sakari,
> > >
> > > On Wed, Sep 26, 2018 at 11:38 AM <bingbu.cao@intel.com> wrote:
> > > >
> > > > From: Bingbu Cao <bingbu.cao@intel.com>
> > > >
> > > > Add a v4l2 sub-device driver for the Sony imx319 image sensor.
> > > > This is a camera sensor using the i2c bus for control and the
> > > > csi-2 bus for data.
> > > >
> > > > This driver supports following features:
> > > > - manual exposure and analog/digital gain control support
> > > > - vblank/hblank control support
> > > > -  4 test patterns control support
> > > > - vflip/hflip control support (will impact the output bayer order)
> > > > - support following resolutions:
> > > >     - 3264x2448, 3280x2464 @ 30fps
> > > >     - 1936x1096, 1920x1080 @ 60fps
> > > >     - 1640x1232, 1640x922, 1296x736, 1280x720 @ 120fps
> > > > - support 4 bayer orders output (via change v/hflip)
> > > >     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
> > > >
> > > > Cc: Tomasz Figa <tfiga@chromium.org>
> > > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> > > > Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> > > >
> > > > ---
> > > >
> > > > This patch is based on sakari's media-tree git:
> > > > https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-1
> > > >
> > > > Changes from v5:
> > > >  - add some comments for gain calculation
> > > >  - use lock to protect the format
> > > >  - fix some style issues
> > > >
> > > > Changes from v4 to v5:
> > > >  - use single PLL for all internal clocks
> > > >  - change link frequency to 482.4MHz
> > > >  - adjust frame timing for 2x2 binning modes
> > > >    and enlarge frame readout time
> > > >  - get CSI-2 link frequencies and external clock
> > > >    from firmware
> > >
> > > If I remember correctly, that was suggested by you. Why do we need to
> > > specify link frequency in firmware if it's fully configured by the
> > > driver, with the only external dependency being the external clock?
> >
> > The driver that's now in upstream supports, for now, a very limited set of
> > configurations from what the sensor supports. These are more or less
> > tailored to the particular system where it is being used right now (output
> > image size, external clock frequency, frame rates, link frequencies etc.).
> 
> As a side note, they're tailored to exactly the system I mentioned,
> with different link frequency hardcoded in the firmware, coming from
> earlier stage of development.
> 
> > If the same sensor is needed elsewhere (quite likely), the configuration
> > needed elsewhere is very likely to be different from what you're using now.
> >
> > The link frequency in particular is important as using a different link
> > frequency (which could be fine elsewhere) could cause EMI issues, e.g.
> > rendering your GPS receiver inoperable during the time the camera sensor is
> > streaming images.
> >
> > Should new configurations be added to this driver to support a different
> > system, the link frequencies used by those configurations may be
> > problematic to your system, and after a software update the driver could as
> > well use those new frequencies. That's a big no-no.
> >
> 
> Okay, those are some valid points indeed, thanks for clarifying.
> 
> > >
> > > We're having problems with firmware listing the link frequency from v4
> > > and we can't easily change it anymore to report the new one. I feel
> > > like this dependency on the firmware here is unnecessary, as long as
> > > the external clock frequency matches.
> >
> > This is information you really need to know.
> >
> > A number of older drivers do not use the link frequency information from
> > the firmware but that comes with a risk. Really, it's better to change the
> > frequency now to something you can choose, rather than have it changed
> > later on to something someone else chose for you.
> 
> I guess it means that we have to carry a local downstream patch that
> bypasses this check, since we cannot easily change the firmware
> anymore.

Is there a possibility update the firmware, or carry an SSDT overlay as part
of the software? The options are laid out in
Documentation/acpi/ssdt-overlays.txt . Do remember to pay attention to the
revision field --- also in future Coreboot updates.

> 
> An alternative would be to make the driver try to select a frequency
> that matches what's in the firmware, but issue a warning and fall back
> to a default one if a matching is not found. It might be actually
> better than nothing for some early testing on new systems, since it
> wouldn't require firmware changes.

You don't need firmware changes per se; see above. Allowing that will very,
very easily lead this being unaddressed during developement and changing
later on inadvertly.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
