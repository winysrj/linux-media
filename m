Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:14702 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab0KIM2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 07:28:37 -0500
Subject: RE: Format of /dev/video0 data for HVR-4000 frame grabber
From: Andy Walls <awalls@md.metrocast.net>
To: Michael PARKER <michael.parker@st.com>
Cc: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB0B5@SAFEX1MAIL1.st.com>
References: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB088@SAFEX1MAIL1.st.com>
	 <20101109091024.GA15043@minime.bse>
	 <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB0B5@SAFEX1MAIL1.st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 07:28:32 -0500
Message-ID: <1289305712.2075.12.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2010-11-09 at 10:34 +0100, Michael PARKER wrote:
> Daniel,
> 
> Many thanks for your mail. Please excuse the naivety of my questions -
> I'm a h/w guy and a nube to the s/w world.


> Do you know which of these is the default format or how to determine
> the format I'm seeing coming out of /dev/video0? 

$ v4l2-ctl -d /dev/video0 --list-formats
$ v4l2-ctl -d /dev/video0 --get-fmt-video
$ v4l2-ctl --help

> Do you have a suggestion for how data captured from /dev/video0 can be
> converted into a recognisable image format (JPEG, GIF, PNG etc.)?
> 
> I'm keen, if possible, to grab the single frame image using just
> command line tools and without recourse to ioctls, compiled code etc.

v4l2-ctl can set up the device.  As you and Daniel mentioned, dd can
read off a frame given the proper parameters.


> Also, how do I synchronise dd to the beginning of a new frame (and
> thus avoid capturing sections of two frames)?

When dd open()s the device and does a read() it should start a capture.
When dd close()s the device and exits, it should stop the capture.  I'm
fairly certain stopping and restarting a capture should resynchronize
things, but I'm not sure.  The overhead of stopping and starting a
capture may cause you some noticeable delays, but again, I'm not sure.

I think the answer is to write some code and use the Streaming I/O
ioctl()s interface to get frame based data. I know you were hoping to
avoid that.

Regards,
Andy

> Thanks again,
> 
> Mike


