Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:38361 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757349Ab0ANR16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 12:27:58 -0500
Message-ID: <4B4F541A.9040200@skynet.be>
Date: Thu, 14 Jan 2010 18:27:54 +0100
From: xof <xof@skynet.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: VL4-DVB compilation issue not covered by Daily Automated
References: <4B4CE912.1000906@von-eitzen.de>	 <829197381001121344l3ad94bdajdd4eb0345b895f2b@mail.gmail.com>	 <4B4D852F.4030506@skynet.be> <829197381001130744m24da5ea3xe1cb5135237b1127@mail.gmail.com>
In-Reply-To: <829197381001130744m24da5ea3xe1cb5135237b1127@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller a écrit :
> On Wed, Jan 13, 2010 at 3:32 AM, xof <xof@skynet.be> wrote:
>   
>> Are you sure? (it is an Ubuntu-only issue)
>>
>> I can see several
>>     
>>> #include <asm/asm.h>
>>>       
>> in the v4l tree that compile fine on Ubuntu
>> but only linux/drivers/media/dvb/firewire/firedtv-1394.c contains
>>     
>>> #include <asm.h>
>>>       
>> and doesn't compile.
>>
>> Unfortunately the asm.h asm/asm.h is not the only issue with
>> firedtv-1394.c (on Ubuntu/Karmic Koala?).
>> The /drivers/ieee1394/*.h seem to be in the linux-sources tree and not
>> in the linux-headers one (?)
>>
>> Everywhere I look, I read "don't bother, just disable firedtv-1394.c"
>> until they fix it.
>>     
>
> I think perhaps you meant to write "dma.h" and not "asm.h".
>
> All of the missing includes in the error log (including "dma.h") are
> for files that are found in the iee1394 source directory, which are
> not provided in the Ubuntu linux-headers package.
>
> Devin
>
>   
Oups!  You are right...

Thank you.


xof
-------------------------
PS: I signaled the problem to the Ubuntu community
    https://bugs.launchpad.net/ubuntu/+source/linux/+bug/507154
I hope this was the right thing to do... I did not find any mention of
the problem there.
There is no reaction yet, it is just one of 5000 other things to look at...

