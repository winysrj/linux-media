Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3980 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaCaIG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 04:06:26 -0400
Message-ID: <533921F8.1000508@xs4all.nl>
Date: Mon, 31 Mar 2014 10:06:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-sparse@vger.kernel.org
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: sparse: ioctl defines and "error: bad integer constant expression"
References: <53244092.6010906@xs4all.nl>
In-Reply-To: <53244092.6010906@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2014 12:59 PM, Hans Verkuil wrote:
> Hi!
> 
> Here is another sparse error that I get when running sparse over
> drivers/media/v4l2-core/v4l2-ioctl.c:
> 
> drivers/media/v4l2-core/v4l2-ioctl.c:2043:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2044:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2045:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2046:9: error: bad integer constant expression
> 
> etc.
> 
> The root cause of that turns out to be in include/asm-generic/ioctl.h:
> 
> #include <uapi/asm-generic/ioctl.h>
> 
> /* provoke compile error for invalid uses of size argument */
> extern unsigned int __invalid_size_argument_for_IOC;
> #define _IOC_TYPECHECK(t) \
>         ((sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>           sizeof(t) : __invalid_size_argument_for_IOC)
> 
> If it is defined as this:
> 
> #define _IOC_TYPECHECK(t) (sizeof(t))
> 
> then all is well with the world.
> 
> I can patch v4l2-ioctl.c to redefine _IOC_TYPECHECK if __CHECKER__ is defined, but
> shouldn't sparse understand this instead? There was a similar situation with
> ARRAY_SIZE in the past that sparse now understands.

Here is a small test case for this problem:

====== ioc-typecheck.c ======
extern unsigned int __invalid_size_argument_for_IOC;
#define _IOC_TYPECHECK(t) \
                ((sizeof(t) == sizeof(t[1]) && \
                    sizeof(t) < (1 << 14)) ? \
                   sizeof(t) : __invalid_size_argument_for_IOC)

#define TEST_IOCTL (50 | (_IOC_TYPECHECK(unsigned) << 8))

static unsigned iocnrs[] = {
        [TEST_IOCTL & 0xff] = 1,
};
/*
 * check-name: correct handling of _IOC_TYPECHECK
 *
 * check-error-start
 * check-error-end
 */
====== ioc-typecheck.c ======

Running sparse over this gives:

error: bad integer constant expression

Regards,

	Hans
