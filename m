Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59742 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbbLUMf5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 07:35:57 -0500
Subject: Re: [PATCH 1/2] [media] media-device: move media entity
 register/unregister functions
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5677F223.50402@osg.samsung.com>
Date: Mon, 21 Dec 2015 09:35:47 -0300
MIME-Version: 1.0
In-Reply-To: <2875b74a677adc2cd9fc11ba054654caf01e4a18.1450176187.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/15/2015 07:43 AM, Mauro Carvalho Chehab wrote:
> media entity register and unregister functions are called by media
> device register/unregister. Move them to occur earlier, as we'll need
> an unlocked version of media_device_entity_unregister() and we don't
> want to add a function prototype without needing it.
> 
> No functional changes.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
