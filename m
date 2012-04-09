Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab2DIQb6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Apr 2012 12:31:58 -0400
Message-ID: <4F830EFA.8040403@redhat.com>
Date: Mon, 09 Apr 2012 13:31:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] media_build: fix module_*_driver redefined warnings
References: <1332252617-3171-1-git-send-email-gennarone@gmail.com> <4F82D768.5030007@redhat.com> <4F82EF01.1090403@gmail.com>
In-Reply-To: <4F82EF01.1090403@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-04-2012 11:15, Gianluca Gennari escreveu:
> 
> Il 09/04/2012 14:34, Mauro Carvalho Chehab ha scritto:
>> Hi Gianluca,
>>
>> Em 20-03-2012 11:10, Gianluca Gennari escreveu:
>>
>> Please avoid adding more tests for an specific Kernel version here. There are
>> two issues with checks like that:
>>
>> 	1) this may break on some kernel-fix release that might backport the function.
>> This is not very common, but there was some cases like that, in the USB subsystem;
>>
>> 	2) this generally breaks compilation, after some time, if someone tries
>> to compile it against a distribution-patched kernel, as the new code may be
>> backported there.
>>
>> That's said, if just doing an "#ifdef module_usb_driver" doesn't work because this
>> is not a macro, you can add a simple check at this script:
>> 	v4l/scripts/make_config_compat.pl 
>>
>> like this one:
>>
>> 	check_file_for_func("include/linux/delay.h", "usleep_range", "NEED_USLEEP_RANGE");
>>
>> This function will seek for "usleep_range" at the delay.h header. If not found, it will
>> add a #define NEED_USLEEP_RANGE at v4l/config-compat.h, that can be checked inside compat.h:
>>
>> #ifdef NEED_USLEEP_RANGE
>> #define usleep_range(min, max) msleep(min/1000)
>> #endif
>>
>> You can use the same kind of logic for module_usb_driver.
>>
>> Regards,
>> Mauro
> 
> Hi Mauro,
> thanks for the explanation but Hans Verkuil already solved the issue
> using the check_file_for_func method:
> 
> http://git.linuxtv.org/media_build.git/commit/2492bf186743a925db98694911649fa0e94003f5

Yeah, I noticed when I've updated it to apply a patch for Debian handling. Anyway,
I hope that the explanation is useful for you and others, as this way means less
headache on maintaining backward compatibility.

> Of course, I agree this is a much better solution.
> 
> Regards,
> Gianluca

Regards,
Mauro

