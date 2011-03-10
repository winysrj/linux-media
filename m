Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab1CJTde (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 14:33:34 -0500
Message-ID: <4D7927EB.8040708@redhat.com>
Date: Thu, 10 Mar 2011 20:35:07 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yordan Kamenov <ykamenov@mm-sol.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 0/1 v3] libv4l: Add plugin support
References: <cover.1297680043.git.ykamenov@mm-sol.com> <4D78D634.70901@mm-sol.com>
In-Reply-To: <4D78D634.70901@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 03/10/2011 02:46 PM, Yordan Kamenov wrote:
> Hi Hans,
>
> any comments on that?
>

I looked at globally immediately after you send it,
summary of that look: looks good, but I still spotted
some minor issues.

I'm still trying to make some time for a more detailed
look. I hope to do that real soon now, esp. as I would
like to have this reviewed before the Warschau meeting.

Thanks & Regards,

Hans

> Regards
> Yordan
>
>
>
> Yordan Kamenov wrote:
>> Hi Hans,
>>
>> here is third version of plugin support for libv4l2.
>>
>> Changes in v3:
>>
>> * Pass opened fd to the plugin instead of filename
>> * Plugin private data is returned by init call and is passed as argument
>> in ioctl/read/close (remove libv4l2_set/get_plugindata functions)
>> * Plugin do not handle mmap/munmap
>>
>>
>>
>> --------------------------------------------------------------------------
>> Changes in v2:
>>
>> * Remove calls of v4l2_plugin_foo functions in the beginning of coresponding
>> v4l2_foo functions and instead replace SYS_FOO calls.
>> * Add to v4l2_dev_info device operation structure which can hold plugin
>> callbacks or dyrect syscall(SYS_foo, ...) calls.
>> * Under libv4lconvert also replace SYS_FOO cals with device operations. This
>> required also to add dev_ops field to v4lconvert_data and v4lcontrol_data.
>>
>> ---------------------------------------------------------------------------
>> v1:
>>
>> Here is initial version of plugin support for libv4l, based on your RFC.
>>
>> It is provided by functions v4l2_plugin_[open,close,etc]. When open() is
>> called libv4l dlopens files in /usr/lib/libv4l/plugins 1 at a time and call
>> open() callback passing through the applications parameters unmodified.
>> If a plugin is relevant for the specified device node, it can indicate so by
>> returning a value other then -1 (the actual file descriptor).
>>
>> As soon as a plugin returns another value then -1 plugin loading stops and
>> information about it (fd and corresponding library handle) is stored.
>> For each function v4l2_[ioctl,read,close,etc] is called corresponding
>> v4l2_plugin_* function which looks if there is loaded plugin for that file
>> and call it's callbacks. v4l2_plugin_* functions indicate by their first
>> argument if plugin was used, and if it was not then v4l2_* functions proceed
>> with their usual behavior.
>>
>>
>> Yordan Kamenov (1):
>> libv4l: Add plugin support to libv4l
>>
>> lib/include/libv4l2-plugin.h | 36 ++++++
>> lib/include/libv4lconvert.h | 5 +-
>> lib/libv4l2/Makefile | 4 +-
>> lib/libv4l2/libv4l2-priv.h | 10 ++
>> lib/libv4l2/libv4l2.c | 90 ++++++++++----
>> lib/libv4l2/v4l2-plugin.c | 160 ++++++++++++++++++++++++
>> lib/libv4l2/v4l2convert.c | 9 --
>> lib/libv4lconvert/control/libv4lcontrol-priv.h | 4 +
>> lib/libv4lconvert/control/libv4lcontrol.c | 35 ++++--
>> lib/libv4lconvert/control/libv4lcontrol.h | 5 +-
>> lib/libv4lconvert/libv4lconvert-priv.h | 2 +
>> lib/libv4lconvert/libv4lconvert.c | 34 ++++--
>> 12 files changed, 333 insertions(+), 61 deletions(-)
>> create mode 100644 lib/include/libv4l2-plugin.h
>> create mode 100644 lib/libv4l2/v4l2-plugin.c
>>
>
