Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39152 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GOMNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 08:13:22 -0400
Received: by ghrr11 with SMTP id r11so4456966ghr.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jul 2012 05:13:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207151243.25241.hverkuil@xs4all.nl>
References: <CALzAhNXPhRv18GPJ5OzZOxCY7o=PsfT4g_tkXWBTapyDvsZXtw@mail.gmail.com>
	<201207151243.25241.hverkuil@xs4all.nl>
Date: Sun, 15 Jul 2012 08:13:21 -0400
Message-ID: <CALzAhNVGgiZA2xr6+uHXAbOVhUJU4VPipO8o92=m9NFS6z4NjA@mail.gmail.com>
Subject: Re: Tips is OOPSing with basic v4l2 controls - Major breakage
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 15, 2012 at 6:43 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sun July 15 2012 01:12:02 Steven Toth wrote:
>> Tip is oopsing the moment the V4L2 API is exercised, Eg. v4l2-ctl or tvtime.
>>
>> Its unusable at this point.
>
> It's fixed here:
>
> https://patchwork.kernel.org/patch/1168931/
>
> We're all waiting for Mauro to return from vacation :-)

Thanks Hans. :)

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
