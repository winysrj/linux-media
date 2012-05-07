Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab2EGN2r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 09:28:47 -0400
Message-ID: <4FA7CE04.10004@redhat.com>
Date: Mon, 07 May 2012 15:28:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sander Eikelenboom <linux@eikelenboom.it>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [ 3960.758784] 1 lock held by motion/7776: [ 3960.758788]  #0:
  (&queue->mutex){......}, at: [<ffffffff815c62d2>] uvc_queue_enable+0x32/0xc0
References: <4410483770.20120428220246@eikelenboom.it> <21221178.20120506165440@eikelenboom.it> <1363463.HQ7LJLv1Qi@avalon> <201205071344.59861.hverkuil@xs4all.nl>
In-Reply-To: <201205071344.59861.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/07/2012 01:44 PM, Hans Verkuil wrote:
> On Monday 07 May 2012 13:06:01 Laurent Pinchart wrote:
>> Hi Sanser,
>>
>> On Sunday 06 May 2012 16:54:40 Sander Eikelenboom wrote:
>>> Hello Laurent / Mauro,
>>>
>>> I have updated to latest 3.4-rc5-tip, running multiple video grabbers.
>>> I don't see anything specific to uvcvideo anymore, but i do get the possible
>>> circular locking dependency below.
>>
>> Thanks for the report.
>>
>> We indeed have a serious issue there (CC'ing Hans Verkuil).
>>
>> Hans, serializing both ioctl handling an mmap with a single device lock as we
>> currently do in V4L2 is prone to AB-BA deadlocks (uvcvideo shouldn't be
>> affected as it has no device-wide lock).
>>
>> If we want to keep a device-wide lock we need to take it after the mm-
>>> mmap_sem lock in all code paths, as there's no way we can change the lock
>> ordering for mmap(). The copy_from_user/copy_to_user issue could be solved by
>> moving locking from v4l2_ioctl to __video_do_ioctl (device-wide locks would
>> then require using video_ioctl2), but I'm not sure whether that will play
>> nicely with the QBUF implementation in videobuf2 (which already includes a
>> workaround for this particular AB-BA deadlock issue).
>
> I've seen the same thing. It was on my TODO list of things to look into. I think
> mmap shouldn't take the device wide lock at all. But it will mean reviewing
> affected drivers before I can remove it.
>
> To be honest, I wasn't sure whether or not to take the device lock for mmap when
> I first wrote that code.
>
> If you look at irc I had a discussion today with HdG about adding flags to
> selectively disable locks for fops. It may be an idea to implement this soon so
> we can start updating drivers one-by-one.

I've a patch almost ready for this, when I'm happy with it I'll send of a new
version of the (ever growing) gspca use control framework patchset both me and
the other Hans have been working on, which will include this patch.

Regards,

Hans
