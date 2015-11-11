Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33379 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbKKVaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 16:30:16 -0500
Received: by obbww6 with SMTP id ww6so32078232obb.0
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2015 13:30:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446489100.15819.15.camel@collabora.com>
References: <1394578325-11298-1-git-send-email-sheu@google.com>
 <1394578325-11298-5-git-send-email-sheu@google.com> <06c801cf526f$7b0498a0$710dc9e0$%debski@samsung.com>
 <5343D4BD.4090809@samsung.com> <1446489100.15819.15.camel@collabora.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Wed, 11 Nov 2015 22:29:56 +0100
Message-ID: <CAH-u=82JZ0S6+5KcEuVjTD4roM0PGWGNccjiUzu_aRes2gyjZw@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP buffers
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	John Sheu <sheu@google.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	posciak@google.com, arun.m@samsung.com, kgene.kim@samsung.com,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2015-11-02 19:31 GMT+01:00 Nicolas Dufresne <nicolas.dufresne@collabora.com>:
> Le mardi 08 avril 2014 à 12:51 +0200, Marek Szyprowski a écrit :
>> Hello,
>>
>> On 2014-04-07 16:41, Kamil Debski wrote:
>> > Pawel, Marek,
>> >
>> > Before taking this to my tree I wanted to get an ACK from one of
>> > the
>> > videobuf2 maintainers. Could you spare a moment to look through
>> > this
>> > patch?
>>
>> It's not a bug, it is a feature. This was one of the fundamental
>> design
>> requirements to allow applications to track if the memory is used or
>> not.
>
> I still have the impression it is not fully correct for the case
> buffers are exported using DMABUF. Like if the dmabuf was owning the
> vb2 buffer instead of the opposite ...

I am observing this behaviour too... Tried it, but seems to not do the
job on dmabuf buffers... with gstreamer at least ;-).

JM
