Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52254 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZDHQIE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 12:08:04 -0400
Message-ID: <49DCCBDA.6080409@iki.fi>
Date: Wed, 08 Apr 2009 19:07:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marcel Jueling <Marcel.Jueling@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0
References: <200904081703.07540.Marcel.Jueling@gmx.de>
In-Reply-To: <200904081703.07540.Marcel.Jueling@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moi Marcel,
This patch is not OK.

Marcel Jueling wrote:
> +++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Tue Apr 07 00:03:36 2009 +0200
> +		.num_device_descs = 10,

Max value is 9, and  thats why you have go wrong. You should copy & 
paste whole device struct and add your device as number 1. There is now 
two structs both full with 9 devices.

regards
Antti
-- 
http://palosaari.fi/
