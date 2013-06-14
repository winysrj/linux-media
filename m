Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42654 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3FNMTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 08:19:06 -0400
Received: by mail-ie0-f180.google.com with SMTP id f4so1185788iea.25
        for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 05:19:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306141051.00736.hverkuil@xs4all.nl>
References: <51BAC2F6.40708@redhat.com>
	<201306141051.00736.hverkuil@xs4all.nl>
Date: Fri, 14 Jun 2013 08:19:05 -0400
Message-ID: <CAGoCfiwSnCGRMeiBSAUiQQ4AAfO95TR5ECq_HS_+a2q+=ZhRKw@mail.gmail.com>
Subject: Re: Doing a v4l-utils-1.0.0 release
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've got a fix for a really bad performance bug, so if you can hold
off on doing a release a couple of hours until I can get in front of
my Linux box and submit a patch, I would appreciate it.

Thanks,

Devin

On Fri, Jun 14, 2013 at 4:51 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri 14 June 2013 09:15:02 Hans de Goede wrote:
>> Hi All,
>>
>> IIRC the 0.9.x series were meant as development releases leading up to a new
>> stable 1.0.0 release. Lately there have been no maintenance 0.8.x releases
>> and a lot of interesting development going on in the 0.9.x, while at the
>> same time there have been no issues reported against 0.9.x (iow it seems
>> stable).
>>
>> So how about taking current master and releasing that as a 1.0.0 release ?
>
> Fine by me!
>
> Note that the libv4l2rds code is now finalized, so that can be released as
> well.
>
> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
