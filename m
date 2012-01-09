Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.li-life.net ([195.225.200.6]:3339 "EHLO mail.li-life.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab2AIWUJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jan 2012 17:20:09 -0500
Message-ID: <4F0B6480.30900@kaiser-linux.li>
Date: Mon, 09 Jan 2012 23:04:48 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Martin Herrman <martin.herrman@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [DVB Digital Devices Cine CT V6] status support
References: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com> <01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr> <CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
In-Reply-To: <CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/09/2012 09:05 AM, Martin Herrman wrote:
> 2012/1/8 Sébastien RAILLARD (COEXSI)<sr@coexsi.fr>:
>>
>>> http://shop.digital-
>>> devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/62357162/Categori
>>> es/HDTV_Karten_fuer_Mediacenter/Cine_PCIe_Serie/DVBC_T
>>>
>>> But.. is this card supported by the Linux kernel?
>>>
>>
>> The short answer is yes, and as far as I know, it's working fine with DVB-T
>> (I've never tested the DVB-C).
>> For support, you need to compile the drivers from Oliver Endriss as they are
>> not merged in mainstream kernel.
>>
>> Check here (kernel>  2.6.31):
>> http://linuxtv.org/hg/~endriss/media_build_experimental/
>> Or here (kernel<  2.6.36) :
>> http://linuxtv.org/hg/~endriss/ngene-octopus-test/
>
> Hi Sébastien,
>
> thanks for your quick and positive reply.
>
> Anyone here that tested it with DVB-C?
>
> Are there any plans to merge this in the mainstream kernel?
>
> Regards,
>
> Martin

Hello Martin

I use the DD Cine CT V6 with DVB-C. It works without problems.
I got the driver before Oliver integrated it in his tree. Therefor I did 
not compile Olivers tree, yet.

At the moment I run the card on Ubuntu 11.10 with kernel 3.0.0-14.

Hope this helps.

Thomas


