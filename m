Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935670Ab0CMTnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 14:43:55 -0500
Message-ID: <4B9BEB3A.3010801@redhat.com>
Date: Sat, 13 Mar 2010 20:44:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Remaining drivers that aren't V4L2?
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com>	 <201003122242.06508.hverkuil@xs4all.nl> <4B9B31D5.5060603@redhat.com> <829197381003130623w22133c4eyadff26301381f8ca@mail.gmail.com>
In-Reply-To: <829197381003130623w22133c4eyadff26301381f8ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/13/2010 03:23 PM, Devin Heitmueller wrote:
> On Sat, Mar 13, 2010 at 1:33 AM, Hans de Goede<hdegoede@redhat.com>  wrote:
>>> usbvideo
>>
>> This actually is a framework for usb video devices a bit like
>> gspca one could say. It supports the following devices:
>>
>> "USB 3com HomeConnect (aka vicam)"
>> "USB IBM (Xirlink) C-it Camera"
>> "USB Konica Webcam support"
>> "USB Logitech Quickcam Messenger"
>>
>> Of which the Logitech Quickcam Messenger has a gspca subdriver
>> now, and is scheduled for removal.
>
> Now that I see the product list, I realize that I actually have a 3com
> HomeConnect kicking around in a box.  So if nobody gets around to it,
> I could probably kill a few hours and do the conversion (given that
> was a fairly popular product at the time).
>
> Or would it be better to convert the products to gpsca (I don't
> actually know/understand if that's possible at this point)?
>

It would be much better to change it into a gspca subdriver, gspca is
a generic framework for usb webcams, and as such has a lot of code
which all these devices need shared in place, making the subdrivers
quite small, and nice to write as you can focus on the actual
camera specifics instead of on things like getting locking in case of
hot unplug while an app is streaming right.

Regards,

Hans
