Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50134 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756962AbdCULjz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:39:55 -0400
Date: Tue, 21 Mar 2017 11:36:29 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170321113629.GW21222@n2100.armlinux.org.uk>
References: <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
 <179aca0a-deb5-7937-f955-26cc6d93afba@xs4all.nl>
 <20170320132930.GJ21222@n2100.armlinux.org.uk>
 <d0e2a9c2-5e94-d810-7ef4-ae089a6b25f5@xs4all.nl>
 <20170320141158.GK21222@n2100.armlinux.org.uk>
 <40e08d05-58cd-a295-3174-123147ee2ac5@xs4all.nl>
 <20170321104212.GC3784@bigcity.dyn.berto.se>
 <7fe51907-311d-e1cd-3e4c-dd3dc4af7d78@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe51907-311d-e1cd-3e4c-dd3dc4af7d78@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 21, 2017 at 11:59:02AM +0100, Hans Verkuil wrote:
> Ah, good to hear that -s works with MC. I was not sure about that.
> Thanks for the feedback!

Not soo good on iMX6:

$ v4l2-compliance -d /dev/video10 -s --expbuf-device=/dev/video0
...
Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
                fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
        test VIDIOC_G/S/ENUMINPUT: FAIL
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0
...
        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                fail: v4l2-test-controls.cpp(782): subscribe event for control 'User Controls' failed
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
...
Streaming ioctls:
        test read/write: OK (Not Supported)
                fail: v4l2-test-buffers.cpp(297): g_field() == V4L2_FIELD_ANY
                fail: v4l2-test-buffers.cpp(703): buf.check(q, last_seq)
                fail: v4l2-test-buffers.cpp(973): captureBufs(node, q, m2m_q, frame_count, false)
        test MMAP: FAIL
        test USERPTR: OK (Not Supported)
                fail: v4l2-test-buffers.cpp(1188): can_stream && ret != EINVAL
        test DMABUF: FAIL

(/dev/video0 being CODA).  CODA itself seems to have failures:

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                warn: v4l2-test-formats.cpp(1187): S_PARM is supported for buftype 2, but not ENUM_FRAMEINTERVALS
                warn: v4l2-test-formats.cpp(1194): S_PARM is supported but doesn't report V4L2_CAP_TIMEPERFRAME
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                fail: v4l2-test-formats.cpp(774): fmt_out.g_colorspace() != col
...
Streaming ioctls:
        test read/write: OK (Not Supported)
                fail: v4l2-test-buffers.cpp(956): q.create_bufs(node, 1, &fmt) != EINVAL
        test MMAP: FAIL
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
