Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaJWITw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 04:19:52 -0400
Message-ID: <5448BA21.2040001@redhat.com>
Date: Thu, 23 Oct 2014 10:19:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: j.anaszewski@samsung.com
Subject: Re: [v4l-utils RFC 0/2] libmediatext library
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com> <54465DDF.5030508@redhat.com> <54477D20.4030207@linux.intel.com>
In-Reply-To: <54477D20.4030207@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/22/2014 11:47 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> Hans de Goede wrote:
>> Hi Sakari,
>>
>> On 10/21/2014 12:40 PM, Sakari Ailus wrote:
>>> Hi,
>>>
>>> This is a tiny library for parsing text-based media link, V4L2 sub-device
>>> format (and selection) configurations as well as controls with limited
>>> types.
>>
>> Hmm, we also have:
>>
>> [PATCH/RFC v2 1/4] Add a media device configuration file parser.
>>
>> How do these 2 relate ?
> 
> Jacek is working on a Samsung Exynos libv4l2 plugin, a part of which is not specific to that plugin itself, and thus should be elsewhere (libmediactl, for instance). I didn't know about that effort, and having written something close to that in the past but without finishing it, I posted mine here as well.
> 
> The common subset of functionality is limited to parsing text based link configurations. Most of that is really implemented in libmediactl.

Hmm, I guess we need to sort this out then before merging Jacek's plugin.

Jacek, have you  looked into using (and if necessary extending) libmediactl
inside your plugin ?

Regards,

Hans
