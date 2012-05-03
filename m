Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab2ECMH7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 08:07:59 -0400
Message-ID: <4FA27507.3050508@redhat.com>
Date: Thu, 03 May 2012 09:07:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, remi@remlab.net,
	nbowler@elliptictech.com, james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
References: <20120502191324.GE852@valkosipuli.localdomain>  <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>  <201205022245.22585.hverkuil@xs4all.nl> <4FA1B27A.2030405@redhat.com> <1336005780.24477.7.camel@palomino.walls.org> <4FA25C65.2020700@redhat.com> <4FA25F66.5090100@iki.fi>
In-Reply-To: <4FA25F66.5090100@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-05-2012 07:35, Sakari Ailus escreveu:
> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
>> Em 02-05-2012 21:42, Andy Walls escreveu:
>>> On Wed, 2012-05-02 at 19:17 -0300, Mauro Carvalho Chehab wrote:
>>>
>>>> We can speed-up the conversions, with something like:
>>>>
>>>> enum foo {
>>>>     BAR
>>>> };
>>>>
>>>> if (sizeof(foo) != sizeof(u32))
>>>>     call_compat_logic().
>>>>
>>>> I suspect that sizeof() won't work inside a macro.
>>>
>>> sizeof() is evaluated at compile time, after preprocessing.
>>> It should work inside of a macro.
>>
>> I tried to compile this small piece of code:
>>
>> enum foo { BAR };
>> #if sizeof(foo) != sizeof(int)
>> void main(void) { printf("different sizes\n"); }
>> #else
>> void main(void) { printf("same size\n"); }
>> #endif
>>
>> It gives an error:
>>
>> /tmp/foo.c:2:11: error: missing binary operator before token "("
>>
>> So, either this doesn't work, because sizeof() is evaluated too late,
>> or some trick is needed.
>>
>> Weird enough, cpp generates the error, but the expression is well-evaluated:
>>
>> $ cpp /tmp/foo.c
>> # 1 "/tmp/foo.c"
>> # 1 "<built-in>"
>> # 1 "<command-line>"
>> # 1 "/tmp/foo.c"
>> /tmp/foo.c:2:11: error: missing binary operator before token "("
>> enum foo { BAR };
> 
> sizeof() is processed by C compiler while #if is preprocessor directive, and its arguments have to be evaluable by the preprocessor, which is the problem here.
> 
> The C compiler can also optimise away things like that but it's more difficult to see whether that takes place or not; one would need to look at the resulting assembly code.

This code:

void main(void) {
	if (sizeof(int) == sizeof(char))
	   	printf("same size\n");
	else
		printf("different sizes\n"); 
}

should be evaluated by the compiler as if (0) and should not generate any code.

The assembler for it is:

	.file	"foo.c"
	.section	.rodata
.LC0:
	.string	"different sizes"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$.LC0, %edi
	call	puts
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.6.3 20120306 (Red Hat 4.6.3-2)"
	.section	.note.GNU-stack,"",@progbits

So, gcc will remove the dead code, as expected.

So, the trick is to do something similar to that on the compat code, in order
to avoid any penalties when sizeof(enum) is 32 bits.

Regards,
Mauro
