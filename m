Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:9671 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaDON0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 09:26:02 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4200CXBQNCIR20@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Apr 2014 09:26:00 -0400 (EDT)
Date: Tue, 15 Apr 2014 10:25:55 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Butora <robert.butora.fi@gmail.com>
Subject: Re: [GIT PULL new driver for 3.15] media/usb/gspca: Add support for
 Scopium astro webcam (0547:7303)
Message-id: <20140415102555.58836d83@samsung.com>
In-reply-to: <533BCD1A.1010307@redhat.com>
References: <533BCD1A.1010307@redhat.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Wed, 02 Apr 2014 10:40:58 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> Hi Mauro,
> 
> Please pull from my gspca git tree for a new gspca based webcam driver,
> since this is a new driver which does not touch anything else, I would
> like to see this go into 3.15 .

Unfortunately, you sent this too late. The Kernel jenitors want to se those
patches one week before the merge window, at least, for them to review.

Also, this merge window was complex, as we merged a lot of patches there,
including some that conflicted with some DT changes.

I merged this series today for 3.16.

> 
> The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:
> 
>   [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 08:02:16 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hgoede/gspca.git media-for_v3.15
> 
> for you to fetch changes up to 8ad536cb48ac13174acef9550095539931692d69:
> 
>   media/usb/gspca: Add support for Scopium astro webcam (0547:7303) (2014-04-02 10:20:48 +0200)
> 
> ----------------------------------------------------------------
> Robert Butora (1):
>       media/usb/gspca: Add support for Scopium astro webcam (0547:7303)
> 
>  drivers/media/usb/gspca/Kconfig   |  10 +
>  drivers/media/usb/gspca/Makefile  |   2 +
>  drivers/media/usb/gspca/dtcs033.c | 434 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 446 insertions(+)
>  create mode 100644 drivers/media/usb/gspca/dtcs033.c
> 
> Thanks & Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regard
-- 

Regards,
Mauro
