Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from urmel-5.rz.uni-frankfurt.de ([141.2.22.233]
	helo=mailout.cluster.uni-frankfurt.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <F.Apitzsch@soz.uni-frankfurt.de>) id 1Jbkml-0006IZ-Hs
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 00:00:09 +0100
Message-ID: <20080318235950.txkealw3k4k40o0o@webmail.server.uni-frankfurt.de>
Date: Tue, 18 Mar 2008 23:59:50 +0100
From: Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>
To: Albert Comerma <albert.comerma@gmail.com>
References: <47DEF7DE.9080709@soz.uni-frankfurt.de>
	<ea4209750803171610u22e948fcl4812f5c873801b64@mail.gmail.com>
In-Reply-To: <ea4209750803171610u22e948fcl4812f5c873801b64@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy HT Express: It works!
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

OK, my Terratec Cinergy HT Express now works with dvb-linux.
I managed to apply the patch by Hans-Frieder and Albert. Thanks for  
your work! Additionally, I added my card's description to  
dvb-usb-ids.h and dib0700_devices.c . (Should I post the files?)

I read the website before I posted my first email, but screwed up  
applying the patch correctly. Now I started all over to compare and  
include the new parts into today's development snapshot and it works.

I could scan channels and (using MPlayer) tune and even had audio working.

I was not sure about the xc3028 firmware, since my card's windows  
driver does not contain any emBDA.sys but only a XC3028.rom which  
looks different. Anyhow I did not try to extract any firmware myself.  
I just took an existing xc3028-v27.fw and copied it into  
/lib/firmware. I am not even sure it is loaded, but it works.

Could someone please add the my card together with the Pinnacle 320cx  
and Terratec Cinergy HT USB XE to the dvb-linux development tree and  
the wiki?

Thanks,

Felix

Quoting Albert Comerma <albert.comerma@gmail.com>:

> To make dvb-t working (not analog), please have a look at my page;
> http://www.comerma.net/pinnacle320cx_en.html
> It should work for you just adding your device descriptor to
> dvb-usb-ids.hand your card at dib0700_devices.c, I would try first to
> use the same
> frontend attach as other cinergy usb cards. If you think it's to complicated
> I can try to add it for you, tomorrow. Please let me know.
>
> Albert
>
> 2008/3/17, Felix Apitzsch <f.apitzsch@soz.uni-frankfurt.de>:
>>
>> Im am trying to get my Terratec Cinergy HT Express to work with v4l-dvb.
>>
>> It's a DVB-T/analog hybrid (+radio) ExpressCard 34, but it connects
>> via the usb interface, not the pci-e interface. To confirm what I
>> reckoned, I openend the device to find the following:
>>
>> DiBcom 7700C1-ACXXa-G QH0T8 D2PRJ.1 0646-1100-C
>>
>> XCEIVE XC3028 AK47465,2 0620TWE3
>>
>> CONEXANT CX25843-24Z 61024448 0625 KOREA
>>
>> (I took some photos if someone is interested)
>>
>> The usd-id is 0ccd:0060 .
>>
>> For now, I would be happy to live with just DVB-T support.
>> As far as I understand the status quo, it should be possible to get
>> the card running, isn't it?
>>
>> I would need some help to get the xc3028 part compiled and running and
>> add it to dib0700_devices.c and dvb-usb-ids.h with the right config
>> for the DIB770C1+XC3028. Additionally, I would need some assistance
>> with the firmware xc3028. The dib0700 firmeware should be ok.
>>
>> Also, I had some trouble when I tried to get the xc3028 frontend code
>> compiled. It is not in v4l_experimental anymore, is it? Where did it
>> go and how do I include it?
>>
>> Could anyone do a patch for me and pack me a .bz2, so I can do some
>> testing?
>>
>> I am running a kernel 2.6.24 on a x86_64 (~amd64) gentoo system with
>> current v4l-dvb-hg from portage.
>>
>> Felix
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
