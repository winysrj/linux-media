Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:50476 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab1KXRvv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:51:51 -0500
Message-ID: <4ECE8434.5060106@linuxtv.org>
Date: Thu, 24 Nov 2011 18:51:48 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl>
In-Reply-To: <201111241844.23292.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.11.2011 18:44, Hans Verkuil wrote:
> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>> Don't break existing Userspace APIs for no reason! It's OK to add the
>> new API, but - pretty please - don't just blindly remove audio.h and
>> video.h. They are in use since many years by av7110, out-of-tree drivers
>> *and more importantly* by applications. Yes, I know, you'd like to see
>> those out-of-tree drivers merged, but it isn't possible for many
>> reasons. And even if they were merged, you'd say "Port them and your
>> apps to V4L". No! That's not an option.
> 
> I'm not breaking anything. All apps will still work.
> 
> One option (and it depends on whether people like it or not) is to have
> audio.h, video.h and osd.h just include av7110.h and add a #warning
> that these headers need to be replaced by the new av7110.h.
> 
> And really remove them at some point in the future.
> 
> But the important thing to realize is that the ABI hasn't changed (unless
> I made a mistake somewhere).

So why don't you just leave the headers where they are and add a notice
about the new V4L API as a comment?

What you proposed breaks compilation. If you add a warning, it breaks
compilation for programs compiled with -Werror. Both are regressions.

Regards,
Andreas
