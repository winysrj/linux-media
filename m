Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:64179 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1BHEE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 23:04:28 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LGA004575XX4XB0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Feb 2011 13:03:33 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LGA001EY5XXMH@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Feb 2011 13:03:33 +0900 (KST)
Date: Tue, 08 Feb 2011 13:03:33 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [PATCH v4] Add support for M5MO-LS 8 Mega Pixel camera
In-reply-to: <4D5067E4.2030709@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	s.nawrocki@samsung.com, kyungmin.park@samsung.com
Reply-to: riverful.kim@samsung.com
Message-id: <4D50C095.5060502@samsung.com>
Content-transfer-encoding: 8BIT
References: <1297079073-10916-1-git-send-email-riverful.kim@samsung.com>
 <4D5067E4.2030709@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've checked runnig checkpatch.pl, but I've not seen this message before.
And I re-check the patch sent now, but it's not.
Probably, It's issue between git send-email and our mail server setting.

I'll check once again, and resend.

Thanks let me know.

Regards
Heungjun Kim



2011-02-08 오전 6:45, Sylwester Nawrocki 쓴 글:
> Hi HeungJun,
> 
> On 02/07/2011 12:44 PM, Heungjun Kim wrote:
>> Add I2C/V4L2 subdev driver for M5MO-LS camera sensor with integrated
>> image processor.
>>
> 
> There is something wrong with this patch. It looks like it got mangled by
> the mailer. I can see some Korean characters in it and checkpatch.pl 
> returns errors:
> 
> ERROR: patch seems to be corrupt (line wrapped?)
> #122: FILE: drivers/media/video/Kconfig:747:
> =20
> 
> ERROR: spaces required around that '=' (ctx:WxV)
> #208: FILE: drivers/media/video/m5mols/m5mols.h:36:
> +	I2C_8BIT	=3D 1,
>  	        	^
> 
> ERROR: spaces required around that '=' (ctx:WxV)
> #209: FILE: drivers/media/video/m5mols/m5mols.h:37:
> +	I2C_16BIT	=3D 2,
>  	         	^
> 
> ERROR: spaces required around that '=' (ctx:WxV)
> #210: FILE: drivers/media/video/m5mols/m5mols.h:38:
> +	I2C_32BIT	=3D 4,
>  	         	^
> ...
> 
> ERROR: spaces required around that '=' (ctx:WxV)
> #1500: FILE: drivers/media/video/m5mols/m5mols_core.c:892:
> +	.remove		=3D m5mols_remove,
>  	       		^
> 
> ERROR: spaces required around that '=' (ctx:WxV)
> #1501: FILE: drivers/media/video/m5mols/m5mols_core.c:893:
> +	.id_table	=3D m5mols_id,
>  	         	^
> 
> WARNING: please, no space before tabs
> #1672: FILE: include/media/m5mols.h:23:
> +* ^I^Ito be called after enabling and before disabling$
> 
> total: 344 errors, 6 warnings, 1514 lines checked
> 
> 
> Regards,
> Sylwester
> 

