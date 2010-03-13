Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53303 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab0CMOYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 09:24:00 -0500
Received: by bwz1 with SMTP id 1so1789020bwz.21
        for <linux-media@vger.kernel.org>; Sat, 13 Mar 2010 06:23:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9B31D5.5060603@redhat.com>
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com>
	 <201003122242.06508.hverkuil@xs4all.nl> <4B9B31D5.5060603@redhat.com>
Date: Sat, 13 Mar 2010 09:23:58 -0500
Message-ID: <829197381003130623w22133c4eyadff26301381f8ca@mail.gmail.com>
Subject: Re: Remaining drivers that aren't V4L2?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 13, 2010 at 1:33 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> usbvideo
>
> This actually is a framework for usb video devices a bit like
> gspca one could say. It supports the following devices:
>
> "USB 3com HomeConnect (aka vicam)"
> "USB IBM (Xirlink) C-it Camera"
> "USB Konica Webcam support"
> "USB Logitech Quickcam Messenger"
>
> Of which the Logitech Quickcam Messenger has a gspca subdriver
> now, and is scheduled for removal.

Now that I see the product list, I realize that I actually have a 3com
HomeConnect kicking around in a box.  So if nobody gets around to it,
I could probably kill a few hours and do the conversion (given that
was a fairly popular product at the time).

Or would it be better to convert the products to gpsca (I don't
actually know/understand if that's possible at this point)?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
