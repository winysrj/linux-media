Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48238 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752192AbdCSSFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 14:05:54 -0400
Date: Sun, 19 Mar 2017 18:04:57 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com, hverkuil@xs4all.nl,
        pavel@ucw.cz, robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170319180457.GX21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 19, 2017 at 10:54:22AM -0700, Steve Longerbeam wrote:
> 
> 
> On 03/19/2017 03:38 AM, Russell King - ARM Linux wrote:
> >On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
> >>Right, imx-media-capture.c (the "standard" v4l2 user interface module)
> >>is not implementing VIDIOC_ENUM_FRAMESIZES. It should, but it can only
> >>return the single frame size that the pipeline has configured (the mbus
> >>format of the attached source pad).
> >I now have a set of patches that enumerate the frame sizes and intervals
> >from the source pad of the first subdev (since you're setting the formats
> >etc there from the capture device, it seems sensible to return what it
> >can support.)  This means my patch set doesn't add to non-CSI subdevs.
> >
> >>Can you share your gstreamer pipeline? For now, until
> >>VIDIOC_ENUM_FRAMESIZES is implemented, try a pipeline that
> >>does not attempt to specify a frame rate. I use the attached
> >>script for testing, which works for me.
> >Note that I'm not specifying a frame rate on gstreamer - I'm setting
> >the pipeline up for 60fps, but gstreamer in its wisdom is unable to
> >enumerate the frame sizes, and therefore is unable to enumerate the
> >frame intervals (frame intervals depend on frame sizes), so it
> >falls back to the "tvnorms" which are basically 25/1 and 30000/1001.
> >
> >It sees 60fps via G_PARM, and then decides to set 30000/1001 via S_PARM.
> >So, we end up with most of the pipeline operating at 60fps, with CSI
> >doing frame skipping to reduce the frame rate to 30fps.
> >
> >gstreamer doesn't complain, doesn't issue any warnings, the only way
> >you can spot this is to enable debugging and look through the copious
> >debug log, or use -v and check the pad capabilities.
> >
> >Testing using gstreamer, and only using "does it produce video" is a
> >good simple test, but it's just that - it's a simple test.  It doesn't
> >tell you that what you're seeing is what you intended to see (such as
> >video at the frame rate you expected) without more work.
> >
> >>Thanks, I've fixed most of v4l2-compliance issues, but this is not
> >>done yet. Is that something you can help with?
> >What did you do with:
> >
> >ioctl(3, VIDIOC_REQBUFS, {count=0, type=0 /* V4L2_BUF_TYPE_??? */, memory=0 /* V4L2_MEMORY_??? */}) = -1 EINVAL (Invalid argument)
> >                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> >ioctl(3, VIDIOC_EXPBUF, 0xbef405bc)     = -1 EINVAL (Invalid argument)
> >                 fail: v4l2-test-buffers.cpp(571): q.has_expbuf(node)
> >                 test VIDIOC_EXPBUF: FAIL
> >
> >To me, this looks like a bug in v4l2-compliance (I'm using 1.10.0).
> >I'm not sure what buffer VIDIOC_EXPBUF is expected to export, since
> >afaics no buffers have been allocated, so of course it's going to fail.
> >Either that, or the v4l2 core vb2 code is non-compliant with v4l2's
> >interface requirements.
> >
> >In any case, it doesn't look like the buffer management is being
> >tested at all by v4l2-compliance - we know that gstreamer works, so
> >buffers _can_ be allocated, and I've also used dmabufs with gstreamer,
> >so I also know that VIDIOC_EXPBUF works there.
> >
> 
> I wouldn't be surprised if you hit on a bug in v4l2-compliance. I stopped
> with v4l2-compliance
> at a different test failure that also didn't make sense to me:

It isn't - the problem is that the results are misleading.  The
VIDIOC_REQBUFS depends on the GET_FMT test succeeding, so it knows
which buffer formats are valid.

Since the GET_FMT test fails due to the colorspace issue, it decides
that it can't trust the format, so it ends up with no formats to test.
This causes the "VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF" test to pass,
but then it moves on to testing "VIDIOC_EXPBUF" with no available
buffers, which then fails.

Fixing GET_FMT (which I've done locally) to return proper colorspace
information results in GET_FMT passing, and also solves the EXPBUF
problem too.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
