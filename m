Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f198.google.com ([209.85.221.198]:36251 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbZGSD3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 23:29:04 -0400
Received: by qyk36 with SMTP id 36so288946qyk.33
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 20:29:03 -0700 (PDT)
Message-ID: <4A6291C6.1090507@gmail.com>
Date: Sat, 18 Jul 2009 23:23:50 -0400
From: Brian Johnson <brijohn@gmail.com>
MIME-Version: 1.0
To: leandro Costantino <lcostantino@gmail.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/2] gspca sn9c20x subdriver rev2
References: <1247863903-22125-1-git-send-email-brijohn@gmail.com>	 <20090718103522.18b87d68@free.fr> <4A61E816.8040908@gmail.com> <c2fe070d0907181345x7e8fae62rd3ba3d47f75e3dbb@mail.gmail.com>
In-Reply-To: <c2fe070d0907181345x7e8fae62rd3ba3d47f75e3dbb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> shouldn't there be a check when allocating jpg_hdr? or i am missing something?
> 
> 
>  sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
>  jpeg_define(sd->jpeg_hdr, height, width,  0x21);
>  jpeg_set_qual(sd->jpeg_hdr, sd->quality);

Yes probably there should be a check there. I'll one more minor
revision with this plus the changes Jean-Francois mentioned
previously in a bit.

Brian Johnson
