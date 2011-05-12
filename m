Return-path: <mchehab@gaivota>
Received: from mail.kapsi.fi ([217.30.184.167]:34881 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573Ab1ELOIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 10:08:54 -0400
Message-ID: <4DCBE9F3.2090209@iki.fi>
Date: Thu, 12 May 2011 17:08:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Per Kofod <per.s.kofod@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Help needed: Anysee E30C Plus (DVB-C Tuner)
References: <4DCBE059.8030906@gmail.com>
In-Reply-To: <4DCBE059.8030906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/12/2011 04:27 PM, Per Kofod wrote:
> Hi
>
> I am new to this mailing list, so bare with me if this have been asked
> before.
>
> I have just bought an Anysee E30C Plus, as I had read, that this device
> is supported
> in Linux, my plan is building a Mythtv media center, to replace my old
> harddisk recorder.
>
> However I cannot get it to work, and then I read thatt the newest
> version might not work,
> and that I should join this list.
>
> I have tried to compile a new kernel with the newest dvb stuff from the
> git repository, just
> to make sure, that I have the newest drivers. I have alsio blacklistet
> the zl10353 module
> to avoid the device being loaded as an DVB-T device (which it is not, it
> is a cable only version).
>
> What information do you need me to obtain, or do you have a hint to how
> I might get this working?
>
> The device is reconnized OK as seen here from dmesg:
>
> [ 11.354973] dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
> [ 11.355004] dvb-usb: will pass the complete MPEG2 transport stream to
> the software demuxer.
> [ 11.355239] DVB: registering new adapter (Anysee DVB USB2.0)
> [ 11.356661] anysee: firmware version:0.1.2 hardware id:15


For the some reason hardware ID 15 does not work on latest Ubuntu 11.04. 
That is basically E30 Combo Plus and newer E30 C Plus, which is same 
device as E30 Combo Plus but without DVB-T demod.

Install latest drivers and it will work. And I hope someone have time to 
examine why it does not work anymore out-of-the-box in Ubuntu 11.04.

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers


Antti

-- 
http://palosaari.fi/
