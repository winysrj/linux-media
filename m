Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50969 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0JWACL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 20:02:11 -0400
Received: by vws13 with SMTP id 13so19719vws.19
        for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 17:02:10 -0700 (PDT)
Message-ID: <4CC225F9.5030603@gmail.com>
Date: Fri, 22 Oct 2010 22:02:01 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Use modaliases to load I2C modules
References: <201010061045.02832.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010061045.02832.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

Em 06-10-2010 05:45, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:
> 
>   V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of sn9c102
>   (2010-10-01 18:14:35 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git i2c-module-name
> 
> The patches have been posted to the list, and acked for pvrusb2, soc-camera
> and sh_vou.
> 
> Laurent Pinchart (16):
>       v4l: Load I2C modules based on modalias
>       v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev*
>       go7007: Add MODULE_DEVICE_TABLE to the go7007 I2C modules
>       go7007: Fix the TW2804 I2C type name
>       go7007: Don't use module names to load I2C modules
>       zoran: Don't use module names to load I2C modules
>       pvrusb2: Don't use module names to load I2C modules
>       sh_vou: Don't use module names to load I2C modules
>       radio-si4713: Don't use module names to load I2C modules
>       soc_camera: Don't use module names to load I2C modules
>       vpfe_capture: Don't use module names to load I2C modules
>       vpif_display: Don't use module names to load I2C modules
>       vpif_capture: Don't use module names to load I2C modules
>       ivtv: Don't use module names to load I2C modules
>       cx18: Don't use module names to load I2C modules
>       v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions

To avoid the risk of break something, I've applied all patches from your series, but the
last one. This way, we shouldn't have any regression, and kABI shouldn't break. So, if
someone send a patch late (and there were some new driver additions committed after your
patch), it won't break compilation for the new drivers.

Please rebase the last patch and send it to me again at the end of the -rc1 merge window.

Thanks,
Mauro
