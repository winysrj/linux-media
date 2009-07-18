Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f182.google.com ([209.85.212.182]:41172 "EHLO
	mail-vw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZGRUvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 16:51:08 -0400
Received: by vwj12 with SMTP id 12so27358vwj.33
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 13:51:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A61E816.8040908@gmail.com>
References: <1247863903-22125-1-git-send-email-brijohn@gmail.com>
	 <20090718103522.18b87d68@free.fr> <4A61E816.8040908@gmail.com>
Date: Sat, 18 Jul 2009 16:45:29 -0400
Message-ID: <c2fe070d0907181345x7e8fae62rd3ba3d47f75e3dbb@mail.gmail.com>
Subject: Re: [PATCH 0/2] gspca sn9c20x subdriver rev2
From: leandro Costantino <lcostantino@gmail.com>
To: Brian Johnson <brijohn@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
shouldn't there be a check when allocating jpg_hdr? or i am missing something?


 sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
 jpeg_define(sd->jpeg_hdr, height, width,  0x21);
 jpeg_set_qual(sd->jpeg_hdr, sd->quality);

Best Regards.
Nice to see microdia project here :)


On Sat, Jul 18, 2009 at 11:19 AM, Brian Johnson<brijohn@gmail.com> wrote:
>> - in the 1st patch, in gspca.c, why is the get_chip_ident check needed
>>   in vidioc_g_register / vidioc_s_register)?
>>
> According the the current v4l2 spec regarding the set and get
> register ioctls drivers that support them must also support the get
> chip ident ioctl. As such in the vidioc_s/g_register ioctls I do the
> check to ensure that the driver also defines the get_chip_ident ioctl.
>
>
> Brian Johnson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
