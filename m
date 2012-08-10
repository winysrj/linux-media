Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab2HJITX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 04:19:23 -0400
Message-ID: <5024C443.9040802@redhat.com>
Date: Fri, 10 Aug 2012 10:20:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org,
	koradlow@gmail.com
Subject: Re: [RFC PATCH 1/2] Add libv4l2rds library (with changes proposed
 in RFC)
References: <[RFC PATCH 0/2] Add support for RDS decoding> <201208091414.11249.hverkuil@xs4all.nl> <5024B552.7090205@redhat.com> <201208100936.59213.hverkuil@xs4all.nl>
In-Reply-To: <201208100936.59213.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/10/2012 09:36 AM, Hans Verkuil wrote:
> On Fri 10 August 2012 09:16:34 Hans de Goede wrote:
>> Hi,
>>
>> On 08/09/2012 02:14 PM, Hans Verkuil wrote:
>>> On Thu August 9 2012 13:58:07 Hans de Goede wrote:
>>>> Hi Konke,
>>>>
>>>> As Gregor already mentioned there is no need to define libv4l2rdssubdir in configure.ac ,
>>>> so please drop that.
>>>>
>>>> Other then that I've some minor remarks (comments inline), with all those
>>>> fixed, this one is could to go. So hopefully the next version can be added
>>>> to git master!
>>>>
>>>> On 08/07/2012 05:11 PM, Konke Radlow wrote:
>>>>> ---
>>>>>     Makefile.am                     |    3 +-
>>>>>     configure.ac                    |    7 +-
>>>>>     lib/include/libv4l2rds.h        |  228 ++++++++++
>>>>>     lib/libv4l2rds/Makefile.am      |   11 +
>>>>>     lib/libv4l2rds/libv4l2rds.c     |  953 +++++++++++++++++++++++++++++++++++++++
>>>>>     lib/libv4l2rds/libv4l2rds.pc.in |   11 +
>>>>>     6 files changed, 1211 insertions(+), 2 deletions(-)
>>>>>     create mode 100644 lib/include/libv4l2rds.h
>>>>>     create mode 100644 lib/libv4l2rds/Makefile.am
>>>>>     create mode 100644 lib/libv4l2rds/libv4l2rds.c
>>>>>     create mode 100644 lib/libv4l2rds/libv4l2rds.pc.in
>>>>>
>>>>
>>>> <snip>
>>>>
>>>>> diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
>>>>> new file mode 100644
>>>>> index 0000000..4aa8593
>>>>> --- /dev/null
>>>>> +++ b/lib/include/libv4l2rds.h
>>>>> @@ -0,0 +1,228 @@
>>>>> +/*
>>>>> + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>>>>> + * Author: Konke Radlow <koradlow@gmail.com>
>>>>> + *
>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU Lesser General Public License as published by
>>>>> + * the Free Software Foundation; either version 2.1 of the License, or
>>>>> + * (at your option) any later version.
>>>>> + *
>>>>> + * This program is distributed in the hope that it will be useful,
>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>> + * GNU General Public License for more details.
>>>>> + *
>>>>> + * You should have received a copy of the GNU General Public License
>>>>> + * along with this program; if not, write to the Free Software
>>>>> + * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
>>>>> + */
>>>>> +
>>>>> +#ifndef __LIBV4L2RDS
>>>>> +#define __LIBV4L2RDS
>>>>> +
>>>>> +#include <errno.h>
>>>>> +#include <stdio.h>
>>>>> +#include <stdlib.h>
>>>>> +#include <string.h>
>>>>> +#include <stdbool.h>
>>>>> +#include <unistd.h>
>>>>> +#include <stdint.h>
>>>>> +#include <time.h>
>>>>> +#include <sys/types.h>
>>>>> +#include <sys/mman.h>
>>>>> +#include <config.h>
>>>>
>>>> You should never include config.h in a public header, also
>>>> are all the headers really needed for the prototypes in this header?
>>>>
>>>> I don't think so! Please move all the unneeded ones to the libv4l2rds.c
>>>> file!
>>>>
>>>>> +
>>>>> +#include <linux/videodev2.h>
>>>>> +
>>>>> +#ifdef __cplusplus
>>>>> +extern "C" {
>>>>> +#endif /* __cplusplus */
>>>>> +
>>>>> +#if HAVE_VISIBILITY
>>>>> +#define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
>>>>> +#else
>>>>> +#define LIBV4L_PUBLIC
>>>>> +#endif
>>>>> +
>>>>> +/* used to define the current version (version field) of the v4l2_rds struct */
>>>>> +#define V4L2_RDS_VERSION (1)
>>>>> +
>>>>
>>>> What is the purpose of this field? Once we've released a v4l-utils with this
>>>> library we are stuck to the API we've defined, having a version field & changing it,
>>>> won't stop us from breaking existing apps, so once we've an official release we
>>>> simply cannot make ABI breaking changes, which is why most of my review sofar
>>>> has concentrated on the API side :)
>>>>
>>>> I suggest dropping this define and the version field from the struct.
>>>
>>> I think it is useful, actually. The v4l2_rds struct is allocated by the v4l2_rds_create
>>> so at least in theory it is possible to extend the struct in the future without breaking
>>> existing apps, provided you have a version number to check.
>>
>> I disagree, if it gets extended only, then existing apps will just work, if an apps gets
>> compiled against a newer version with the extension then it is safe to assume it will run
>> against that newer version. The only reason I can see a version define being useful is
>> to make a newer app compile with an older version of the librarry, but that only requires
>> a version define, not a version field in the struct.
>
> That's true, you only need the define, not the version field.
>
> So let's keep the define and ditch the version field. I think that
> should do it.

Ack.

Regards,

Hans
