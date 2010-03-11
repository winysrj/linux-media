Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:41835 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0CKOSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 09:18:43 -0500
Received: by yxe38 with SMTP id 38so42497yxe.22
        for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 06:18:43 -0800 (PST)
Message-ID: <4B98FBBF.608@gmail.com>
Date: Thu, 11 Mar 2010 11:18:39 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@t-online.de>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb build problem with soc_camera
References: <20100307113808.GA12517@gentoo.local>
In-Reply-To: <20100307113808.GA12517@gentoo.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/07/2010 08:38 AM, Halim Sahin wrote:
> Hi,
> Same environment like in my previous mail:
> 
> /root/work/v4l-dvb/v4l/soc_camera.c:27:30: error: linux/pm_runtime.h: No such file or directory
> /root/work/v4l-dvb/v4l/soc_camera.c: In function 'soc_camera_open':
> /root/work/v4l-dvb/v4l/soc_camera.c:392: error: implicit declaration of function 'pm_runtime_enable'
> /root/work/v4l-dvb/v4l/soc_camera.c:393: error: implicit declaration of function 'pm_runtime_resume'
> /root/work/v4l-dvb/v4l/soc_camera.c:422: error: implicit declaration of function 'pm_runtime_disable'
> /root/work/v4l-dvb/v4l/soc_camera.c: In function 'soc_camera_close':
> /root/work/v4l-dvb/v4l/soc_camera.c:448: error: implicit declaration of function 'pm_runtime_suspend'
> make[3]: *** [/root/work/v4l-dvb/v4l/soc_camera.o] Error 1
> make[2]: *** [_module_/root/work/v4l-dvb/v4l] Error 2
> make[1]: *** [default] Fehler 2
> make: *** [all] Fehler 2
> BR.
> Halim

Thanks for your report.
This issue was resolved. Please update your tree.

Cheers
Douglas
