Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56401 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZDULbj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 07:31:39 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LwECO-0001hX-4L
	for linux-media@vger.kernel.org; Tue, 21 Apr 2009 11:31:36 +0000
Received: from 41.226.123.118 ([41.226.123.118])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 21 Apr 2009 11:31:36 +0000
Received: from nizar.saied by 41.226.123.118 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 21 Apr 2009 11:31:36 +0000
To: linux-media@vger.kernel.org
From: nizar <nizar.saied@gmail.com>
Subject: Re: [linux-dvb] technisat skystar usb 2.0
Date: Tue, 21 Apr 2009 12:32:56 +0200
Message-ID: <gskaq4$s1$1@ger.gmane.org>
References: <grverg$k26$1@ger.gmane.org> <200904151251.09812.railis@juvepoland.com>
Reply-To: nizar.saied@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <200904151251.09812.railis@juvepoland.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dominik Sito wrote:
> Monday 13 April 2009 17:31:29 nizar napisał(a):
>> Please help needed.
>> I have skystar usb 2.0 (13d0:2282) i have also the log of usbsnoop 
> (300
>> Mo) .
>> What are steps to :
>>
>> 1- know if a firmware is needed.
>> 2- if yes how to extract it.
>>
>>
>> thank you
>> Nizar
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-
> media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> Just give `lspci -vvv` and `lsusb -vvv` result.
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Dominik
I have send the lspci and lsusb.
I think that b2c2-flexcop-usb.c dont handle usb2.0
So if I suppose that the frontend is the same as those of skystar 2 pci
the main tasks are :
-1- Find the firmware of the pci-to-usb controller (Net ship 2282)
-2- Change the b2c2-flexcop-usb.c to work with usb2.0 (bulk urb).

result :

-1- ====> Try to extract the firmware from the usbsnoop.log
-2- ====> Not too hard.I trying to write b2c2-flexcop-usb2.c

Thank you.
Nizar Saied

