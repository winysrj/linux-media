Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34574 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbcEVKHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 06:07:15 -0400
Received: by mail-wm0-f68.google.com with SMTP id n129so7489346wmn.1
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 03:07:14 -0700 (PDT)
Subject: Re: [PATCH] [media]: Driver for Toshiba et8ek8 5MP sensor
To: sakari.ailus@iki.fi
References: <20160501134122.GG26360@valkosipuli.retiisi.org.uk>
 <1462287004-21099-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <574184CF.5080607@gmail.com>
Date: Sun, 22 May 2016 13:07:11 +0300
MIME-Version: 1.0
In-Reply-To: <1462287004-21099-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On  3.05.2016 17:50, Ivaylo Dimitrov wrote:
> The sensor is found in Nokia N900 main camera
>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>   .../bindings/media/i2c/toshiba,et8ek8.txt          |   53 +
>   drivers/media/i2c/Kconfig                          |    1 +
>   drivers/media/i2c/Makefile                         |    1 +
>   drivers/media/i2c/et8ek8/Kconfig                   |    6 +
>   drivers/media/i2c/et8ek8/Makefile                  |    2 +
>   drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1711 ++++++++++++++++++++
>   drivers/media/i2c/et8ek8/et8ek8_mode.c             |  591 +++++++
>   drivers/media/i2c/et8ek8/et8ek8_reg.h              |  100 ++
>   include/uapi/linux/v4l2-controls.h                 |    5 +
>   9 files changed, 2470 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>   create mode 100644 drivers/media/i2c/et8ek8/Kconfig
>   create mode 100644 drivers/media/i2c/et8ek8/Makefile
>   create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
>   create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
>   create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h
>


ping
