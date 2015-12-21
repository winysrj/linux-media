Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59748 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbLUMjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 07:39:02 -0500
Subject: Re: [PATCH 2/2] [media] media-device: better lock
 media_device_unregister()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
 <cda0486f763fc1c2f5267c3a0806cf297317301b.1450176187.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5677F2E0.2010503@osg.samsung.com>
Date: Mon, 21 Dec 2015 09:38:56 -0300
MIME-Version: 1.0
In-Reply-To: <cda0486f763fc1c2f5267c3a0806cf297317301b.1450176187.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/15/2015 07:43 AM, Mauro Carvalho Chehab wrote:
> If media_device_unregister() is called by two different
> drivers, a race condition may happen, as the check if the
> device is not registered is not protected.
> 
> Move the spin_lock() to happen earlier in the function, in order
> to prevent such race condition.
> 
> Reported-by: Shuah Khan <shuahkh@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---

The patch looks good and I also tested it on an OMAP3 IGEPv2 board:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
