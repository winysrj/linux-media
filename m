Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54601 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab0CLWYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 17:24:22 -0500
Received: by bwz1 with SMTP id 1so1480032bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 14:24:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9ABE3C.6010909@onid.orst.edu>
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com>
	 <201003122242.06508.hverkuil@xs4all.nl>
	 <4B9ABE3C.6010909@onid.orst.edu>
Date: Fri, 12 Mar 2010 17:24:20 -0500
Message-ID: <829197381003121424s2fde7d34m46b7641f33f78e85@mail.gmail.com>
Subject: Re: Remaining drivers that aren't V4L2?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Akey <akeym@onid.orst.edu>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 5:20 PM, Michael Akey <akeym@onid.orst.edu> wrote:
> Hans Verkuil wrote:
>> These drivers are still v4l1:
>>
>> arv
>> bw-qcam
>> c-qcam
>> cpia_pp
>> cpia_usb
>> ov511
>> se401
>> stradis
>> stv680
>> usbvideo
>> w9966
>>
>> Some of these have counterparts in gspca these days so possibly some
>> drivers
>> can be removed by now. Hans, can you point those out?
>>
>> arv, bw-qcam, c-qcam, cpia_pp and stradis can probably be moved to staging
>> and if no one steps up then they can be dropped altogether.
>>
>
> Does this mean that the bw-qcam driver will be removed in future revisions
> or does this mean it will just never be updated to v4l2?

Hans is suggesting that support for those devices would be dropped
entirely if no developer steps up to convert them to v4l2.

The problem is that supporting the long deprecated API is a burden
that makes it much harder to extend certain aspects of the internal
code.  If we were able to drop those devices, it would be much easier
to improve all the other drivers (of which the *vast* majority have
been converted to v4l2).

It's been over ten years since v4l2 came out.  If nobody has converted
those drivers to v4l2, then it's safe to say it's probably never going
to happen.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
