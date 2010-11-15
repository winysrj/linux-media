Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4791 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab0KOJuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 04:50:17 -0500
Message-ID: <342eb735192f26a4a84488cad7f01068.squirrel@webmail.xs4all.nl>
In-Reply-To: <201011151017.41453.arnd@arndb.de>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
    <201011142253.29768.arnd@arndb.de>
    <201011142348.51859.hverkuil@xs4all.nl>
    <201011151017.41453.arnd@arndb.de>
Date: Mon, 15 Nov 2010 10:49:57 +0100
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> On Sunday 14 November 2010 23:48:51 Hans Verkuil wrote:
>> On Sunday, November 14, 2010 22:53:29 Arnd Bergmann wrote:
>> > On Sunday 14 November 2010, Hans Verkuil wrote:
>> > > This patch series converts 24 v4l drivers to unlocked_ioctl. These
>> are low
>> > > hanging fruit but you have to start somewhere :-)
>> > >
>> > > The first patch replaces mutex_lock in the V4L2 core by
>> mutex_lock_interruptible
>> > > for most fops.
>> >
>> > The patches all look good as far as I can tell, but I suppose the
>> title is
>> > obsolete now that the BKL has been replaced with a v4l-wide mutex,
>> which
>> > is what you are removing in the series.
>>
>> I guess I have to rename it, even though strictly speaking the branch
>> I'm
>> working in doesn't have your patch merged yet.
>>
>> BTW, replacing the BKL with a static mutex is rather scary: the BKL
>> gives up
>> the lock whenever you sleep, the mutex doesn't. Since sleeping is very
>> common
>> in V4L (calling VIDIOC_DQBUF will typically sleep while waiting for a
>> new frame
>> to arrive), this will make it impossible for another process to access
>> any
>> v4l2 device node while the ioctl is sleeping.
>>
>> I am not sure whether that is what you intended. Or am I missing
>> something?
>
> I was aware that something like this could happen, but I apparently
> misjudged how big the impact is. The general pattern for ioctls is that
> those that get called frequently do not sleep, so it can almost always be
> called with a mutex held.

True in general, but most definitely not true for V4L. The all important
VIDIOC_DQBUF ioctl will almost always sleep.

Mauro, I think this patch will have to be reverted and we just have to do
the hard work ourselves.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

