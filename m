Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1KXSJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:09:04 -0500
Message-ID: <4ECE8839.8040606@redhat.com>
Date: Thu, 24 Nov 2011 16:08:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com>
In-Reply-To: <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 16:01, Manu Abraham escreveu:
> On Thu, Nov 24, 2011 at 11:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>>> Don't break existing Userspace APIs for no reason! It's OK to add the
>>> new API, but - pretty please - don't just blindly remove audio.h and
>>> video.h. They are in use since many years by av7110, out-of-tree drivers
>>> *and more importantly* by applications. Yes, I know, you'd like to see
>>> those out-of-tree drivers merged, but it isn't possible for many
>>> reasons. And even if they were merged, you'd say "Port them and your
>>> apps to V4L". No! That's not an option.
>>
>> I'm not breaking anything. All apps will still work.
>>
>> One option (and it depends on whether people like it or not) is to have
>> audio.h, video.h and osd.h just include av7110.h and add a #warning
>> that these headers need to be replaced by the new av7110.h.
> 
> 
> That won't work with other non av7110 hardware.

There isn't any non-av7110 driver using it at the Kernel. Anyway, we can put
a warning at the existing headers as-is, for now, putting them to be removed
for a new kernel version, like 3.4.

Regards,
Mauro

