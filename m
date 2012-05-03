Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49915 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab2ECKp1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 06:45:27 -0400
Received: by bkcji2 with SMTP id ji2so1218466bkc.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 03:45:26 -0700 (PDT)
Message-ID: <4FA261C4.3010405@gmail.com>
Date: Thu, 03 May 2012 12:45:24 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
References: <20120502191324.GE852@valkosipuli.localdomain>  <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>  <201205022245.22585.hverkuil@xs4all.nl> <4FA1B27A.2030405@redhat.com> <1336005780.24477.7.camel@palomino.walls.org> <4FA25C65.2020700@redhat.com>
In-Reply-To: <4FA25C65.2020700@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2012 12:22 PM, Mauro Carvalho Chehab wrote:
> Em 02-05-2012 21:42, Andy Walls escreveu:
>> On Wed, 2012-05-02 at 19:17 -0300, Mauro Carvalho Chehab wrote:
>>
>>> We can speed-up the conversions, with something like:
>>>
>>> enum foo {
>>> 	BAR
>>> };
>>>
>>> if (sizeof(foo) != sizeof(u32))
>>> 	call_compat_logic().
>>>
>>> I suspect that sizeof() won't work inside a macro.
>>
>> sizeof() is evaluated at compile time, after preprocessing.
>> It should work inside of a macro.
>
> I tried to compile this small piece of code:
>
> enum foo { BAR };
> #if sizeof(foo) != sizeof(int)
> void main(void) { printf("different sizes\n"); }
> #else
> void main(void) { printf("same size\n"); }
> #endif
>
> It gives an error:
>
> /tmp/foo.c:2:11: error: missing binary operator before token "("
>
> So, either this doesn't work, because sizeof() is evaluated too late,
> or some trick is needed.

The GCC C preprocessor documentation [1] states it won't work that way:

"The preprocessor does not know anything about types in the language. 
Therefore, sizeof operators are not recognized in `#if', and neither are 
enum constants. They will be taken as identifiers which are not macros, 
and replaced by zero. In the case of sizeof, this is likely to cause the 
expression to be invalid."

[1] http://gcc.gnu.org/onlinedocs/cpp/If.html#If


Regards,
Sylwester

> Weird enough, cpp generates the error, but the expression is well-evaluated:
>
> $ cpp /tmp/foo.c
> # 1 "/tmp/foo.c"
> # 1 "<built-in>"
> # 1 "<command-line>"
> # 1 "/tmp/foo.c"
> /tmp/foo.c:2:11: error: missing binary operator before token "("
> enum foo { BAR };
>
>
>
> void main(void) { printf("same size\n"); }
>
>
> Changing from "sizeof(foo)" to "sizeof foo" also doesn't solve:
>
> /tmp/foo.c:2:12: error: missing binary operator before token "foo"
>
> Maybe some trick is needed for it to work.
>
>> See the ARRAY_SIZE() macro in include/linux/kernel.h for a well tested
>> example.
>
> ARRAY_SIZE() doesn't have an #if on it.
>
> Regards,
> Mauro
