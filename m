Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:42420 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZHaGhi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 02:37:38 -0400
Date: Mon, 31 Aug 2009 08:37:31 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090831083731.5c08d3ec@tele>
In-Reply-To: <20090831023331.3dd6f6b9@pedra.chehab.org>
References: <20090831023331.3dd6f6b9@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 Aug 2009 02:33:31 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> for_linus
> 
> For the following fixes:
> 
>    - fixes detection of cameras with MT9M111 on em28xx;
>    - fixes LNA and LED with Hauppauge devices on sms1xx;
>    - fixes SDIO compilation on Siano;
>    - zr364: fix wrong indexes;
>    - em28xx: Don't call em28xx_ir_init when IR is disabled;
>    - gspca - sn9c20x: Fix gscpa sn9c20x build errors;
>    - usb_af9015: fix an Oops on hotplugging with 2.6.31-rc5-git3;
>    - MAINTAINERS: Update gspca sn9c20x name style.

Hi Mauro,

I'd be glad to have the other high priority changeset in the new kernel
(gspca - sonixj: Do the ov7660 sensor work again). Is it possible?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
