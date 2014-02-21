Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm35.bullet.mail.ne1.yahoo.com ([98.138.229.28]:31921 "EHLO
	nm35.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbaBUOw1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 09:52:27 -0500
References: <1392924626.38711.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5307208B.8030908@redhat.com>
Message-ID: <1392994175.4964.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Fri, 21 Feb 2014 06:49:35 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PWC webcam and setpwc tool no longer working with 3.12.11 kernel
To: Hans de Goede <hdegoede@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5307208B.8030908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, 21 February 2014, 9:47, Hans de Goede <hdegoede@redhat.com> wrote:

> This is likely caused by the camera being plugged into a usb-bus which already is used
> by other reserved-bandwidth devices such as mice, keyboard, usb soundcards, etc.

> If possible USB-3 ports are preferred over USB-2 ports or connecting through an USB-2
> hub. USB-2's USB-1 emulation has some issues, which means we cannot use full USB-1 bandwidth
> there.

Hi,

Yes, it turns out that every device plugged into one of the USB2 ports on the back of this PC ends up on the same USB2 hub. Moving the PWC device to one of the USB3 ports instead allows it to work, although it seems like a shocking waste of a USB3 port - this being an old USB1 webcam!

And v4l2-ctl seem to recognise it as well:

$ v4l2-ctl --info
Driver Info (not using libv4l2):
    Driver name   : pwc
    Card type     : Logitech QuickCam Zoom
    Bus info      : usb-0000:05:00.0-2
    Driver version: 3.12.11
    Capabilities  : 0x85000001
        Video Capture
        Read/Write
        Streaming
        Device Capabilities
    Device Caps   : 0x05000001
        Video Capture
        Read/Write
        Streaming

Cheers,
Chris

