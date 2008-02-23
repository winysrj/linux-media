Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JT2le-00042K-Aj
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 23:22:50 +0100
Message-ID: <47C09CB5.8060804@gmail.com>
Date: Sun, 24 Feb 2008 02:22:45 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Tim Hewett <tghewett1@onetel.com>
References: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
In-Reply-To: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave
 AD	SP400 rebadge)
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

Tim Hewett wrote:
> Gernot,
> 
> I have now tried the mantis tree. It also needed 
> the MANTIS_VP_1041_DVB_S2 #define to be changed to 0x0001 for this card, 
> but after doing that it was recognised:
> 

Applied the ID's to the mantis tree alongwith some other 
fixes/optimizations.
Please do test the updated mantis tree.


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
