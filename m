Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lionteeth@cogweb.net>) id 1PpZNi-00067g-BN
	for linux-dvb@linuxtv.org; Wed, 16 Feb 2011 05:52:50 +0100
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1PpZNh-0006G3-8g; Wed, 16 Feb 2011 05:52:50 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id p1G4qi9Y017919
	for <linux-dvb@linuxtv.org>; Tue, 15 Feb 2011 20:52:44 -0800
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id cobqIRtMTee9 for <linux-dvb@linuxtv.org>;
	Tue, 15 Feb 2011 20:52:39 -0800 (PST)
Received: from smtp5.sscnet.ucla.edu (smtp5.sscnet.ucla.edu [128.97.229.235])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id p1G4qbNq017916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Tue, 15 Feb 2011 20:52:37 -0800
Received: from weber.sscnet.ucla.edu (weber.sscnet.ucla.edu [128.97.42.3])
	by smtp5.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id p1G4qRAn015175
	for <linux-dvb@linuxtv.org>; Tue, 15 Feb 2011 20:52:28 -0800
Received: from [128.97.245.111] (vpn-8061f56f.host.ucla.edu [128.97.245.111])
	by weber.sscnet.ucla.edu (8.14.2/8.14.2) with ESMTP id p1G4qPSr025900
	for <linux-dvb@linuxtv.org>; Tue, 15 Feb 2011 20:52:26 -0800 (PST)
Message-ID: <4D5B5807.2060904@cogweb.net>
Date: Tue, 15 Feb 2011 20:52:23 -0800
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <AANLkTi=WT6cAwhmhggWfabWjaJHbjHoHSfLBuNdmp2Hi@mail.gmail.com>
In-Reply-To: <AANLkTi=WT6cAwhmhggWfabWjaJHbjHoHSfLBuNdmp2Hi@mail.gmail.com>
Subject: Re: [linux-dvb] requesting firmware
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

On 02/13/2011 10:41 AM, Josu Lazkano wrote:
> Hello, I sometimes had these message on dmesg:
>
> [   46.592313] ds3000_firmware_ondemand: Waiting for firmware upload
> (dvb-fe-ds3000.fw)...
> [   46.592326] cx23885 0000:02:00.0: firmware: requesting dvb-fe-ds3000.fw
> [   46.675035] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
>
>
> The firmware is on the correct folder:
>
> # ls -l /lib/firmware/ | grep ds3000
> -rw-r--r-- 1 root root  8192 dic  6 14:54 dvb-fe-ds3000.fw
>
> What is happening? Is this normal?
Does the card work? I see this sort of thing for a different card:

or51132: Waiting for firmware upload(dvb-fe-or51132-qam.fw)...
or51132: Version: 10001334-17430000 (133-4-174-3)
or51132: Firmware upload complete.

Dave

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
