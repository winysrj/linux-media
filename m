Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:52368 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab3BEQ4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 11:56:49 -0500
Received: by mail-la0-f47.google.com with SMTP id fj20so396177lab.20
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2013 08:56:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302051635.08448.hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
	<201302041435.26878.hverkuil@xs4all.nl>
	<CA+6av4kp54eQSeefAnJxY80HtOJ5iCBh+ETOZaKQHbo=m86-DQ@mail.gmail.com>
	<201302051635.08448.hverkuil@xs4all.nl>
Date: Tue, 5 Feb 2013 13:56:46 -0300
Message-ID: <CALF0-+X3rwi6Dg8G8aDcv65Kz7hRM4qRhBUmMymW_JmifSFysQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 5, 2013 at 12:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue February 5 2013 16:28:17 Arvydas Sidorenko wrote:
>> On Mon, Feb 4, 2013 at 2:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >
>> > Hi Arvydas,
>> >
>> > Yes indeed, it would be great if you could test this!
>> >
>> > Note that the patch series is also available in my git tree:
>> >
>> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/stkwebcam
>> >
>> > Besides the normal testing that everything works as expected, it would also
>> > be great if you could run the v4l2-compliance tool. It's part of the v4l-utils
>> > repository (http://git.linuxtv.org/v4l-utils.git) and it tests whether a driver
>> > complies to the V4L2 specification.
>> >
>> > Just compile the tool from the repository (don't use a distro-provided version)
>> > and run it as 'v4l2-compliance -d /dev/videoX' and mail me the output. You will
>> > get at least one failure at the end, but I'd like to know if there are other
>> > issues remaining.
>> >
>> > Regards,
>> >
>> >         Hans
>>
>> I have tested the patches using STK-1135 webcam. Everything works well.
>>
>> $ v4l2-compliance -d /dev/video0
>> Driver Info:
>>       Driver name   : stk
>>       Card type     : stk
>>       Bus info      :
>>       Driver version: 0.0.1
>
> This is the old version of the driver you are testing with :-)
>

@Arvydas: First of all, thanks for taking the time to test Hans' patches.

I suggest to double check the old driver
is not loaded and then run "depmod -a" to update modules.

As a last resource you can always wipe out the driver from
/lib/modules/what-ever and reinstall.

Hope this helps!

-- 
    Ezequiel
