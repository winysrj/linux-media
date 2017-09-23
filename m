Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54342
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751030AbdIWTfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:35:39 -0400
Date: Sat, 23 Sep 2017 16:35:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.15] RC cleanup fixes
Message-ID: <20170923163531.3c1b1f06@vento.lan>
In-Reply-To: <20170923103356.hl5zrqekfjbsy7gt@gofer.mess.org>
References: <20170923103356.hl5zrqekfjbsy7gt@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

Em Sat, 23 Sep 2017 11:33:56 +0100
Sean Young <sean@mess.org> escreveu:

> Hi Mauro,
> 
> Just cleanups this round. Line count does go down, though.
> 
> Thanks,
> 
> Sean
> 
> 
> The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:
> 
>   media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/syoung/media_tree.git for-v4.15a
> 
> for you to fetch changes up to fe96866c81291a2887559fdfcc58ddf8fe54111d:
> 
>   imon: Improve a size determination in two functions (2017-09-23 11:20:12 +0100)
> 
> ----------------------------------------------------------------
> Arvind Yadav (1):
>       media: rc: constify usb_device_id
> 
> Bhumika Goyal (1):
>       media: rc: make device_type const
> 
> Colin Ian King (1):
>       media: imon: make two const arrays static, reduces object code size
> 
> David Härdeman (15):
>       media: lirc_dev: clarify error handling
>       media: lirc_dev: remove support for manually specifying minor number
>       media: lirc_dev: remove min_timeout and max_timeout

This patch doesn't get rid of the corresponding documentation bits:

$ git grep MIN_TIMEOUT Documentation/
Documentation/media/uapi/rc/lirc-get-timeout.rst:ioctls LIRC_GET_MIN_TIMEOUT and LIRC_GET_MAX_TIMEOUT
Documentation/media/uapi/rc/lirc-get-timeout.rst:LIRC_GET_MIN_TIMEOUT / LIRC_GET_MAX_TIMEOUT - Obtain the possible timeout
Documentation/media/uapi/rc/lirc-get-timeout.rst:.. c:function:: int ioctl( int fd, LIRC_GET_MIN_TIMEOUT, __u32 *timeout)
Documentation/media/uapi/rc/lirc-get-timeout.rst:    :name: LIRC_GET_MIN_TIMEOUT
Documentation/media/uapi/rc/lirc-set-rec-timeout.rst:   The range of supported timeout is given by :ref:`LIRC_GET_MIN_TIMEOUT`.

I didn't see any other patches in this series getting rid of them
either.

>       media: lirc_dev: use cdev_device_add() helper function
>       media: lirc_dev: make better use of file->private_data

I suspect that this patch will likely break the imon driver:

$ git grep private_data drivers/media/rc/
drivers/media/rc/imon.c:                file->private_data = ictx;
drivers/media/rc/imon.c:        ictx = file->private_data;
drivers/media/rc/imon.c:        ictx = file->private_data;
drivers/media/rc/imon.c:        ictx = file->private_data;

Please double-check if the remaining patches won't risk causing
regressions, as there are several patches there touching the RC
core ;-)

For now, I'll mark the pull request with "Changes requested".

Thanks,
Mauro
