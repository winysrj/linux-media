Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59388 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab0DEC5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Apr 2010 22:57:40 -0400
Subject: Re: RFC: new V4L control framework
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004041741.51869.hverkuil@xs4all.nl>
References: <201004041741.51869.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 04 Apr 2010 22:58:02 -0400
Message-Id: <1270436282.12543.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-04-04 at 17:41 +0200, Hans Verkuil wrote:
> Hi all,
> 
> The support in drivers for the V4L2 control API is currently very chaotic.
> Few if any drivers support the API correctly. Especially the support for the
> new extended controls is very much hit and miss.
> 
> Combine that with the requirements for the upcoming embedded devices that
> will want to use controls much more actively and you end up with a big mess.
> 
> I've wanted to fix this for a long time and last week I finally had the time.
> 
> The new framework works like a charm and massively reduces the complexity in
> drivers when it comes to control handling. And just as importantly, any driver
> that uses it is fully compliant to the V4L spec. Something that application
> writers will appreciate.
> 
> I have converted the cx2341x.c module and tested it with ivtv since that is
> by far the most complex example of control handling. The new code is much,
> much cleaner.
> 
> The documentation is available here:
> 
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw/raw-file/9b6708e8293c/linux/Documentation/video4linux/v4l2-controls.txt

>From reading the Documentation.  Things look very much improved.

However:

"When a subdevice is registered with a bridge driver and the ctrl_handler
fields of both v4l2_subdev and v4l2_device are set, then the controls of the
subdev will become automatically available in the bridge driver as well. If
the subdev driver contains controls that already exist in the bridge driver,
then those will be skipped (so a bridge driver can always override a subdev
control)."

I think I have 2 cases where that is undesriable:

1. cx18 volume control: av_core subdev has a volume control (which the
bridge driver currently reports as it's volume control) and the cs5435
subdev has a volume control.

I'd really need them *both* to be controllable by the user.  I'd also
like them to appear as a single (bridge driver) volume control to the
user - as that is what a user would expect.


2. ivtv volume control for an AverTV M113 card.  The CX2584x chip is
normally the volume control.  However, due to some poor baseband audio
noise performance on this card, it is advantagous to adjust the volume
control on the WM8739 subdev that feeds I2S audio into the CX2584x chip.
Here, I would like a secondary volume control, not an override of the
primary.

(Here's my old hack:
	http://linuxtv.org/hg/~awalls/ivtv-avertv-m113/rev/c8f2378a3119 )


Maybe there's a way to use the control clusters to handle some of this.
I'm a bit too tired to figure it all out at the moment.

Regards,
Andy

