Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1L3cmk-0003vT-OB
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 21:39:27 +0100
Message-ID: <49271C77.6090009@gmail.com>
Date: Sat, 22 Nov 2008 00:39:19 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: CityK <cityk@rogers.com>
References: <20081115234054.0cc58cbb@symphony> <49206686.1080209@rogers.com>
In-Reply-To: <49206686.1080209@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SAA7162 status
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

CityK wrote:
> James Le Cuirot wrote:
>> Hi guys,
>>
>> Any news on SAA7162? I know this is asked fairly often but it's been a
>> couple of months since the last update. I did read that NXP are trying
>> to gauge the amount of user interest. Well here is one Linux user who
>> would buy such a card very soon if a working driver became available. I
>> am also pondering about DVB-S2/T2 but I guess DVB-S/T isn't going away
>> in the UK just yet. :)
>>
>>   
> 
> Best I can give you is this:
> http://marc.info/?l=linux-video&m=122662096530211&w=2


The SAA716x driver is supposed to support the following PCIe chips

SAA7160
SAA7161
SAA7162

The SAA716x development repository is at http://jusst.de/hg/saa716x
It is quite a work in progress, as of now. There are also some DVB-S2
cards based on the SAA7160.

Also, the SAA7164 chip is not supported by the SAA716x driver as it is a
completely different chip altogether.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
