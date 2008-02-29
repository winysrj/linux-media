Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hireach@internode.on.net>) id 1JV368-0006Z1-P6
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 12:08:17 +0100
Message-ID: <9CDFD69CC192413F8B55C0FD5EB61E11@LaptopPC>
From: "Martin Thompson" <hireach@internode.on.net>
To: <linux-dvb@linuxtv.org>
References: <9FC6541BF8D049BB839E9F30F5258D64@LaptopPC>	
	<47C67A3C.6050602@shikadi.net>	
	<99BC16843B464C4C9081D5DF5DDA98BE@LaptopPC>	
	<47C69404.3040504@shikadi.net>
	<9e5f3ed00802281124g7b19a8f2ge869f6d2968655e5@mail.gmail.com>
	<47C71B38.6040908@shikadi.net>
In-Reply-To: <47C71B38.6040908@shikadi.net>
Date: Fri, 29 Feb 2008 22:08:06 +1100
MIME-Version: 1.0
Subject: Re: [linux-dvb] dvico dual digital 4 revision 2.0
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

well it looks like i could be stuffed
just found the new windows driver and they call it a dual 5

heres a snip of the driver.inf

%AvsBluebird.DVBT_Dual.DeviceDesc%     =Bluebird2.DVBT_NANO2, 
USB\VID_0FE9&PID_DB78      ; DUAL4 (XC3028+Zarlink)
%AvsBluebird.DVBT_Hawk1.DeviceDesc%    =Bluebird2.DVBT_HAWK1, 
USB\VID_0FE9&PID_DB80      ; Firehawk1 (DNOS504Z)
%AvsBluebird.DVBT_Dual5.DeviceDesc%    =Bluebird2.DVBT_NANO_DIB1, 
USB\VID_0FE9&PID_DB98      ; DUAL5 (DIB7070PA x 2)
note Dual 5  thats my card

link to driver
ftp://ftp.dvico.com/Products/FusionHDTV/Down/FusionHDTV3.66.01Web.exe

looks like we could  be stuffed


----- Original Message ----- 
From: "Adam Nielsen" <a.nielsen@shikadi.net>
To: "Martin Thompson" <mandm.thompson@gmail.com>
Sent: Friday, February 29, 2008 7:36 AM
Subject: Re: [linux-dvb] dvico dual digital 4 revision 2.0


>> if i change the id in the usb id file the it finds it and loads
>> the card apperas as a dvb 0, 1
>> but dmeg shows frontend not loaded
> 
> That sounds like you haven't changed the USB IDs in the firmware loading
> code - presumably it uses the IDs to figure out which firmware files to
> load, and if it doesn't know about the IDs it doesn't even try to load
> any firmware.
> 
> I think you need to figure out how to force it to load some firmware
> files before you can get any further.
> 
> Cheers,
> Adam.
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
