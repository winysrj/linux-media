Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36711 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbcDYOJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 10:09:22 -0400
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
References: <571DBA2E.9020305@gmail.com>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425104037.GA20362@pali> <20160425140612.GA19175@amd>
Cc: linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	sakari.ailus@iki.fi, sre@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571E250D.6080702@xs4all.nl>
Date: Mon, 25 Apr 2016 16:09:17 +0200
MIME-Version: 1.0
In-Reply-To: <20160425140612.GA19175@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/25/2016 04:06 PM, Pavel Machek wrote:
> Hi!
> 
>> On Monday 25 April 2016 00:08:00 Ivaylo Dimitrov wrote:
>>> The needed pipeline could be made with:
>>>
>>> media-ctl -r
>>> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2
> ...
>> On Monday 25 April 2016 09:33:18 Ivaylo Dimitrov wrote:
>>> Try with:
>>>
>>> media-ctl -r
>>> media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
> ...
>>> mplayer -tv driver=v4l2:width=800:height=600:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
>>
>> Hey!!! That is crazy! Who created such retard API?? In both cases you
>> are going to show video from /dev/video6 device. But in real I have two
>> independent camera devices: front and back.
> 
> Because Nokia, and because the hardware is complex, I'm afraid. First
> we need to get it to work, than we can improve v4l... 
> 
> Anyway, does anyone know where to get the media-ctl tool? It does not
> seem to be in debian 7 or debian 8...

It's part of the v4l-utils git repo:

https://git.linuxtv.org/v4l-utils.git/

Regards,

	Hans
