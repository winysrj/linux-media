Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35459 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965252Ab2EOPlg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 11:41:36 -0400
Message-ID: <4FB2792D.4040100@iki.fi>
Date: Tue, 15 May 2012 18:41:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rtl2832 ver 0.3: suport for RTL2832 demodulator revised
 version
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com> <1336846109-30070-2-git-send-email-thomas.mair86@googlemail.com> <4FB061C2.90006@iki.fi>
In-Reply-To: <4FB061C2.90006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.05.2012 04:37, Antti Palosaari wrote:
> On 12.05.2012 21:08, Thomas Mair wrote:
>> Changes compared to version 0.2:

>> +++ b/drivers/media/dvb/frontends/Makefile
>> @@ -98,6 +98,7 @@ obj-$(CONFIG_DVB_IT913X_FE) += it913x-fe.o
>> obj-$(CONFIG_DVB_A8293) += a8293.o
>> obj-$(CONFIG_DVB_TDA10071) += tda10071.o
>> obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
>> +obj-$(CONFIG_DVB_RTL2832) = rtl2832.o
>> obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
>> obj-$(CONFIG_DVB_AF9033) += af9033.o

I just realized that very bad bug! That prevents compilation of all the 
other demods than rtl2832.

regards
Antti
-- 
http://palosaari.fi/
