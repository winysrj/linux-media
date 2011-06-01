Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1FAL3e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 07:29:34 -0400
Message-ID: <4DE62298.70808@redhat.com>
Date: Wed, 01 Jun 2011 08:29:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
References: <20110523112054.4d8b29ef@tele>
In-Reply-To: <20110523112054.4d8b29ef@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 06:20, Jean-Francois Moine escreveu:
> The following changes since commit
> 87cf028f3aa1ed51fe29c36df548aa714dc7438f:
> 
>   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_v2.6.40
> 
> Jean-François Moine (6):
>       gspca - ov519: Fix a regression for ovfx2 webcams
>       gspca - ov519: Change the ovfx2 bulk transfer size
>       gspca: Remove coarse_expo_autogain.h
>       gspca - stv06xx: Set a lower default value of gain for hdcs sensors
>       gspca - ov519: Set the default frame rate to 15 fps

The above seems to be bug fixes. So, I'm adding them for the current
version (Linux 3.0).

>       gspca - ov519: New sensor ov9600 with bridge ovfx2

This one is a new feature. Adding it for -next.

All patches added.

Thanks,
Mauro
