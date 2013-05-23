Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:47074 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3EWKZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:25:57 -0400
Received: by mail-vb0-f51.google.com with SMTP id x16so1983796vbf.24
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 03:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201305231223.12721.hverkuil@xs4all.nl>
References: <1363079692-16683-1-git-send-email-nsekhar@ti.com>
 <1368439554.1350.49.camel@x61.thuisdomein> <CA+V-a8vOJocJttwQBnNA-sn2qWtAvgzQ96OGNbJ8NvVV_tt7uA@mail.gmail.com>
 <201305231223.12721.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 15:55:36 +0530
Message-ID: <CA+V-a8uRM-CkEaYe2Mtibi6qV48jC26Jv3YUHQsCdYR=BNhCVQ@mail.gmail.com>
Subject: Re: [v3] media: davinci: kconfig: fix incorrect selects
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Bolle <pebolle@tiscali.nl>, Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, May 23, 2013 at 3:53 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon 13 May 2013 12:41:26 Prabhakar Lad wrote:
>> Hi Paul,
>>
>> On Mon, May 13, 2013 at 3:35 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > Prabhakar,
>> >
>> > On Mon, 2013-05-13 at 15:27 +0530, Prabhakar Lad wrote:
>> >> Good catch! the dependency can be dropped now.
>> >
>> > Great.
>> >
>> >> Are you planning to post a patch for it or shall I do it ?
>> >
>> > I don't mind submitting that trivial patch.
>> >
>> > However, it's probably better if you do that. I can only state that this
>> > dependency is now useless, because that is simply how the kconfig system
>> > works. But you can probably elaborate why it's OK to not replace it with
>> > another (negative) dependency. That would make a more informative commit
>> > explanation.
>> >
>> Posted the patch fixing it https://patchwork.linuxtv.org/patch/18395/
>
> Prabhakar,
>
> Is this for 3.10 or 3.11?
>
For 3.10 as a fix.

Regards,
--Prabhakar Lad
