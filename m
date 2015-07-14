Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52843 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbbGNPDC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 11:03:02 -0400
Message-ID: <55A524A4.8090905@osg.samsung.com>
Date: Tue, 14 Jul 2015 09:03:00 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: Media Controller - graph_mutex
References: <55A432D1.9060008@osg.samsung.com> <55A51763.8010506@linux.intel.com>
In-Reply-To: <55A51763.8010506@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/14/2015 08:06 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> Shuah Khan wrote:
>> All,
>>
>> ALSA has to make media_entity_pipeline_start() call in irq
>> path. I am seeing warnings that the graph_mutex is unsafe irq
>> lock as expected. We have to update MC start/stop pipeline
>> to be irq safe for ALSA. Maybe there are other MC interfaces
>> that need to be irq safe, but I haven't seen any problems with
>> my limited testing.
>>
>> So as per options, graph_mutex could be changed to a spinlock.
>> It looks like drivers hold this lock and it isn't abstracted to
>> MC API. Unfortunate, this would require changes to drivers that
>> directly hold the lock for graph walks if this mutex is changed
>> to spinlock.
>>
>> e.g: drivers/media/platform/exynos4-is/fimc-isp-video.c
>>
>> Changes aren't complex, just that the scope isn't limited
>> to MC API.
>>
>> Other ideas??
> 
> Do you have (preliminary?) patches and / or more information? I'd like
> to understand why would ALSA need this.
> 
> The graph_mutex is currently also taken when the link state is modified,
> and the callbacks to the drivers may involve power state changes and
> device initialisation. On some busses such as I2C these are blocking
> operations.
> 

I am getting close to sending the RFC patches for review. I am looking
at one last issue in addition to this mutex problem. I have dmesg logs
to send and I will send them when I send the patches, so you have code
to look at as well as the dmesg.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
