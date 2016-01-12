Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56627 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbcALQMW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 11:12:22 -0500
Date: Tue, 12 Jan 2016 17:12:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Daniel Johnson <teknotus@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
In-Reply-To: <CA+nDE0hdhrFfeVU_OsO847ehMdLtj7bjbC6E4an0s963jjXKTg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1601121707540.2083@axis700.grange>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
 <Pine.LNX.4.64.1601091126170.15612@axis700.grange>
 <CA+nDE0hdhrFfeVU_OsO847ehMdLtj7bjbC6E4an0s963jjXKTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Mon, 11 Jan 2016, Daniel Johnson wrote:

> On Sat, Jan 9, 2016 at 2:27 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Mauro,
> >
> > Ping - what about this patch? If there are no comments - would you like me
> > to push it via my tree?
> 
> In testing the V4L2_PIX_FMT_Z16 ('Z16 ') format documentation seems to
> be incomplete.
> 
> uvc_xu_control_query unit=2 selector=4 seems to be a z scale factor.
> Changing the value of that control greatly changes the value of
> pixels. Millimeters seems to be correct for the default value of that
> control. This control is on the /dev node for the infrared camera
> rather than the node using the Z16 depth format.

Thanks for your comments. Let me point out though, that the purpose of 
those patches isn't a complete programmers guide of those RealSense 
cameras, rather giving minimum boot-up info. Providing more information 
would require significantly more work.

Thanks
Guennadi

> The one thing that every depth camera I've ever used has in common is
> factory calibration. Translating pixel values to Z is only 1/3 of what
> is needed to translate a depth image into a point cloud. The
> calibration is needed to translate X and Y pixel indexes into
> positions in 3d space. Documentation on fetching, and parsing the
> factory calibration would make the camera much more usable.
> 
> Documentation on the 21 UVC controls would be helpful, but less
> critical than the calibration data.
> 
