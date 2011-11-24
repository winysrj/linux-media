Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1KXR6n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:58:43 -0500
Message-ID: <4ECE85CE.7040807@redhat.com>
Date: Thu, 24 Nov 2011 15:58:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <4ECE8434.5060106@linuxtv.org>
In-Reply-To: <4ECE8434.5060106@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 15:51, Andreas Oberritter escreveu:
> On 24.11.2011 18:44, Hans Verkuil wrote:
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
>>
>> And really remove them at some point in the future.
>>
>> But the important thing to realize is that the ABI hasn't changed (unless
>> I made a mistake somewhere).
> 
> So why don't you just leave the headers where they are and add a notice
> about the new V4L API as a comment?
> 
> What you proposed breaks compilation. If you add a warning, it breaks
> compilation for programs compiled with -Werror. Both are regressions.

I don't mind doing it for 3.3 kernel, and add a note at
Documentation/feature-removal-schedule.txt that the
headers will go away on 3.4. This should give distributions
and app developers enough time to prevent build failures, and
prepare for the upcoming changes.

Regards,
Mauro.

> 
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

