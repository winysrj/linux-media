Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33587 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbbINHR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 03:17:26 -0400
Received: by wiclk2 with SMTP id lk2so127728373wic.0
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2015 00:17:25 -0700 (PDT)
Subject: Re: Time for a v4l-utils 1.8.0 release
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <55491541.1040709@googlemail.com>
 <20150505172235.4bef50eb@recife.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <55F67483.4030709@googlemail.com>
Date: Mon, 14 Sep 2015 09:17:23 +0200
MIME-Version: 1.0
In-Reply-To: <20150505172235.4bef50eb@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 05/05/15 22:22, Mauro Carvalho Chehab wrote:
> Em Tue, 05 May 2015 21:08:49 +0200
> Gregor Jasny <gjasny@googlemail.com> escreveu:
>
>> Hello,
>>
>> It's already more than half a year since the last v4l-utils release. Do
>> you have any pending commits or objections? If no one vetos I'd like to
>> release this weekend.
>
> There is are a additions I'd like to add to v4l-utils:
>
> 1) on DVB, ioctls may fail with -EAGAIN. Some parts of the libdvbv5 don't
> handle it well. I made one quick hack for it, but didn't have time to
> add a timeout to avoid an endless loop. The patch is simple. I just need
> some time to do that;
>
> 2) The Media Controller control util (media-ctl) doesn't support DVB.
>
> The patchset adding DVB support on media-ctl is ready, and I'm merging
> right now, and matches what's there at Kernel version 4.1-rc1 and upper.
>
> Yet, Laurent and Sakari want to do some changes at the Kernel API, before
> setting it into a stone at Kernel v 4.1 release.
>
> This has to happen on the next 4 weeks.
>
> So, I suggest to postpone the release of 1.8.0 until the end of this month.

I'd like to release v4l-utils 1.8.0 during the upcoming weekend. Please 
postpone any disruptive fixes until the release has been tagged.

Thanks,
Gregor
