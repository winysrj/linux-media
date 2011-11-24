Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56655 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1KXSCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:02:00 -0500
Received: by eaak14 with SMTP id k14so330682eaa.19
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 10:01:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201111241844.23292.hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
	<dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com>
	<4ECE79F5.9000402@linuxtv.org>
	<201111241844.23292.hverkuil@xs4all.nl>
Date: Thu, 24 Nov 2011 23:31:58 +0530
Message-ID: <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 24, 2011 at 11:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
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


That won't work with other non av7110 hardware.
