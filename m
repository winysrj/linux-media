Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:44760 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbZGRIep (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 04:34:45 -0400
Date: Sat, 18 Jul 2009 10:35:22 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Brian Johnson <brijohn@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/2] gspca sn9c20x subdriver rev2
Message-ID: <20090718103522.18b87d68@free.fr>
In-Reply-To: <1247863903-22125-1-git-send-email-brijohn@gmail.com>
References: <1247863903-22125-1-git-send-email-brijohn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Jul 2009 16:51:41 -0400
Brian Johnson <brijohn@gmail.com> wrote:

> Mauro,
> Here is the updated version of the gspca sn9c20x subdriver.
> 
> I've removed the custom debugging support and replaced it with support
> for the v4l2 debugging ioctls. The first patch in this set adds
> support to the gspca core for those ioctls. Also included are the
> fixes Hans sent in his last email.
> 
> Regards,
> Brian Johnson

Hello Brian and Mauro,

Thanks, Brian. I have just a few remarks:

- in the 1st patch, in gspca.c, why is the get_chip_ident check needed
  in vidioc_g_register / vidioc_s_register)?

- in the 1st patch, in gspca.h, the operations set/get_register in
  the sd descriptor should not exist if not CONFIG_VIDEO_ADV_DEBUG.

- in the 2nd patch, I would have preferred hexadecimal letters in lower
  case.

- in the 2nd patch, the list of the new handled webcams
  (linux/Documentation/video4linux/gspca.txt) is lacking.

Anyway, this is not important and may be done later.

So, Mauro, if it is OK for you (don't confirm), I will handle these
patch series.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
