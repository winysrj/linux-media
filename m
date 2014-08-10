Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4428 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaHJPRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 11:17:10 -0400
Message-ID: <53E78CC1.1030905@xs4all.nl>
Date: Sun, 10 Aug 2014 17:16:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] Another series of PM fixes for au0828
References: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following are just some general remarks regarding PM and au0828, it's
not specific to this patch series. I'm just brainstorming here...

It's unfortunate that the au0828 isn't using vb2 yet. I would be interested in
seeing what can be done in vb2 to help implement suspend/resume. Basically vb2
has already most (all?) of the information it needs to handle this. Ideally all
you need to do in the driver is to call vb2_suspend or vb2_resume and vb2 will
take care of the rest, calling start/stop_streaming as needed. Some work would
have to be done there to ensure buffers are queued/dequeued to the right queues
and in the right state.

So vb2 would handle all the DMA/streaming aspects of suspend/resume, thus
simplifying the driver.

Is it perhaps an idea to convert au0828 to vb2 in order to pursue this further?

Besides, converting to vb2 tends to get rid of a substantial amount of code
which makes it much easier to work with.

Regards,

	Hans

On 08/10/2014 04:14 AM, Mauro Carvalho Chehab wrote:
> There are still a few bugs that can happen when suspending and
> a video stream is active. This patch series fix them. After
> that, resume works fine, even it suspend happened while
> streaming.
> 
> There is one remaining issue though: xc5000 firmware doesn't
> load after resume.
> 
> What happens (on both analog and digital) is:
> 
> [  143.071323] xc5000: xc5000_suspend()
> [  143.071324] xc5000: xc5000_tuner_reset()
> [  143.099992] au0828: Suspend
> [  143.099992] au0828: Stopping RC
> [  143.101694] au0828: stopping V4L2
> [  143.101695] au0828: stopping V4L2 active URBs
> [  144.988637] au0828: Resume
> [  145.342026] au0828: Restarting RC
> [  145.343296] au0828: restarting V4L2
> [  145.464413] xc5000: xc5000_is_firmware_loaded() returns True id = 0xffff
> [  145.464414] xc5000: xc_set_signal_source(1) Source = CABLE
> [  146.370861] xc5000: xc_set_signal_source(1) failed
> 
> I suspect that it has to do with a wrong value for the I2C
> gateway. The proper fix is likely to convert au0828 to use
> the I2C mux support, and remove the old i2c_gate_ctrl
> approach. However, such patch would require more work, to
> avoid breaking other drivers.
> 
> Mauro Carvalho Chehab (3):
>   au0828: fix checks if dvb is initialized
>   au0828: Fix DVB resume when streaming
>   xc5000: be sure that the firmware is there before set params
> 
>  drivers/media/tuners/xc5000.c         | 10 +++++-----
>  drivers/media/usb/au0828/au0828-dvb.c | 24 ++++++++++++++----------
>  drivers/media/usb/au0828/au0828.h     |  4 ++--
>  3 files changed, 21 insertions(+), 17 deletions(-)
> 

