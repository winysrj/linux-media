Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:53107
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbZLaIXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 03:23:08 -0500
Message-ID: <FCC76B9C567642B191F318E27975AFA4@david0515db4b1>
From: "dave" <baroque@iinet.net.au>
To: <linux-media@vger.kernel.org>
Cc: <linux-dvb@linuxtv.org>
References: <4B3ABD9D.6040207@iinet.net.au> <4B3C0DA3.8050905@iinet.net.au>
Subject: Re: [linux-dvb] Compro VideoMate U80 DVB-T USB 2.0 High Definition Digital TV Stick
Date: Thu, 31 Dec 2009 19:13:48 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> drappa wrote:
>> Hi All
>>
>> http://www.comprousa.com/en/product/u80/u80.html
>>
>> I'd be grateful if anyone can tell me if this device is supported yet, 
>> and if so, any pointers to getting it working.
>>
>> Thanks
>> Drappa
>>
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
> In the absence of any feedback to my query, I had a look at the driver 
> entry for this device in a Win7 system.
> It shows as:  Videomate U1xx Digital Series
> The driver was written by Realtek and is version 5.55.828.2009
> So, I guess there may be a number of devices in this series with the same 
> chipset.
> Does this ring any bells with anyone?
>
> Thanks
> Drappa
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi drappa,
Things do seem quiet, so perhaps a couple of controversial remarks will 
liven it up.

Several months ago I bought a USB dual DVB-T tuner (KWorld PlusTV) and was 
in a similar position to you, just a different model of stick.
With Windows, the job would have been straightforward, as Windows has an 
architecture for adding new USB products. A couple of entries in the 
registry, a driver for the chipset, and you're away.
With Linux, you've a choice of spending 35 hours trying to patch and 
recompile the kernel so that the new device is recognised, or if that sounds 
too onerous, wait 6 to 12 months until it's included in the standard kernel.

While I recognise that I cannot legitimately complain, since Linux is a 
take-it-or-leave-it arrangement where if there's a problem, I should ideally 
volunteer to fix it myself, I still do think that it's bizarre that a 
recompile of the kernel is needed.  I ask myself why it is not possible to 
have a database of devices (like the Windows registry) which can be easily 
updated.  This would allow simple installation of new products which use 
chipsets identical to existing supported products.

[The outcome with my tuner so far.... after a failed attempt at patching the 
kernel, I waited till 2.6.32 kernel was available, upon which the device was 
recognised, but still can only get one of the two tuners operating.  This 
will likely be the subject of a separate forum thread in the near future.]

Sorry I cannot shed light on your particular model of tuner.

I will conclude by saying incidentally, that I have been a very satisifed 
user of mythTV (with multiple PCI tuners) for the last two and a bit years.

dave 

