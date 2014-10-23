Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57990 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaJWIzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 04:55:05 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDW003GP3KCZT40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Oct 2014 09:57:48 +0100 (BST)
Message-id: <5448C259.5060505@samsung.com>
Date: Thu, 23 Oct 2014 10:54:49 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils RFC 0/2] libmediatext library
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com>
 <54465DDF.5030508@redhat.com> <54477D20.4030207@linux.intel.com>
 <5448BA21.2040001@redhat.com>
In-reply-to: <5448BA21.2040001@redhat.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Sakari,

On 10/23/2014 10:19 AM, Hans de Goede wrote:
> Hi,
>
> On 10/22/2014 11:47 AM, Sakari Ailus wrote:
>> Hi Hans,
>>
>> Hans de Goede wrote:
>>> Hi Sakari,
>>>
>>> On 10/21/2014 12:40 PM, Sakari Ailus wrote:
>>>> Hi,
>>>>
>>>> This is a tiny library for parsing text-based media link, V4L2 sub-device
>>>> format (and selection) configurations as well as controls with limited
>>>> types.
>>>
>>> Hmm, we also have:
>>>
>>> [PATCH/RFC v2 1/4] Add a media device configuration file parser.
>>>
>>> How do these 2 relate ?
>>
>> Jacek is working on a Samsung Exynos libv4l2 plugin, a part of which is not specific to that plugin itself, and thus should be elsewhere (libmediactl, for instance). I didn't know about that effort, and having written something close to that in the past but without finishing it, I posted mine here as well.
>>
>> The common subset of functionality is limited to parsing text based link configurations. Most of that is really implemented in libmediactl.
>
> Hmm, I guess we need to sort this out then before merging Jacek's plugin.
>
> Jacek, have you  looked into using (and if necessary extending) libmediactl
> inside your plugin ?

Not yet, temporarily I had to switch to different task, but I will
look into libmediactl soon to figure out how to use its API
in my plugin and what parts of my code could be added to it.

Best Regards,
Jacek Anaszewski

