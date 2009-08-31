Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51789 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZHaUgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 16:36:42 -0400
Message-ID: <4A9C3458.8050304@freemail.hu>
Date: Mon, 31 Aug 2009 22:36:40 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libv4l: add NULL pointer check
References: <4A9A3EB0.8060304@freemail.hu> <200908310852.38847.laurent.pinchart@ideasonboard.com> <20090831101932.526dfdbc@pedra.chehab.org> <200908312216.14184.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200908312216.14184.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> On Monday 31 August 2009 15:19:32 Mauro Carvalho Chehab wrote:
>> Em Mon, 31 Aug 2009 08:52:38 +0200
>>
>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
>>>>  - dereferencing a NULL pointer is not always result segfault, see [1]
>>>> and [2]. So dereferencing a NULL pointer can be treated also as a
>>>> security risk.
>> From kernelspace drivers POV, any calls sending a NULL pointer should
>> result in an error as soon as possible, to avoid any security risks.
>> Currently, this check is left to the driver, but we should consider
>> implementing such control globally, at video_ioctl2 and at compat32 layer.
>>
>> IMHO, libv4l should mimic the driver behavior of returning an error instead
>> of letting the application to segfault, since, on some critical
>> applications, like video-surveillance security systems, a segfault could be
>> very bad.
> 
> And uncaught errors would be even better. A segfault will be noticed right 
> away, while an unhandled error code might slip through to the released 
> software. If a security-sensitive application passes a NULL pointer where it 
> shouldn't I'd rather see the development machine burst into flames instead of 
> silently ignoring the problem.

I have an example. Let's imagine the following code:

    struct v4l2_capability* cap;

    cap = malloc(sizeof(*cap));
    ret = ioctl(f, VIDIOC_QUERYCAP, cap);
    if (ret == -1) {
        /* error handling */
    }

Does this code contain implementation problem? Yes, the value of cap should
be checked whether it is NULL or not.

Will this code cause problem? Most of the time not, only in case of low
memory condition, thus this implementation problem will usually not detected
if the ioctl() caused segfault on NULL pointers.

One more thing I would like to mention on this topic. This is coming from
the C language which does not contain structured exception handling as for
example Java has with its exception handling capability. The usual way to
signal errors is through the return value. This is what a C programmer learns
and this is what she or he expects. The signals as segfault is out of the
scope of the C language.

Regards,

	Márton Németh






