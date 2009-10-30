Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55595 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZJ3LJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 07:09:40 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N3pMW-0000Sm-0H
	for linux-media@vger.kernel.org; Fri, 30 Oct 2009 12:09:44 +0100
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 30 Oct 2009 12:09:43 +0100
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 30 Oct 2009 12:09:43 +0100
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: Re: Determining MAC address or Serial Number
Date: Fri, 30 Oct 2009 12:09:16 +0100
Message-ID: <hcehh0$u72$1@ger.gmane.org>
References: <4AEAB4A6.6050502@tripleplay-services.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: <4AEAB4A6.6050502@tripleplay-services.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lou Otway wrote, On 10/30/2009 10:40 AM:
> Hi,
> 
> I'm trying to find a way to be able to uniquely identify each device in
> a PC and was hoping to use either serial or MAC for this purpose.
> 
> I've looked at the documentation but can't find a generic way to read
> back serial numbers or MAC addresses from V4L devices? Does such a
> function exist?


Hi Lou,

I'm using the mac address to identify each device and to do so I created
this script which use dvbnet to create network interface from the dvb card.

a=<your adapter>
n=<your net device>
for ex. /dev/dvb/adapter1/net0 => a=1, n=0


# get mac address
iface=$(sudo /usr/bin/dvbnet -a $a -n $n -p 0 | awk '/device/ {print $3}')
sleep 1
mac_address=$(/sbin/ifconfig $iface | awk '/HWaddr/ {print $5}' | tr -d
':' | tr A-Z a-z)
num=$(sudo /usr/bin/dvbnet -a $a -n $n -l | grep 'Found device ' | awk
'{print $3}' | tr -d ':')
sleep 1
sudo /usr/bin/dvbnet -a $a -n $n -d $num 1> /dev/null



AFAIK, mac address are known only from the kernel and are not directly
exposed to the userland. I you manage to do something "cleaner", let me
know :)


Regards

pierre gr.

> 
> Thanks,
> 
> Lou


