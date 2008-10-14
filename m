Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from node03.cambriumhosting.nl ([217.19.16.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1KplTq-0004uN-7A
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 17:06:41 +0200
Message-ID: <48F4B576.8010509@powercraft.nl>
Date: Tue, 14 Oct 2008 17:06:30 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <48F48920.1000206@powercraft.nl> <48F48F67.2020802@powercraft.nl>
	<48F4A5D9.7010701@powercraft.nl> <48F4B25B.9070109@iki.fi>
In-Reply-To: <48F4B25B.9070109@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Afatech DVB-T - Installation Guide - v0.1.1j (not
 working)
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

Antti Palosaari wrote:
> hello Jelle,
> sorry for top-posting...
> 
> Error from attached file:
> 
> [   57.163981] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
> [   57.277990] af9015: command failed:2
> [   57.278001] mt2060 I2C read failed
> 
> goes to the fact that I2C-communication towards tuner is behind I2C-gate 
> of the AF9015/AF9013. MT2060 you use does not have I2C-gate implemented. 
> Use newer MT2060 module for correct functionality.
> 
> See for more information:
> http://palosaari.fi/linux/v4l-dvb/controlling_tuner.txt
> http://palosaari.fi/linux/v4l-dvb/controlling_tuner_af9015_dual_demod.txt
> 
> reagrds
> Antti

Thanks for the information, since one of my specializations is embedded
hardware development, I do understand the presented issues.

Should there not be an option to the MT2060 module to use the I2C-gate
or not? What can I do to get this device working now?

> 
> Jelle de Jong wrote:
> Jelle de Jong wrote:
>>>> Jelle de Jong wrote:
>>>>> Hello everybody,
>>>>>
>>>>> I bought an other usb dvb-t stick (number 5) with the hope it would work
>>>>> out of the box under Debian Linux Sid because I could not efficiently
>>>>> maintain all the custom build drivers on my systems.
>>>>>
>>>>> The distributer, tried to create something that would work on Linux but
>>>>> he kind of missed the point of Linux sustainable driver model. There was
>>>>> an cdrom included with an "autoself" installation script. That tried to
>>>>> heavily rape my debian box..
>>>>>
>>>>> http://filebin.ca/rydcgt/treiber.tar.gz
>>>>>
>>>>> I would like to know if this device can work out of the box? and if not
>>>>> what is needed to get the device working out of the box?
>>>>>
>>>>> See the attachment for the device information. If more information is
>>>>> needed please tell me how to gather it.
>>>>>
>>>>> Best regards,
>>>>>
>>>>> Jelle
>>>> I found some additional information, but all my above questions remain
>>>> the same.
>>>>
>>>> http://openlab.savonia-amk.fi/wiki/index.php/Afatech_9016_DVB-T_USB
>>>>
>>>> Best regards,
>>>>
>>>> Jelle
>>>>
> Hello everybody,
> 
> Even while the device does not yet work out of the box and I don't know
> why this is the case, i tried to get the device working. I created some
> documentation of my steps, but the device refuses to find any dvb-t
> signals, while I am sure there are there.
> 
> Please see the attachment for far more detailed information.
> 
> Any help is really appreciated.
> 
> Kind regards,
> 
> Jelle
>>
>>
------------------------------------------------------------------------
>>
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
