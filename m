Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752646AbeGBQjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 12:39:05 -0400
Subject: Re: linux-next: Tree for Jul 2 (media/pci/meye/)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20180702145158.10190101@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c38838a6-5582-6b33-5b6b-8938cfdce571@infradead.org>
Date: Mon, 2 Jul 2018 09:39:02 -0700
MIME-Version: 1.0
In-Reply-To: <20180702145158.10190101@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/18 21:51, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20180629:
> 

on x86_64:

drivers/media/pci/meye/meye.o: In function `meye_s_ctrl':
meye.c:(.text+0x710): undefined reference to `sony_pic_camera_command'
meye.c:(.text+0x736): undefined reference to `sony_pic_camera_command'
meye.c:(.text+0x75c): undefined reference to `sony_pic_camera_command'
meye.c:(.text+0x782): undefined reference to `sony_pic_camera_command'
meye.c:(.text+0x7a8): undefined reference to `sony_pic_camera_command'

when
CONFIG_SONY_LAPTOP=m
CONFIG_VIDEO_MEYE=y
CONFIG_COMPILE_TEST=y


-- 
~Randy
