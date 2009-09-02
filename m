Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57329 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbZIBWDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 18:03:30 -0400
Message-ID: <4A9EEBB2.60709@iki.fi>
Date: Thu, 03 Sep 2009 01:03:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Morvan Le Meut <mlemeut@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: (EC168) PC Basic TNT USB Basic V5 ( France ) recognized but no
 channel tuning
References: <4A9EC8B3.10904@gmail.com>
In-Reply-To: <4A9EC8B3.10904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2009 10:34 PM, Morvan Le Meut wrote:
> I've just bough that and it seems that the EC168 driver can't work with
> it ( yet )
> The PCB identifies itself as a ForwardVideo "EzTV818_D.". Work with a
> EC168 and a MXL5003S ( no doubt about it, but it is barely legible, and
> since i've no camera, no PCB picture available ). ( and the EC168BDA.bin
> firmware is provided on the CD )

Did you used the firmware from the CD? It will not work because it does 
not have "warm" USB ID, it is all zero and due to that device will 
disappear from driver perspective.
You should use that firmware:
http://palosaari.fi/linux/v4l-dvb/firmware/ec168/

Antti
-- 
http://palosaari.fi/
