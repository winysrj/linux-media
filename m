Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62794 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab1BGVpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 16:45:12 -0500
Received: by fxm20 with SMTP id 20so5382421fxm.19
        for <linux-media@vger.kernel.org>; Mon, 07 Feb 2011 13:45:11 -0800 (PST)
Message-ID: <4D5067E4.2030709@gmail.com>
Date: Mon, 07 Feb 2011 22:45:08 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Heungjun Kim <riverful.kim@samsung.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	s.nawrocki@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH v4] Add support for M5MO-LS 8 Mega Pixel camera
References: <1297079073-10916-1-git-send-email-riverful.kim@samsung.com>
In-Reply-To: <1297079073-10916-1-git-send-email-riverful.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi HeungJun,

On 02/07/2011 12:44 PM, Heungjun Kim wrote:
> Add I2C/V4L2 subdev driver for M5MO-LS camera sensor with integrated
> image processor.
> 

There is something wrong with this patch. It looks like it got mangled by
the mailer. I can see some Korean characters in it and checkpatch.pl 
returns errors:

ERROR: patch seems to be corrupt (line wrapped?)
#122: FILE: drivers/media/video/Kconfig:747:
=20

ERROR: spaces required around that '=' (ctx:WxV)
#208: FILE: drivers/media/video/m5mols/m5mols.h:36:
+	I2C_8BIT	=3D 1,
 	        	^

ERROR: spaces required around that '=' (ctx:WxV)
#209: FILE: drivers/media/video/m5mols/m5mols.h:37:
+	I2C_16BIT	=3D 2,
 	         	^

ERROR: spaces required around that '=' (ctx:WxV)
#210: FILE: drivers/media/video/m5mols/m5mols.h:38:
+	I2C_32BIT	=3D 4,
 	         	^
...

ERROR: spaces required around that '=' (ctx:WxV)
#1500: FILE: drivers/media/video/m5mols/m5mols_core.c:892:
+	.remove		=3D m5mols_remove,
 	       		^

ERROR: spaces required around that '=' (ctx:WxV)
#1501: FILE: drivers/media/video/m5mols/m5mols_core.c:893:
+	.id_table	=3D m5mols_id,
 	         	^

WARNING: please, no space before tabs
#1672: FILE: include/media/m5mols.h:23:
+* ^I^Ito be called after enabling and before disabling$

total: 344 errors, 6 warnings, 1514 lines checked


Regards,
Sylwester
