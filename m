Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63083 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407Ab3E3Ra3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 13:30:29 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MIBlI-1Uie7B3qDm-003rTa for
 <linux-media@vger.kernel.org>; Thu, 30 May 2013 19:30:27 +0200
Message-ID: <51A78CA5.5040502@gmx.de>
Date: Thu, 30 May 2013 19:30:13 +0200
From: Torsten Seyffarth <t.seyffarth@gmx.de>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Cinergy TStick RC rev.3 (rtl2832u) only 4 programs
References: <51A73A88.9000601@gmx.de> <51A76FCA.3010803@gmail.com>
In-Reply-To: <51A76FCA.3010803@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.05.2013 17:27, schrieb poma:
> On 30.05.2013 13:39, Torsten Seyffarth wrote:
> …
>
>> After a hard disk crash I had to install my system anyway so I switched
>> to OpenSUSE 12.3 with a 3.7 Kernel, because this should support the
>> rtl2832u directly.
>> Basically this is working. The Stick is detected:
> …
>
>> These kernel moduls are loaded:
>> rtl2832                18542  1
>> dvb_usb_rtl28xxu       28608  0
>> dvb_usb_v2             34564  2 dvb_usb_af9015,dvb_usb_rtl28xxu
>> rc_core                30555  4 dvb_usb_af9015,dvb_usb_rtl28xxu,dvb_usb_v2
>> rtl2830                18316  1 dvb_usb_rtl28xxu
>> dvb_core              109206  3 rtl2832,dvb_usb_v2,rtl2830
> e4000!? :)
>
>> The problem is, that only four DVB-T programs on one transponder can be
>> received, but these in a very good quality. It should be around 20
>> programs. I tested this with MythTV and Kaffeine and both only find the
>> same 4 programs. With a Windows 7 PC and the antenna on the same
>> position I get all programs in good quality. So I do not think the stick
>> is broken or the quality of the antenna signal is the problem.
>>
>> Has anyone an idea?
> http://www.spinics.net/lists/linux-media/msg58249.html
> Besides for testing purposes, it is recommended to use at least the last
> stable stable kernel[1] e.g. 3.9.4-200.fc18.x86_64. :)
> In addition, you can update the media modules via instructions - readme
> at linuxtv.org[2].
>
>
> poma
>
>
> [1] https://www.kernel.org/
> [1] http://git.linuxtv.org/media_build.git
>
>
Thanks for the answer so far.
I actually updated the media modules from git but this didn't help. 
Messing around with the kernel is nothing I feel very comfortable with, 
yet. ;-)
But if I understand the linked discussion correctly it wouldn't help 
anyway. According to that the tuner is the problem and there is no 
solution at the moment. What I do not understand is, why did it work 
with the older kernel and the Ambrosa driver? Does it include a 
different driver for the e4000?

Best
Torsten



