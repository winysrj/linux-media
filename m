Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60444 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1GZMlC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 08:41:02 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QlgwU-00017w-6a
	for linux-media@vger.kernel.org; Tue, 26 Jul 2011 14:40:58 +0200
Received: from support01.office.net1.cc ([213.137.58.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 14:40:58 +0200
Received: from root by support01.office.net1.cc with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 14:40:58 +0200
To: linux-media@vger.kernel.org
From: Doychin Dokov <root@net1.cc>
Subject: Re: driver problem: cx231xx error -71 with Hauppauge USB live2 on
 Ubuntu 11.04, netbook edition
Date: Tue, 26 Jul 2011 15:40:31 +0300
Message-ID: <j0mck9$vh4$1@dough.gmane.org>
References: <AANLkTinprP=o6_TnPjj1ieZAp27qmW-nuWHq04dN1oVp@mail.gmail.com> <AANLkTi=-umKif5pGz-adhZhtcd8CnJJsZ1pzHn0ttvwA@mail.gmail.com> <j0m9s7$e9j$1@dough.gmane.org> <CAGoCfizFA75Lyyx49EEJO9n5Smw1trBX7Azdu1iYrAqpYnDE8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGoCfizFA75Lyyx49EEJO9n5Smw1trBX7Azdu1iYrAqpYnDE8g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

На 26.7.2011 г. 15:17 ч., Devin Heitmueller написа:
> On Tue, Jul 26, 2011 at 7:53 AM, Doychin Dokov<root@net1.cc>  wrote:
>> [416830.939483] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
>>
>> This is with the stock kernel, no media_build tree installed (I'm currently
>> compiling it).
>
> Patches for this issue were submitted over the weekend.  Check the
> mailing list for posts from Saturday or wait a few days for the
> patches to be merged into the linux_media tree.
>

I find only the Sunday fix for the power ramp issue, which states it's 
for a problem caused by the config hz being different of 100. Is this 
the patch you point me to, and do you think it's the solution in my case?

# cat /boot/config-2.6.38-10-server | grep CONFIG_HZ
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100

Kind regards,
Doychin

