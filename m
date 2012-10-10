Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42153 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2JJPWC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:22:02 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so393692bkc.19
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2012 08:22:01 -0700 (PDT)
Message-ID: <507592A9.4010400@googlemail.com>
Date: Wed, 10 Oct 2012 17:22:17 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] qv4l2: avoid empty titles for the video control tabs
References: <1349793964-22825-1-git-send-email-fschaefer.oss@googlemail.com> <201210091724.56456.hverkuil@xs4all.nl>
In-Reply-To: <201210091724.56456.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.10.2012 17:24, schrieb Hans Verkuil:
> On Tue October 9 2012 16:46:04 Frank Schäfer wrote:
>> The video control class names are used as titles for the GUI-tabs.
>> The current code relies on the driver enumerating the control classes
>> properly when using V4L2_CTRL_FLAG_NEXT_CTRL.
>> But the UVC-driver (and likely others, too) don't do that, so we can end
>> up with an empty class name string.
>>
>> Make sure we always have a control class title:
>> If the driver didn't enumrate a class along with the controls, call
>> VIDIOC_QUERYCTRL for the class explicitly.
>> If that fails, fall back to an internal string list.
> NACK.
>
> qv4l2 is for testing drivers, so I *want* to see if a driver doesn't provide
> the control class name. They really should provide it, and it is not something
> that should be papered over.

Hehe, ok.
Then you might want to remove all the "papering-over" code a few lines
above, too ? ;)

Regards,
Frank

> Regards,
>
> 	Hans


