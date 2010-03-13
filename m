Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4449 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab0CMKDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 05:03:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Remaining drivers that aren't V4L2?
Date: Sat, 13 Mar 2010 11:03:50 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com> <201003122242.06508.hverkuil@xs4all.nl> <4B9B31D5.5060603@redhat.com>
In-Reply-To: <4B9B31D5.5060603@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003131103.50333.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 13 March 2010 07:33:57 Hans de Goede wrote:
> > To my knowledge the usbvideo driver is probably the least obscure device
> > that is still using V4L1.
> 
> I think you are confusing the usbvideo driver with the v4l2 usbvision
> driver, which indeed gets used a lot in usb tv devices.

You are correct. I confused those two. Sorry about that.

> 
> I think it is ok to drop v4l1 support from tvtime.

I agree.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
