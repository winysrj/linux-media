Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaJWJcE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 05:32:04 -0400
Message-ID: <5448CB0B.7090606@redhat.com>
Date: Thu, 23 Oct 2014 11:31:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
CC: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils RFC 0/2] libmediatext library
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com> <54465DDF.5030508@redhat.com> <54477D20.4030207@linux.intel.com> <5448BA21.2040001@redhat.com> <5448C259.5060505@samsung.com>
In-Reply-To: <5448C259.5060505@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/23/2014 10:54 AM, Jacek Anaszewski wrote:
> Hi Hans, Sakari,
> 
> On 10/23/2014 10:19 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 10/22/2014 11:47 AM, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> Hans de Goede wrote:
>>>> Hi Sakari,
>>>>
>>>> On 10/21/2014 12:40 PM, Sakari Ailus wrote:
>>>>> Hi,
>>>>>
>>>>> This is a tiny library for parsing text-based media link, V4L2 sub-device
>>>>> format (and selection) configurations as well as controls with limited
>>>>> types.
>>>>
>>>> Hmm, we also have:
>>>>
>>>> [PATCH/RFC v2 1/4] Add a media device configuration file parser.
>>>>
>>>> How do these 2 relate ?
>>>
>>> Jacek is working on a Samsung Exynos libv4l2 plugin, a part of which is not specific to that plugin itself, and thus should be elsewhere (libmediactl, for instance). I didn't know about that effort, and having written something close to that in the past but without finishing it, I posted mine here as well.
>>>
>>> The common subset of functionality is limited to parsing text based link configurations. Most of that is really implemented in libmediactl.
>>
>> Hmm, I guess we need to sort this out then before merging Jacek's plugin.
>>
>> Jacek, have you  looked into using (and if necessary extending) libmediactl
>> inside your plugin ?
> 
> Not yet, temporarily I had to switch to different task, but I will
> look into libmediactl soon to figure out how to use its API
> in my plugin and what parts of my code could be added to it.

Great, I think it is best to wait with merging your plugin to this is
sorted out. Once that is sorted out I think we should be able to merge
it relatively quickly.

Maybe we should merge libmediactl into v4l-utils then ? Rather then
v4l-utils growing an external dependency on it. Sakari ?

Regards,

Hans
