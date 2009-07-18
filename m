Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:54856 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZGRPT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 11:19:58 -0400
Received: by rv-out-0506.google.com with SMTP id f6so385497rvb.1
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 08:19:58 -0700 (PDT)
Message-ID: <4A61E816.8040908@gmail.com>
Date: Sat, 18 Jul 2009 11:19:50 -0400
From: Brian Johnson <brijohn@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/2] gspca sn9c20x subdriver rev2
References: <1247863903-22125-1-git-send-email-brijohn@gmail.com> <20090718103522.18b87d68@free.fr>
In-Reply-To: <20090718103522.18b87d68@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> - in the 1st patch, in gspca.c, why is the get_chip_ident check needed
>   in vidioc_g_register / vidioc_s_register)?
> 
According the the current v4l2 spec regarding the set and get
register ioctls drivers that support them must also support the get
chip ident ioctl. As such in the vidioc_s/g_register ioctls I do the
check to ensure that the driver also defines the get_chip_ident ioctl.


Brian Johnson
