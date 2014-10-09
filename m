Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31025 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIHvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 03:51:42 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND6000FX3AR6500@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Oct 2014 08:54:27 +0100 (BST)
Message-id: <54363E8A.2020201@samsung.com>
Date: Thu, 09 Oct 2014 09:51:38 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Antonio Ospite <ao2@ao2.it>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
 <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
 <54353124.1060704@redhat.com> <54353AA3.3040506@samsung.com>
 <20141008174957.8451ebb426619d88d7a30cfd@ao2.it>
In-reply-to: <20141008174957.8451ebb426619d88d7a30cfd@ao2.it>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2014 05:49 PM, Antonio Ospite wrote:
> On Wed, 08 Oct 2014 15:22:43 +0200
> Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
>
>> Hi Hans,
>>
>> On 10/08/2014 02:42 PM, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 10/08/2014 10:46 AM, Jacek Anaszewski wrote:
>>>> The plugin provides support for the media device on Exynos4 SoC.
>>>> Added is also a media device configuration file parser.
>>>> The media configuration file is used for conveying information
>>>> about media device links that need to be established as well
>>>> as V4L2 user control ioctls redirection to a particular
>>>> sub-device.
>>>>
>>>> The plugin performs single plane <-> multi plane API conversion,
>>>> video pipeline linking and takes care of automatic data format
>>>> negotiation for the whole pipeline, after intercepting
>>>> VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>    configure.ac                                       |    1 +
>>>>    lib/Makefile.am                                    |    5 +-
>>>>    lib/libv4l-exynos4-camera/Makefile.am              |    7 +
>>>>    .../libv4l-devconfig-parser.h                      |  145 ++
>>>>    lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c  | 2486 ++++++++++++++++++++
>>>>    5 files changed, 2642 insertions(+), 2 deletions(-)
>>>>    create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
>>>>    create mode 100644 lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
>>>>    create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
>>>
>>> Ugh, that is a big plugin. Can you please split out the parser stuff
>>> into a separate file ?
>>
>> Yes, I tried to split it, but spent so much time fighting with
>> autotools, that I decided to submit it in this form and ask
>> more experienced v4l-utils build system maintainers for the advice.
>> I mentioned this in the cover letter.
>>
>
> What autotools issue in particular?
> The following change followed by "automake && ./configure" should be
> enough to add a new file libv4l-devconfig-parser.c:

The same modifications produced libv4l-exynos4-camera.so without parser 
symbols, when I applied them previously, but when I tried them again
everything is ok. Probably I wasn't doing proper cleanup.
Thanks for the hints.

Best Regards,
Jacek Anaszewski
