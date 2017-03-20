Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48330 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753574AbdCTNFd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 09:05:33 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <179aca0a-deb5-7937-f955-26cc6d93afba@xs4all.nl>
Date: Mon, 20 Mar 2017 14:01:58 +0100
MIME-Version: 1.0
In-Reply-To: <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2017 06:54 PM, Steve Longerbeam wrote:
> 
> 
> On 03/19/2017 03:38 AM, Russell King - ARM Linux wrote:
>> On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
>>> Right, imx-media-capture.c (the "standard" v4l2 user interface module)
>>> is not implementing VIDIOC_ENUM_FRAMESIZES. It should, but it can only
>>> return the single frame size that the pipeline has configured (the mbus
>>> format of the attached source pad).
>> I now have a set of patches that enumerate the frame sizes and intervals
>> from the source pad of the first subdev (since you're setting the formats
>> etc there from the capture device, it seems sensible to return what it
>> can support.)  This means my patch set doesn't add to non-CSI subdevs.
>>
>>> Can you share your gstreamer pipeline? For now, until
>>> VIDIOC_ENUM_FRAMESIZES is implemented, try a pipeline that
>>> does not attempt to specify a frame rate. I use the attached
>>> script for testing, which works for me.
>> Note that I'm not specifying a frame rate on gstreamer - I'm setting
>> the pipeline up for 60fps, but gstreamer in its wisdom is unable to
>> enumerate the frame sizes, and therefore is unable to enumerate the
>> frame intervals (frame intervals depend on frame sizes), so it
>> falls back to the "tvnorms" which are basically 25/1 and 30000/1001.
>>
>> It sees 60fps via G_PARM, and then decides to set 30000/1001 via S_PARM.
>> So, we end up with most of the pipeline operating at 60fps, with CSI
>> doing frame skipping to reduce the frame rate to 30fps.
>>
>> gstreamer doesn't complain, doesn't issue any warnings, the only way
>> you can spot this is to enable debugging and look through the copious
>> debug log, or use -v and check the pad capabilities.
>>
>> Testing using gstreamer, and only using "does it produce video" is a
>> good simple test, but it's just that - it's a simple test.  It doesn't
>> tell you that what you're seeing is what you intended to see (such as
>> video at the frame rate you expected) without more work.
>>
>>> Thanks, I've fixed most of v4l2-compliance issues, but this is not
>>> done yet. Is that something you can help with?
>> What did you do with:
>>
>> ioctl(3, VIDIOC_REQBUFS, {count=0, type=0 /* V4L2_BUF_TYPE_??? */, memory=0 /* V4L2_MEMORY_??? */}) = -1 EINVAL (Invalid argument)
>>                  test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>> ioctl(3, VIDIOC_EXPBUF, 0xbef405bc)     = -1 EINVAL (Invalid argument)
>>                  fail: v4l2-test-buffers.cpp(571): q.has_expbuf(node)

This is really a knock-on effect from an earlier issue where the compliance test
didn't detect support for MEMORY_MMAP.

>>                  test VIDIOC_EXPBUF: FAIL
>>
>> To me, this looks like a bug in v4l2-compliance (I'm using 1.10.0).

Always build from the master repo. 1.10 is pretty old.

>> I'm not sure what buffer VIDIOC_EXPBUF is expected to export, since
>> afaics no buffers have been allocated, so of course it's going to fail.

It just tests if EXPBUF is supported.

I think I will modify v4l2-compliance to bail out if it doesn't find support
for MEMORY_MMAP. Even though in theory support for this is optional, in practice
all applications expect that it is supported. That should fix this
hard-to-understand error.

>> Either that, or the v4l2 core vb2 code is non-compliant with v4l2's
>> interface requirements.
>>
>> In any case, it doesn't look like the buffer management is being
>> tested at all by v4l2-compliance - we know that gstreamer works, so
>> buffers _can_ be allocated, and I've also used dmabufs with gstreamer,
>> so I also know that VIDIOC_EXPBUF works there.

To test actual streaming you need to provide the -s option.

Note: v4l2-compliance has been developed for 'regular' video devices,
not MC devices. It may or may not work with the -s option.

As I think I mentioned somewhere else, creating a compliance test for
MC devices would help enormously in verifying drivers. I'm not sure if
it is better to create a new test or integrate it in v4l2-compliance.

I'm leaning towards the latter since there is a lot of overlap.

>>
> 
> I wouldn't be surprised if you hit on a bug in v4l2-compliance. I 
> stopped with v4l2-compliance
> at a different test failure that also didn't make sense to me:
> 
> Streaming ioctls:
>      test read/write: OK (Not Supported)
>          Video Capture:
>          Buffer: 0 Sequence: 0 Field: Any Timestamp: 41.664259s
>          fail: 
> .../v4l-utils-1.6.2/utils/v4l2-compliance/v4l2-test-buffers.cpp(281): 
> !(g_flags() & (V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR))
>          fail: 
> .../v4l-utils-1.6.2/utils/v4l2-compliance/v4l2-test-buffers.cpp(610): 
> buf.check(q, last_seq)
>          fail: 
> .../v4l-utils-1.6.2/utils/v4l2-compliance/v4l2-test-buffers.cpp(883): 
> captureBufs(node, q, m2m_q, frame_count, false)
>      test MMAP: FAIL
>      test USERPTR: OK (Not Supported)
>      test DMABUF: Cannot test, specify --expbuf-device
> 
> Total: 42, Succeeded: 38, Failed: 4, Warnings: 0
> 
> 
> In this case the driver completed and returned only one buffer, and it set
> VB2_BUF_STATE_DONE, so these test failures didn't make sense to me. I
> was using version 1.6.2 at the time.

I can't do anything with that. Always use the master branch in the v4l-utils
repo.

Regards,

	Hans
