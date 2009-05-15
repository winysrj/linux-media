Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41142 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZEONl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 09:41:28 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate03.web.de (Postfix) with ESMTP id 0AEDEFC84911
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 15:41:29 +0200 (CEST)
Received: from [93.192.144.226] (helo=[192.168.0.103])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1M4xfE-0006mY-00
	for linux-media@vger.kernel.org; Fri, 15 May 2009 15:41:28 +0200
Message-ID: <4A0D7106.2030702@web.de>
Date: Fri, 15 May 2009 15:41:26 +0200
From: Reinhard Katzmann <suamor@web.de>
MIME-Version: 1.0
To: gspca list <linux-media@vger.kernel.org>
Subject: Re: [GSPCA] Driver Development for Speed Link VAD Laplace
References: <4A031BE8.2080900@web.de> <62e5edd40905071238l3bc3a154g8247e5e4399a068b@mail.gmail.com>
In-Reply-To: <62e5edd40905071238l3bc3a154g8247e5e4399a068b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Erik,

Erik Andrén wrote:
>> I have searched for some more hardware information than from the vendor
>> available but in vain (though the cam is about 1 year old already).
>> I know that especially the video format the webcam delivers would be
>> important to know for driver development.
>>
>> If there are any (freeware) tools available except those USB sniffers to
>> find out any more hardware details please let me know, so I can help
>> with the driver.
>>
>
> Hi,
> If possible, you can open the case and inspect what chips that are inside.
> That should give you a head start.
>

Thanks for the hint. It was a bit difficult but with the help of my
friends we managed to open the CAM without any visible harm and got
the following chip information:

Main chip (Large)

EMPIA EM2765
6Z523-500
0711-118G

Little chips
IDT
STAC9753AX
MPG
E10745Z
UT10953

I also updated the wiki and included some pics.
http://linuxtv.org/wiki/index.php/VAD_Laplace

Regards,

Reinhard
-- 
Software-Engineer, Developer of User Interfaces
Project: Canorus - the next generation music score editor - 
http://canorus.berlios.de
GnuPG Public Key available on request


