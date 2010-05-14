Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34135 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0ENRQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 13:16:49 -0400
Message-ID: <4BED857A.9050203@iki.fi>
Date: Fri, 14 May 2010 20:16:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: marc balta <marc_balta@yahoo.de>
CC: linux-media@vger.kernel.org
Subject: Re: Stuck Digittrade DVB-T stick (dvb_usb_af9015)
References: <136728.15951.qm@web27805.mail.ukl.yahoo.com>
In-Reply-To: <136728.15951.qm@web27805.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve

On 05/14/2010 02:17 PM, marc balta wrote:
> would be nice because it is happening rather often : Every second or third day. Is there a way to reinit the device with a script wihtout restarting my server and without influencing other usb devices. If yes I could reinit the device say two minutes before every recording starts using a hook. This would solve my problems.

I just added support for new firmware 5.1.0.0. Please test if it helps.
http://linuxtv.org/hg/~anttip/af9015/
http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/

regards
Antti
-- 
http://palosaari.fi/
