Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48063 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbbHABvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 21:51:16 -0400
Subject: Re: [PATCH] vb2: revert: vb2: allow requeuing buffers while streaming
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1438183745-2652-1-git-send-email-crope@iki.fi>
 <20150731144334.GE15270@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55BC2610.6050809@iki.fi>
Date: Sat, 1 Aug 2015 04:51:12 +0300
MIME-Version: 1.0
In-Reply-To: <20150731144334.GE15270@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 07/31/2015 05:43 PM, Sakari Ailus wrote:
> Terve,
>
> On Wed, Jul 29, 2015 at 06:29:05PM +0300, Antti Palosaari wrote:
>> commit ce0eff016f7272faa6dc6eec722b1ca1970ff9aa
>> [media] vb2: allow requeuing buffers while streaming
>>
>> That commit causes buf_queue() called on infinity loop when
>> start_streaming() returns error. On that case resources are eaten
>> quickly and machine crashes.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> Fixed by this patch in media-fixes:
>
> commit 6d058c5643e16779ae4c001d2e893c140940e48f
> Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> Date:   Fri Jul 3 04:37:07 2015 -0300
>
>      [media] vb2: Only requeue buffers immediately once streaming is started
>
>      Buffers can be returned back to videobuf2 in driver's streamon handler. In
>      this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
>      cause the driver's buf_queue vb2 operation to be called, queueing the same
>      buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
>      on.
>
>      Add a new buffer state VB2_BUF_STATE_REQUEUEING which, when used as the
>      state argument to vb2_buffer_done(), will result in buffers queued to the
>      driver. Using VB2_BUF_STATE_QUEUED will leave the buffer to videobuf2, as it
>      was before "[media] vb2: allow requeuing buffers while streaming".
>
>      Fixes: ce0eff016f72 ("[media] vb2: allow requeuing buffers while streaming")
>
>      [mchehab@osg.samsung.com: fix warning: enumeration value 'VB2_BUF_STATE_REQUEUEING' not handled in switch]
>
>      Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>      Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>      Cc: stable@vger.kernel.org # for v4.1
>      Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

I wonder why this fix is not included to media master yet, but only 
fixes... It is not first time such happens. I wasted a lot of time when 
I tried implement receiver / transmitter blocking to hackrf driver 
start_streaming and it crashes machine always, lets say 15 times, until 
I started suspect issue might be somewhere else than driver.

Anyhow, you could crash machine easily with that bug using vivid driver 
error injection option
v4l2-ctl -d /dev/video0 -c inject_vidioc_streamon_error=1

regards
Antti

-- 
http://palosaari.fi/
