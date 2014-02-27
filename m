Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52233 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaB0Amp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:42:45 -0500
Message-ID: <530E8A03.6070207@iki.fi>
Date: Thu, 27 Feb 2014 02:42:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 08/16] rtl2832_sdr: Realtek RTL2832 SDR driver
 module
References: <1392084299-16549-1-git-send-email-crope@iki.fi> <1392084299-16549-9-git-send-email-crope@iki.fi> <52FE2ECD.4080200@xs4all.nl>
In-Reply-To: <52FE2ECD.4080200@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 14.02.2014 16:57, Hans Verkuil wrote:
> On 02/11/2014 03:04 AM, Antti Palosaari wrote:

>> +static int rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
>> +{
>> +	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
>> +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>> +
>> +	if (mutex_lock_interruptible(&s->v4l2_lock))
>> +		return -ERESTARTSYS;
>
> Just use mutex_lock here. The return code of stop_streaming is never checked
> so stop_streaming must always succeed. Personally I am in favor of changing
> the return code of stop_streaming to void since it simply doesn't make sense
> to return an error here.

I decided not to change that at this time. My brains are so sleepy just 
now that I cannot think about it on the level I would like. IIRC did 
similar change to DVB USB year or two back as it happens some signal was 
coming from userspace (crtl+C) and it breaks out too early without 
putting hw to sleep. So I think that there should not be interruptible 
mutex in any patch where is I/O done. But that is similarly to other 
drivers too, feel free to fix all those if you wish :)

regards
Antti

-- 
http://palosaari.fi/
