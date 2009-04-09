Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43633 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763111AbZDIUf1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2009 16:35:27 -0400
Message-ID: <49DE5C08.5080909@iki.fi>
Date: Thu, 09 Apr 2009 23:35:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marcel Jueling <Marcel.Jueling@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0
References: <200904081703.07540.Marcel.Jueling@gmx.de> <49DCCBDA.6080409@iki.fi>
In-Reply-To: <49DCCBDA.6080409@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
> moi Marcel,
> This patch is not OK.
> 
> Marcel Jueling wrote:
>> +++ b/linux/drivers/media/dvb/dvb-usb/af9015.c    Tue Apr 07 00:03:36 
>> 2009 +0200
>> +        .num_device_descs = 10,
> 
> Max value is 9, and  thats why you have go wrong. You should copy & 
> paste whole device struct and add your device as number 1. There is now 
> two structs both full with 9 devices.

Fixed and device is working, will pull request to the master soon.
http://linuxtv.org/hg/~anttip/af9015

Many thanks Marcel!

regards
Antti
-- 
http://palosaari.fi/
