Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56187 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbbLDX1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2015 18:27:38 -0500
In-Reply-To: <1755984.kluJNdl6XT@avalon>
References: <1449266748-22317-1-git-send-email-laurent.pinchart@ideasonboard.com> <6E4D785C-6536-400C-8665-DC42B97E9265@xs4all.nl> <1755984.kluJNdl6XT@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] vivid: Add support for the dma-contig memory allocator
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 05 Dec 2015 00:27:32 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Message-ID: <B8540E50-45B3-48B0-9268-CFA0CE6F6ABC@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On December 5, 2015 12:02:11 AM GMT+01:00, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>Hi Hans,
>
>On Friday 04 December 2015 23:50:31 Hans Verkuil wrote:
>> On December 4, 2015 11:05:48 PM GMT+01:00, Laurent Pinchart wrote:
>> > To test buffer sharing with devices that require contiguous memory
>> > buffers the dma-contig allocator is required. Support it and make
>the
>> > allocator selectable through a module parameter. Support for the
>two
>> > memory allocators can also be individually selected at compile-time
>to
>> > avoid bloating the kernel with an unneeded allocator.
>> >
>> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> >---
>> >
>> > drivers/media/platform/vivid/Kconfig         | 21 ++++++++++++-
>> > drivers/media/platform/vivid/vivid-core.c    | 44
>++++++++++++++++++++----
>> > drivers/media/platform/vivid/vivid-core.h    |  1 +
>> > drivers/media/platform/vivid/vivid-sdr-cap.c |  3 ++
>> > drivers/media/platform/vivid/vivid-vbi-cap.c |  2 ++
>> > drivers/media/platform/vivid/vivid-vbi-out.c |  1 +
>> > drivers/media/platform/vivid/vivid-vid-cap.c |  9 ++----
>> > drivers/media/platform/vivid/vivid-vid-out.c |  9 ++----
>> > 8 files changed, 72 insertions(+), 18 deletions(-)
>
>[snip]
>
>> Apologies for top posting, I'm sending this from my Android phone.
>
>No need to, your message was at the bottom :-)
>
>> Laurent, did you test this on a regular pc? I've tried this before,
>but
>> failed since I couldn't make it work on a pc. I didn't spend a huge
>amount
>> of time on it, though.
>> 
>> Just want to make sure that this case is covered.
>
>I haven't tested that, no. Let's see who from you or me will find free
>time 
>first (hint: it might be you :-)).

This http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=vivid-alloc is my previous attempt. 

I'll likely find time to test your version, but  I won't accept it if it doesn't work on a pc. Unless there is a good explanation for why it doesn't work. But in that case it shouldn't be enabled unless it really works. 

Regards, 

Hans 
