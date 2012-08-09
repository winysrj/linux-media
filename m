Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39748 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2HIOMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 10:12:13 -0400
Received: by qcro28 with SMTP id o28so248793qcr.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 07:12:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5023652D.4010508@googlemail.com>
References: <1344352315-1184-1-git-send-email-kradlow@cisco.com>
	<bce8b8118e9a8bcc7fd528d8b8d1a0732a9c8954.1344352285.git.kradlow@cisco.com>
	<5023652D.4010508@googlemail.com>
Date: Thu, 9 Aug 2012 14:12:12 +0000
Message-ID: <CAFomkUD6YHjdOZN3pMXAnpDEUTc86TWF_dAxqa2y9ZDZR6YEYQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Add libv4l2rds library (with changes proposed in RFC)
From: Konke Radlow <koradlow@googlemail.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

they are gone.

And btw: I'm sorry for fiddling with your build environment in such a
way. I have to
admit that the additions I made were based more on copying from
existing libraries than
really understanding the effects of each command.

Regards,
Konke

On Thu, Aug 9, 2012 at 7:22 AM, Gregor Jasny <gjasny@googlemail.com> wrote:
> Hello Konke,
>
>
> On 8/7/12 5:11 PM, Konke Radlow wrote:
>>
>> diff --git a/configure.ac b/configure.ac
>> index 8ddcc9d..1109c4d 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -146,9 +148,12 @@ AC_ARG_WITH(libv4l2subdir,
>> AS_HELP_STRING(--with-libv4l2subdir=DIR,set libv4l2 l
>>   AC_ARG_WITH(libv4lconvertsubdir,
>> AS_HELP_STRING(--with-libv4lconvertsubdir=DIR,set libv4lconvert library
>> subdir [default=libv4l]),
>>      libv4lconvertsubdir=$withval, libv4lconvertsubdir="libv4l")
>>
>> +AC_ARG_WITH(libv4l2rdssubdir,
>> AS_HELP_STRING(--with-libv4l2rdssubdir=DIR,set libv4l2rds library subdir
>> [default=libv4l]),
>> +   libv4l2rdssubdir=$withval, libv4l2rdssubdir="libv4l")
>> +
>>   AC_ARG_WITH(udevdir, AS_HELP_STRING(--with-udevdir=DIR,set udev
>> directory [default=/lib/udev]),
>>      udevdir=$withval, udevdir="/lib/udev")
>> -
>> +
>>   libv4l1privdir="$libdir/$libv4l1subdir"
>>   libv4l2privdir="$libdir/$libv4l2subdir"
>>   libv4l2plugindir="$libv4l2privdir/plugins"
>
>
> please remove these changes. They are not needed for the RDS library.
>
> Thanks,
> Gregor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
