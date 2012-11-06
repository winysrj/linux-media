Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35153 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751870Ab2KFVv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 16:51:59 -0500
Date: Tue, 6 Nov 2012 23:51:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
Message-ID: <20121106215153.GE25623@valkosipuli.retiisi.org.uk>
References: <5097DF9F.6080603@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5097DF9F.6080603@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Mon, Nov 05, 2012 at 04:47:43PM +0100, Andreas Nagel wrote:
> Hello,
> 
> in order to familiarize myself with Media Controller and V4L2 I am
> creating a small example program for capturing some frames through
> the OMAP3 ISP.
> The hardware used is a TAO-3530 on a Tsunami daughterboard from
> Technexion. My video source is a standard DVD player connected to
> the daughterboards S-VIDEO port. That port itself is wired to a
> TVP5146 decoder chip from TI.
> A precompiled Android image with a demo app proofs, that the
> hardware is working fine.
> 
> My example program is mostly based on the following wiki page and
> the capture example in the V4L2 documentation.
> http://processors.wiki.ti.com/index.php/Writing_V4L2_Media_Controller_Applications_on_Dm36x_Video_Capture
> 
> My code sets up the ISP pipeline, configures the format on all the
> subdevices pads and the actual video device. Works fine so far.
> Then I passed user pointers (aquired with malloc) to the device
> driver for the capture buffers. Before issuing VIDIOC_STREAMON, I
> enqueue my buffers with VIDIOC_QBUF, which fails with errno = EIO. I
> don't know, why this is happening or where to got from here.

One possibility could be that mapping the buffer to ISP MMU fails for a
reason or another. Do you set the length field in the buffer?

> When using memory-mapped buffers instead, mapping the addresses to
> userspace works fine as well as VIDIOC_QBUF calls. But then
> VIDIOC_STREAMON fails with EINVAL. According to V4L documentation,
> EINVAL means
> a) buffertype (V4L2_BUF_TYPE_VIDEO_CAPTURE in this case) not supported
> b) no buffers have been allocated (memory mapping)
> c) or enqueued yet
> 
> Because I tested V4L2_CAP_VIDEO_CAPTURE capability, I guess option
> a) does not apply. Buffers have been enqueud, so c) doesn't apply
> either.
> What about b) ? As I chose memory-mapped buffers here, the device
> drivers manages the buffers. How can I make sure, that buffers were
> actually allocated?
> 
> And am I missing something else?

The formats on the pads at different ends of the links in the pipeline must
match. In most cases, they have to be exactly the same.

Have you used the media-ctl test program here?

<URL:http://git.ideasonboard.org/media-ctl.git>

media-ctl -p gives you (and us) lots of information that helps figuring out
what could go wrong here.

> I attached my example code. If you need more information, I will provide it.
> 
> Note: I have to use the Technexion 2.6.37 kernel, which is based on
> the TI kernel. It's the only kernel that comes with the ISP driver
> and Media Controller API onboard and I guess, TI or TN included this
> stuff somehow. Normally, this shouldn't be available until 2.6.39.
> Sadly, I cannot use another kernel, because Technexion doesn't push
> board support anywhere.

This might work but I think it'd be best if you could just use the mainline
kernel. Others are mostly unsupported.

Cc Laurent.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
