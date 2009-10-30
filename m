Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbZJ3N7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 09:59:39 -0400
Message-ID: <4AEAF14E.3090707@tripleplay-services.com>
Date: Fri, 30 Oct 2009 13:59:42 +0000
From: Lou Otway <louis.otway@tripleplay-services.com>
MIME-Version: 1.0
To: "pierre.gronlier" <ticapix@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Determining MAC address or Serial Number
References: <4AEAB4A6.6050502@tripleplay-services.com> <hcehh0$u72$1@ger.gmane.org>
In-Reply-To: <hcehh0$u72$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pierre.gronlier wrote:
> Lou Otway wrote, On 10/30/2009 10:40 AM:
>   
>> Hi,
>>
>> I'm trying to find a way to be able to uniquely identify each device in
>> a PC and was hoping to use either serial or MAC for this purpose.
>>
>> I've looked at the documentation but can't find a generic way to read
>> back serial numbers or MAC addresses from V4L devices? Does such a
>> function exist?
>>     
>
>
> Hi Lou,
>
> I'm using the mac address to identify each device and to do so I created
> this script which use dvbnet to create network interface from the dvb card.
>
> a=<your adapter>
> n=<your net device>
> for ex. /dev/dvb/adapter1/net0 => a=1, n=0
>
>
> # get mac address
> iface=$(sudo /usr/bin/dvbnet -a $a -n $n -p 0 | awk '/device/ {print $3}')
> sleep 1
> mac_address=$(/sbin/ifconfig $iface | awk '/HWaddr/ {print $5}' | tr -d
> ':' | tr A-Z a-z)
> num=$(sudo /usr/bin/dvbnet -a $a -n $n -l | grep 'Found device ' | awk
> '{print $3}' | tr -d ':')
> sleep 1
> sudo /usr/bin/dvbnet -a $a -n $n -d $num 1> /dev/null
>
>
>
> AFAIK, mac address are known only from the kernel and are not directly
> exposed to the userland. I you manage to do something "cleaner", let me
> know :)
>
>
> Regards
>
> pierre gr.
>
>
>   
> re majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
Thanks Pierre,

Unfortunately only some of my devices reported a MAC address, I guess 
that not all drivers have this feature built in. I think the same 
problem will hold true for serial devices so I will look at another way 
to list my devices.

I was thinking to use lshw or lspci to give me a list of devices, from 
that I can build my own table of devices each one with a unique value to 
differentiate it from others. My worry is that the output from lshw or 
lspci isn't sufficiently detailed to allow me to differentiate between 
devices.

Thanks,

Lou







