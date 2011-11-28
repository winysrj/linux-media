Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37929 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1K1Kfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 05:35:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex <alex.vizor@gmail.com>
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2: -32 (exp. 2).
Date: Mon, 28 Nov 2011 11:35:57 +0100
Cc: linux-media@vger.kernel.org
References: <4ED29713.1010202@gmail.com>
In-Reply-To: <4ED29713.1010202@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281135.57435.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On Sunday 27 November 2011 21:01:23 Alex wrote:
> Hi guys,
> 
> I'm using kernel 3.2-rc3 and get following in dmesg on every try to use
> thinkpad integrated camera (here I did rmmod and modprobe before test):
> [ 9481.258170] usbcore: deregistering interface driver uvcvideo
> [ 9481.296659] uvcvideo: Failed to submit URB 0 (-28).
> [ 9481.296677] uvcvideo 1-1.6:1.1: resume error -28
> [ 9490.117546] uvcvideo: Found UVC 1.00 device Integrated Camera
> (04f2:b221) [ 9490.119166] input: Integrated Camera as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input13
> [ 9490.119298] usbcore: registered new interface driver uvcvideo
> [ 9490.119302] USB Video Class driver (1.1.1)
> [ 9498.101683] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
> unit 2: -32 (exp. 2).
> [ 9498.113603] uvcvideo: Failed to submit URB 0 (-28).

Those two errors might be unrelated.

For the second one, I'm tempted to blame 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-
stable.git;a=commit;h=f0cc710a6dec5b808a6f13f1f8853c094fce5f12. Could you 
please try reverting it, and see if it fixes your issue ? If so, let's report 
that to the linux-usb mailing list.

For the first one, could you please send me the lsusb -v output for your 
webcam ?

-- 
Regards,

Laurent Pinchart
