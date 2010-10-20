Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4113 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0JTICk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 04:02:40 -0400
Message-ID: <3a9bc7b5a90b780d693ee4e4e02a9325.squirrel@webmail.xs4all.nl>
In-Reply-To: <004901cb702a$10a69100$31f3b300$%szyprowski@samsung.com>
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
    <201010200914.32868.hverkuil@xs4all.nl>
    <004901cb702a$10a69100$31f3b300$%szyprowski@samsung.com>
Date: Wed, 20 Oct 2010 10:02:21 +0200
Subject: RE: [PATCH/RFC v3 0/7] Videobuf2 framework
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Marek Szyprowski" <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com, mchehab@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hello,
>
> On Wednesday, October 20, 2010 9:15 AM wrote:
>
>> On Wednesday, October 20, 2010 08:41:06 Marek Szyprowski wrote:
>> > Hello,
>> >
>> > As I promissed I continue the development of the VideoBuf2 at Samsung
>> > until Pawel finds some spare time to help us. This is a third version
>> of
>> > the framework. Besides the minor bugfixes here and there I've added a
>> > complete read() callback emulator. This emulator provides 2 types of
>> > read() operation - 'streaming' and 'one shot'. It is suitable to
>> replace
>> > both videobuf_read_stream() and videobuf_read_one() methods from the
>> old
>> > videobuf.
>>
>> One thing I never understood: what is the point of supporting 'one shot'
>> read
>> mode? Why not support just streaming? Does anyone know?
>
> I can imagine that some simple cameras that capture pure JPG frames might
> want
> to use 'one shot' mode. This enables easier scripting and things like
> 'cat /dev/video >capture.jpg' working. If you think that 'one shot' mode
> should
> be removed - let me know.

I did a grep for videobuf_read_one in the sources and the only ones that
use it are bttv, saa7134, zr364xx, cx88 and cx23885. AFAIK zr364xx is the
only webcam driver in this set.

Mauro, do you know if there are any guidelines on what drivers are
supposed to use? Right now it seems random as to what drivers use.

The only constant I see is that vbi and compressed video (e.g. mpeg)
streaming is always using read_stream. Raw video seems to depend purely on
what the driver developer chose.

>> Another question: how hard is it to support write mode as well? I think
>> vb2 should support both. I suspect that once we have a read emulator it
>> isn't
>> difficult to make a write emulator too.
>
> Well, that's possible. If you really think that write() emulator is also
> required, I can implement both. This shouldn't be much work.

If it is not much work, then we should do that. The reason write wasn't
present before is simply that few drivers supported output streaming. But
that is changing these days so write support would definitely be a good
idea.

Regards,

        Hans


>> A last remark: the locking has changed recently in videobuf due to the
>> work
>> done on eliminating the BKL.  It's probably a good idea to incorporate
>> those
>> changes as well in vb2.
>
> Yes, I noticed that there are a lot of changes in for-2.6.37 staging tree,
> I
> will try to get through them and update relevant parts of vb2. The current
> version the vb2 patches is based on 2.6.36-rc8. Kernel tree with vb2
> patches
> (and the required multiplane patches) will be available in a few hours on:
>
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/v4l/vb2
>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

