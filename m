Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2ECKWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 06:22:51 -0400
Message-ID: <4FA25C65.2020700@redhat.com>
Date: Thu, 03 May 2012 07:22:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
References: <20120502191324.GE852@valkosipuli.localdomain>  <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>  <201205022245.22585.hverkuil@xs4all.nl> <4FA1B27A.2030405@redhat.com> <1336005780.24477.7.camel@palomino.walls.org>
In-Reply-To: <1336005780.24477.7.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-05-2012 21:42, Andy Walls escreveu:
> On Wed, 2012-05-02 at 19:17 -0300, Mauro Carvalho Chehab wrote:
> 
>> We can speed-up the conversions, with something like:
>>
>> enum foo {
>> 	BAR
>> };
>>
>> if (sizeof(foo) != sizeof(u32))
>> 	call_compat_logic().
>>
>> I suspect that sizeof() won't work inside a macro. 
> 
> sizeof() is evaluated at compile time, after preprocessing. 
> It should work inside of a macro.

I tried to compile this small piece of code:

enum foo { BAR };
#if sizeof(foo) != sizeof(int)
void main(void) { printf("different sizes\n"); }
#else
void main(void) { printf("same size\n"); }
#endif

It gives an error:

/tmp/foo.c:2:11: error: missing binary operator before token "("

So, either this doesn't work, because sizeof() is evaluated too late,
or some trick is needed.

Weird enough, cpp generates the error, but the expression is well-evaluated:

$ cpp /tmp/foo.c
# 1 "/tmp/foo.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/tmp/foo.c"
/tmp/foo.c:2:11: error: missing binary operator before token "("
enum foo { BAR };



void main(void) { printf("same size\n"); }


Changing from "sizeof(foo)" to "sizeof foo" also doesn't solve:

/tmp/foo.c:2:12: error: missing binary operator before token "foo"

Maybe some trick is needed for it to work.

> See the ARRAY_SIZE() macro in include/linux/kernel.h for a well tested
> example.

ARRAY_SIZE() doesn't have an #if on it.

Regards,
Mauro

