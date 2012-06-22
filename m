Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43746 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761865Ab2FVJps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 05:45:48 -0400
Received: by obbuo13 with SMTP id uo13so1714928obb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 02:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206221128.25585.hverkuil@xs4all.nl>
References: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com>
 <201206221059.31976.hverkuil@xs4all.nl> <CA+V-a8s=zK+98Z3fSOY5YD990xMKTnHLywjhwQWZhd2tQKjppw@mail.gmail.com>
 <201206221128.25585.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 22 Jun 2012 15:15:27 +0530
Message-ID: <CA+V-a8sSJP1cOmQnzao5L7ygA+z8sxVtdu89xjrWY_7ZuzcvDg@mail.gmail.com>
Subject: Re: Recent patch for videobuf causing a crash to my driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jun 22, 2012 at 2:58 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri June 22 2012 11:11:36 Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Fri, Jun 22, 2012 at 2:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > On Fri June 22 2012 10:50:23 Laurent Pinchart wrote:
>> >> Hi Hans,
>> >>
>> >> On Friday 22 June 2012 09:50:44 Hans Verkuil wrote:
>> >> > On 22/06/12 05:39, Prabhakar Lad wrote:
>> >> > > Hi Federico,
>> >> > >
>> >> > > Recent patch from you (commit id a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4)
>> >> > > which added cached buffer support to videobuf dma contig, is causing my
>> >> > > driver to crash.
>> >> > > Has this patch being tested for 'uncached' buffers ? If I replace this
>> >> > > mapping logic with remap_pfn_range() my driver works without any crash.
>> >> > >
>> >> > > Or is that I am missing somewhere ?
>> >> >
>> >> > No, I had the same problem this week with vpif_capture. Since I was running
>> >> > an unusual setup (a 3.0 kernel with the media subsystem patched to 3.5-rc1)
>> >> > I didn't know whether it was caused by a mismatch between 3.0 and a 3.5
>> >> > media subsystem.
>> >> >
>> >> > I intended to investigate this next week, but now it is clear that it is
>> >> > this patch that is causing the problem.
>> >>
>> >> Time to port the driver to videobuf2 ? ;-)
>> >>
>> >>
>> >
>> > That's actually something on my todo list...
>>
>>  In fact I have ported VPIF to videobuf2, It works fine with MMAP based
>> buffers, Its crashing for USERPTR buffers. still need to fix it :(
>
> Can you post it? I'd like to take a look myself.

  Ok, I will clean it up and post it soon.

Thx,
--Prabhakar Lad

>
> Regards,
>
>        Hans
