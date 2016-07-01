Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51925 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbcGAPxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 11:53:16 -0400
Subject: Re: A potential race
To: Pavel Andrianov <andrianov@ispras.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Vladis Dronov <vdronov@redhat.com>,
	Insu Yun <wuninsu@gmail.com>, Oliver Neukum <oneukum@suse.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vaishali Thakkar <vaishali.thakkar@oracle.com>,
	ldv-project@linuxtesting.org
References: <57727001.7040606@ispras.ru> <577680B3.5010901@ispras.ru>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8c161772-d2d9-0897-7f76-40caea5f0a93@xs4all.nl>
Date: Fri, 1 Jul 2016 17:53:09 +0200
MIME-Version: 1.0
In-Reply-To: <577680B3.5010901@ispras.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2016 04:39 PM, Pavel Andrianov wrote:
>  Hi!
> 
> There is a potential race condition between usbvision_v4l2_close
> <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L403> and usbvision_disconnect
> <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1569>. The possible scenario may be the following.
> usbvision_disconnect <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1569> starts execution, assigns
> usbvision->remove_pending = 1 <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1587>, and is interrupted
> (rescheduled) after mutex_unlock <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1592>. After that
> usbvision_v4l2_close <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L403> is executed, decrease
> usbvision->user-- <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L419>, checks
> usbvision->remove_pending <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L422>, executes
> usbvision_release <http://lxr.free-electrons.com/ident?i=usbvision_release> and finishes. Then usbvision_disconnect
> <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1569> continues its execution. It checks
> usbversion->user <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1594> (it is already 0) and also
> execute usbvision_release <http://lxr.free-electrons.com/ident?i=usbvision_release>. Thus, release is executed twice. The same situation may
> occur if usbvision_v4l2_close <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L403> is interrupted by
> usbvision_disconnect <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1569>. Moreover, the same problem
> is in usbvision_radio_close <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1135>. In all these cases
> the check before call usbvision_release <http://lxr.free-electrons.com/ident?i=usbvision_release> under mutex_lock protection does not solve
> the problem, because  there may occur an open() after the check and the race takes place again. The question is: why the usbvision_release
> <http://lxr.free-electrons.com/ident?i=usbvision_release> is called from close() (usbvision_v4l2_close
> <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L403> and usbvision_radio_close
> <http://lxr.free-electrons.com/source/drivers/media/usb/usbvision/usbvision-video.c#L1135>)? Usually release functions are called from
> disconnect.

Please don't use html mail, mailinglists will silently reject this.

The usbvision driver is old and unloved and known to be very bad code. It needs a huge amount of work to make all this work correctly.

I don't see anyone picking this up...

Regards,

	Hans
