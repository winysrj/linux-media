Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48611 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab2BJQKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 11:10:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Rvt2z-0005u8-Mi
	for linux-media@vger.kernel.org; Fri, 10 Feb 2012 17:10:05 +0100
Received: from ip-88-152-164-237.unitymediagroup.de ([88.152.164.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 17:10:05 +0100
Received: from jasonjvk by ip-88-152-164-237.unitymediagroup.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 17:10:05 +0100
To: linux-media@vger.kernel.org
From: Jason Krolo <jasonjvk@aol.com>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
Date: Fri, 10 Feb 2012 16:57:21 +0100
Message-ID: <jh3ep3$bm8$1@dough.gmane.org>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com> <CAJ_iqtbzWGjLFUbMu4useGeb2739ikRYSnQCm5E4Lej1SJ-vpQ@mail.gmail.com> <CAJ_iqtY2y5+jo2rirm1LbfDHVytcnaXE5x+KuA_MD-H5N4pnwA@mail.gmail.com> <CAJ_iqtauqw0KPO19q4cc527tKv-0PW-SLoQGfb_dob4Nwv8g6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAJ_iqtauqw0KPO19q4cc527tKv-0PW-SLoQGfb_dob4Nwv8g6A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.02.2012 22:12, schrieb Torfinn Ingolfsen:
> Update:
>
> On Thu, Feb 9, 2012 at 12:04 AM, Torfinn Ingolfsen<tingox@gmail.com>  wrote:
>> Never mind. after adding this patch:
>> http://patchwork.linuxtv.org/patch/9691/
>>
>> and rebuilding the media drivers, the device is now detected:
>> tingo@kg-f4:~$ dmesg | grep -i terratec
>> [   19.755806] dvb-usb: found a 'TerraTec DTV StarBox DVB-T/C USB2.0
>> (az6007)' in warm state.
>> [   20.949045] DVB: registering new adapter (TerraTec DTV StarBox
>> DVB-T/C USB2.0 (az6007))
>> [   23.732039] Registered IR keymap rc-nec-terratec-cinergy-xs
>> [   23.732442] dvb-usb: TerraTec DTV StarBox DVB-T/C USB2.0 (az6007)
>> successfully initialized and connected.
>
> I have now tested the TerraTec H7, both with w_scan and with Kaffeine.
> Neither of then is able to find any channels from the H7. (The device
> is connected to an external power supply). However, if I connect
> another device (a PCTV nanoStick T2 290e) to the same cable, both
> w_scan and Kaffeine find all the channels for my provider, and I can
> watch the clear (unencrypted) ones in Kaffeine.
>
> How can I debug the H7 further?




Thank you for the hint to the usb-pid patch. That brought my h7 the 
first dvb pictures with linux.

We both seem to have the second revision device. My has the 0ccd:10a3 
usb-id.
w_scan and dvbscan find channels. With czap i have a signal 
(FE_HAS_LOCK) but no transport traffic. With mencoder i'm able to get an 
mpeg, which is corrupt, but there are pictures and sporadically sound, 
the device receives the dvb-c stream.
Typical mencoder statement is: skipping/duplicate frame.

I didn't test dvb-t terrestrial, but under /dev/dvb i have only one 
adapter. Is there no need for two, one for cable, another for terrestrial?


ps:
Sorry I never used a newsgroup about nttp, with this post i try to get 
access. I write from moz-thunderbird and don't know if this message will 
come through. Thanks. ;)

