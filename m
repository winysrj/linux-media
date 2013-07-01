Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53401 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab3GANWJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 09:22:09 -0400
Message-ID: <51D18256.8020407@iki.fi>
Date: Mon, 01 Jul 2013 16:21:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bogdan Oprea <bogdaninedit@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com>
In-Reply-To: <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2013 09:53 AM, Bogdan Oprea wrote:
> this is a fix for this type of error
>
> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error while loading driver (-19)
> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' successfully deinitialized and disconnected
>

--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -506,6 +506,7 @@
         switch (chip_id) {
         case 0x56:
         case 0x5a:
+       case 0xff:
                 break;
         default:
                 goto err;


That does not look correct. If chip id reading is returning 0x00 or 0xff 
it is about 100% sure there is I2C communication failure.

Could you make some test and tweak it a little bit more to see what is 
problem. Does I2C read work after that or is it failing all the time?

regards
Antti


-- 
http://palosaari.fi/
