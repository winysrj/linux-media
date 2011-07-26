Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57441 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1GZOqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 10:46:55 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QliuI-0002v4-CL
	for linux-media@vger.kernel.org; Tue, 26 Jul 2011 16:46:50 +0200
Received: from support01.office.net1.cc ([213.137.58.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 16:46:49 +0200
Received: from root by support01.office.net1.cc with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 16:46:49 +0200
To: linux-media@vger.kernel.org
From: Doychin Dokov <root@net1.cc>
Subject: Re: driver problem: cx231xx error -71 with Hauppauge USB live2 on
 Ubuntu 11.04, netbook edition
Date: Tue, 26 Jul 2011 17:46:27 +0300
Message-ID: <j0mk0d$gul$1@dough.gmane.org>
References: <AANLkTinprP=o6_TnPjj1ieZAp27qmW-nuWHq04dN1oVp@mail.gmail.com> <AANLkTi=-umKif5pGz-adhZhtcd8CnJJsZ1pzHn0ttvwA@mail.gmail.com> <j0m9s7$e9j$1@dough.gmane.org> <CAGoCfizFA75Lyyx49EEJO9n5Smw1trBX7Azdu1iYrAqpYnDE8g@mail.gmail.com> <j0mck9$vh4$1@dough.gmane.org> <CAGoCfiwiqFkQ_zixgfEB7O19t1nTStJS+8RgfNAbXW3EzTaAuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGoCfiwiqFkQ_zixgfEB7O19t1nTStJS+8RgfNAbXW3EzTaAuA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

На 26.7.2011 г. 16:05 ч., Devin Heitmueller написа:
> On Tue, Jul 26, 2011 at 8:40 AM, Doychin Dokov<root@net1.cc>  wrote:
>> I find only the Sunday fix for the power ramp issue, which states it's for a
>> problem caused by the config hz being different of 100. Is this the patch
>> you point me to, and do you think it's the solution in my case?
>>
>> # cat /boot/config-2.6.38-10-server | grep CONFIG_HZ
>> CONFIG_HZ_100=y
>> # CONFIG_HZ_250 is not set
>> # CONFIG_HZ_300 is not set
>> # CONFIG_HZ_1000 is not set
>> CONFIG_HZ=100
>
> There were actually two patches sent over the weekend, but the power
> ramp issue was only for people who had CONFIG_HZ set to 1000.  In your
> case, you only need the first patch.
>
> See the email with subject: "[PATCH] Fix regression introduced which
> broke the Hauppauge USBLive 2" for the patch you need.
>
> Devin
>
Just tested...

[  839.052752] cx231xx: Cx231xx Audio Extension initialized
[  850.221325] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  850.224774] cx231xx #0: cx231xx_init_audio_isoc: Starting ISO AUDIO 
transfers
[  851.150358] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4

It works flawless!

Thank you! Hope the patch gets commited soon.

