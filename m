Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3DLJbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 05:31:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Tzu-Jung Lee <roylee17@gmail.com>
Subject: Re: v4l2-ctl-streaming: ideas for improvements
Date: Fri, 12 Apr 2013 11:31:36 +0200
Message-ID: <2830033.Lm7S2aU9or@avalon>
In-Reply-To: <201304100927.07905.hverkuil@xs4all.nl>
References: <201304100927.07905.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 April 2013 09:27:07 Hans Verkuil wrote:
> Hi all,
> 
> Just in case someone has time to work on this: I thought I'd write down some
> of the ideas I have to improve the streaming code in v4l2-ctl:
> 
> 1) Add an option to select between limited and full range colors.
> 
> 2) Add more test patterns:
> 	- solid colors: black, white, red, green, blue, cyan, yellow, magenta.
> 	- grey 'color' bar
> 	- grey ramp
> 	- a pattern containing SAV and EAV codes in each plane (perhaps this
> 	  should be a separate option, 'overlaying' those codes): this is a very
> 	  nasty test case that can be used to test proper handling of such codes
> 	  in an image.
> 	- moving patterns
> 	- horizontal colorbars
> 	- thin lines: horizontal, vertical, both.
> 	- random contents

I've implemented support for generating test patterns in both my fbdev-test 
program (http://git.ideasonboard.org/fbdev-test.git) and in the libdrm 
modetest program. Maybe we should consider splitting that to a shared library.

> 3) For the capture side add pattern validation: check that the contents you
>    captured matches the given pattern. Very useful for testing.
> 
> 4) Add support for capturing/displaying frames with different sizes (e.g.
>    compressed streams). Currently the output just appends all planes/frames
>    together without writing the plane/frame sizes anywhere. The input
> assumes fixed sized planes/frames. We probably need to add a meta file that
> contains the 'bytesused' values. Perhaps that file should also contain
> format information that can be used later.
> 
> 5) Add some support to give keyboard commands when streaming. E.g. 'q' to
> stop streaming gracefully (and so also ensure that all the data is written
> to file, something that doesn't happen with ctrl-c).
> 
>    Other commands for the future are encoder/decoder commands such as
> speeding up or down.
> 
> 6) MPEG encoders can generate an index file (VIDIOC_G_ENC_INDEX). Add an
> option to generate that and to use it when decoding. I actually have some
> old test application that does just that, and that also has encoder/decoder
> command support (see item 5 above): http://ivtvdriver.org/svn/ivtvtv
> 
> 7) Add VBI streaming support. Split off the VBI code from qv4l2 into a
> library and use that in v4l2-ctl to slice the raw VBI and to interpret the
> data. That should replace the vbi-test.c, sliced-vbi-detect.c and
> sliced-vbi-test.c utilities in contrib.

-- 
Regards,

Laurent Pinchart

