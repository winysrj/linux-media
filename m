Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55559 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2AOSB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 13:01:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Aurel <aurel@gmx.de>
Subject: Re: White Balance Temperature
Date: Sun, 15 Jan 2012 19:01:30 +0100
Cc: linux-media@vger.kernel.org
References: <loom.20120115T110626-849@post.gmane.org>
In-Reply-To: <loom.20120115T110626-849@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201151901.31380.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Aurel,

On Sunday 15 January 2012 11:16:30 Aurel wrote:
> Hi there
> 
> my "Live! Cam Socialize HD VF0610", Device ID: 041e:4080, Driver: uvcvideo
> is running perfectly on Fedora 16 Linux, except one thing:
> When I try to switch on "White Balance Temperature, Auto" or just try to
> change "White Balance Temperature" slider I get a failure message and it
> won't work. All other controls, like contrast, gamma, etc. are working.
> "v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" produces an
> error message:
> "VIDIOC_S_CTRL: failed: Input/output error
> white_balance_temperature_auto: Input/output error"
> 
> As soon as I boot Windows (inside Linux out of a Virtual Box), start the
> camera there and go back to Linux, I am able to adjust and switch on the
> White Balance things in Linux.
> "v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" working fine
> after running the camera in Windows.
> 
> Everytime I switch off my computer or disconnect the camera, I have to run
> the camera in Windows again, bevor I can adjust White Balance in Linux.
> 
> What can I do to get White Balance controls working in Linux, without
> having to run the camera in Windows every time?
> Is there a special command I have to send to the camera for initializing or
> so?

Not that I know of. If you use the stock UVC driver in Windows, without having 
installed a custom driver for your device, that's quite unlikely.

Could you dump the value of all controls in Linux before and after booting 
Windows ?

-- 
Regards,

Laurent Pinchart
