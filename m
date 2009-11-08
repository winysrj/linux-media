Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZKHQNH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 11:13:07 -0500
Message-ID: <4AF6EF59.90206@redhat.com>
Date: Sun, 08 Nov 2009 17:18:33 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: pac7302: INFO: possible circular locking dependency detected
References: <4AF48F80.4000809@freemail.hu> <4AF68BC6.4040801@redhat.com> <4AF695CC.7040809@freemail.hu>
In-Reply-To: <4AF695CC.7040809@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/08/2009 10:56 AM, Németh Márton wrote:
> Hi,
>
> Hans de Goede wrote:
>> [snip]
>>
>> About the usb control msg errors, I don't think they are related to this issue at all, no real
>> world app ever does a streamon and an mmap at the same time. As said if we could serialize mmap and
>> ioctl at a high enough level, things would be fine too.
>
> I am using http://moinejf.free.fr/svv.c . In the start_capturing() function it calls the
> VIDIOC_STREAMON ioctl in case of memory mapped mode. Is this wrong? Or do you mean under
> "at the same time" that VIDIOC_STREAMON and mmap() is called from different tasks/threads?
>

Yes from 2 different threads, which are both the stream owner (so operating on the same FD).

Regards,

Hans
