Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.plextek.co.uk ([62.254.222.163]:16387 "EHLO
	mailgate.plextek.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2BGOCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 09:02:47 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Setting routing of v4l2 subdevice
Date: Tue, 7 Feb 2012 13:49:53 -0000
Message-ID: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D0638DC3B@plextek3.plextek.lan>
From: "Adam Sutton" <adam.sutton@plextek.com>
To: <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to get the camera working on our Android platform and I'm
having some trouble understanding how to select the appropriate input.

The platform specifics are:

Analog camera (PAL-I) -> TVP5150 TV decoder -> iMX53 IPU/CSI

Note: The TVP driver is not the one currently in the mainline kernel,
I've had to modify it back to the old int-device format to be compatible
with the Freescale IPU/CSI drivers. 

The TVP chip has 2 analog inputs which can be selected over the I2C
interface. The driver includes a V4L2 ioctl
(vidioc_int_s_video_routing_num) for selecting the required one.

My question is how do I go about accessing this from userland. The
closest thing I can see if the VIDIOC_S_INPUT ioctl, but this get picked
up by the freescale CSI driver (mxc_v4l2_capture.c), which also has 2
possible input paths to select between (although we only ever use 1). I
had initially hacked this ioctl in the freescale driver to pass the call
to the TVP driver, but this doesn't feel right and I'm sure there must
be a better way to handle this.

Any suggestions welcome,
Adam
Plextek Limited
Registered Address: London Road, Great Chesterford, Essex, CB10 1NY, UK Company Registration No. 2305889
VAT Registration No. GB 918 4425 15
Tel: +44 1799 533 200. Fax: +44 1799 533 201 Web:http://www.plextek.com 
Electronics Design and Consultancy

