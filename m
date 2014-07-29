Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54337 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaG2Fpe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 01:45:34 -0400
Message-ID: <53D734F9.6060201@gentoo.org>
Date: Tue, 29 Jul 2014 07:45:29 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] mceusb: select default keytable based on vendor
References: <1406494020-12840-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406494020-12840-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.07.2014 22:47, Mauro Carvalho Chehab wrote:
> Some vendors have their on keymap table that are used on
> all (or almost all) models for that vendor.
> 
> So, instead of specifying the keymap table per USB ID,
> let's use the Vendor ID's table by default.
> 
> At the end, this will mean less code to be added when newer
> devices for those vendors are added.
> 

I also did prepare something to add mceusb support, but with this only
vendor dependant rc_map selection, it definitly is less code.

Your mceusb patches work correctly for my 930C-HD (b130) and PCTV 522e
devices.

Regards
Matthias

