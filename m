Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45182 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0GGAG2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jul 2010 20:06:28 -0400
Message-ID: <4C33BBEA.5000807@iki.fi>
Date: Wed, 07 Jul 2010 02:27:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Nikola Pajkovsky <npajkovs@redhat.com>
Subject: Re: Status of the patches under review at LMML (60 patches)
References: <4C332A5F.4000706@redhat.com>
In-Reply-To: <4C332A5F.4000706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2010 04:06 PM, Mauro Carvalho Chehab wrote:
> This is the summary of the patches that are currently under review at
> Linux Media Mailing List<linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>
> P.S.: This email is c/c to the developers where some action is expected.
>        If you were copied, please review the patches, acking/nacking or
>        submitting an update.
>

> 		== Waiting for Antti Palosaari<crope@iki.fi>  review ==
>
> Mar,21 2010: af9015 : more robust eeprom parsing                                    http://patchwork.kernel.org/patch/87243

NACK, partly. I think it is rather useless.


> May,20 2010: New NXP tda18218 tuner                                                 http://patchwork.kernel.org/patch/101170

AF9015/AF9013: ACK, partly from the AF9015/AF9013 side. It is safe to 
merge, it will not break any currently supported device. But I am not 
sure if all settings are correct since I don't have suitable device 
(AF9015+TDA18218) to figure out configuration and test.

TDA18218: I don't know. I have reviewed it, feedback can be found from 
the patchwork. I don't resist to merge, but also I don't want to take 
any responsibility since I don't have this device.

regards
Antti
-- 
http://palosaari.fi/
