Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2GBOl3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jul 2012 10:41:29 -0400
Message-ID: <4FF1B338.5040900@redhat.com>
Date: Mon, 02 Jul 2012 16:42:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 0/6] Add frequency band information
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Series looks good to me, ack series:
Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

On 07/02/2012 04:15 PM, Hans Verkuil wrote:
> Hi all,
>
> This patch series adds support for the new VIDIOC_ENUM_FREQ_BANDS ioctl that
> tells userspace if a tuner supports multiple frequency bands.
>
> This API is based on earlier attempts:
>
> http://www.spinics.net/lists/linux-media/msg48391.html
> http://www.spinics.net/lists/linux-media/msg48435.html
>
> And an irc discussion:
>
> http://linuxtv.org/irc/v4l/index.php?date=2012-06-26
>
> This irc discussion also talked about adding rangelow/high to the v4l2_hw_freq_seek
> struct, but I decided not to do that. The hwseek additions are independent to this
> patch series, and I think it is best if Hans de Goede does that part so that that
> API change can be made together with a driver that actually uses it.
>
> In order to show how the new ioctl is used, this patch series adds support for it
> to the very, very old radio-cadet driver.
>
> Comments are welcome!
>
> Regards,
>
> 	Hans
>
> PS: Mauro, I haven't been able to work on the radio profile yet, so that's not
> included.
>

