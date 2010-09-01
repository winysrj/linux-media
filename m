Return-path: <mchehab@localhost>
Received: from web45811.mail.sp1.yahoo.com ([68.180.199.56]:48174 "HELO
	web45811.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751786Ab0IANdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Sep 2010 09:33:09 -0400
Message-ID: <934905.16227.qm@web45811.mail.sp1.yahoo.com>
References: <666098.4241.qm@web45811.mail.sp1.yahoo.com> <Pine.LNX.4.64.1008312227240.25720@axis700.grange>
Date: Wed, 1 Sep 2010 06:26:26 -0700 (PDT)
From: Poyo VL <poyo_vl@yahoo.com>
Subject: Patch drivers/media/video/mt9v022.c
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008312227240.25720@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-493678757-1283347586=:16227"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

--0-493678757-1283347586=:16227
Content-Type: text/plain; charset=us-ascii

Of course, I attached the patch. 

Thanks for your time and sorry because I didn't read the documentation. 



----- Original Message ----
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Poyo VL <poyo_vl@yahoo.com>
Sent: Tue, August 31, 2010 11:34:50 PM
Subject: Re: Patch

Hi!

On Tue, 31 Aug 2010, Poyo VL wrote:

> Kernel: 2.6.35.4
> File: include/media/v4l2-mediabus.h
> 
> Patch:
> 
> -    V4L2_MBUS_FMT_FIXED = 1,
> +    V4L2_MBUS_FMT_NO_FORMAT = 0,
> +    V4L2_MBUS_FMT_FIXED,
> 
> Added a 0 value to the v4l2_mbus_pixelcode structure, it is used on 
> drivers/media/video/mt9v022.c on line 405 in a switch(mf->code) where code 
> cannot be 0, so I get warning.
> 
> I know it is not extremly important... 

Thanks for your report and your patch! Fixing compiler warnings is 
important too, so, this does deserve a patch. However, I think, we have to 
patch not the generic code, but rather the mt9v022 driver. That "case 0:" 
has been left there by accident since the very first version, whereas it 
had to be killed a long time ago. So, the correct fix would be to just 
kill these three lines there:

-    case 0:
-        /* No format change, only geometry */
-        break;

If you like, you can submit a patch to do that. But please follow patch 
submission guidelines, as outlined in Documentation/SubmittingPatches in 
your kernel tree. And don't forget to CC the linux-media mailing list.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/



      
--0-493678757-1283347586=:16227
Content-Type: application/octet-stream; name="patch_mt9v022.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch_mt9v022.diff"

LS0tIG10OXYwMjIuYwkyMDEwLTA4LTI3IDAyOjQ3OjEyLjAwMDAwMDAwMCAr
MDMwMAorKysgbXQ5djAyMl8yLmMJMjAxMC0wOS0wMSAxNjoxMjowMC43MDQ1
MDU4NTEgKzAzMDAKQEAgLTQwMiw5ICs0MDIsNiBAQAogCQlpZiAobXQ5djAy
Mi0+bW9kZWwgIT0gVjRMMl9JREVOVF9NVDlWMDIySVg3QVRDKQogCQkJcmV0
dXJuIC1FSU5WQUw7CiAJCWJyZWFrOwotCWNhc2UgMDoKLQkJLyogTm8gZm9y
bWF0IGNoYW5nZSwgb25seSBnZW9tZXRyeSAqLwotCQlicmVhazsKIAlkZWZh
dWx0OgogCQlyZXR1cm4gLUVJTlZBTDsKIAl9Cg==

--0-493678757-1283347586=:16227--
