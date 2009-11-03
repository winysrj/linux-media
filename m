Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:23572 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZKCKSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2009 05:18:30 -0500
Received: by fg-out-1718.google.com with SMTP id d23so1208588fga.1
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 02:18:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AEF5FE5.2000607@stud.uni-hannover.de>
References: <4AEF5FE5.2000607@stud.uni-hannover.de>
Date: Tue, 3 Nov 2009 11:18:34 +0100
Message-ID: <c4e36d110911030218k606e3108l67456727780439a8@mail.gmail.com>
Subject: Re: [linux-dvb] NOVA-TD exeriences?
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/2 Soeren Moch <Soeren.Moch@stud.uni-hannover.de>:
>
>> > Hi. I would be happy to hear if anyone has tried both the NOVA-TD and
>> > the
>> > NOVA-T. The NOVA-T has always worked perfectly here but I would like to
>> > know
>> > if the -TD will do the job of two NOVA-T's. And there also seems to be a
>> > new
>> > version out with two small antenna connectors instead of the previous
>> > configuration. Anyone tried it? Does it come with an antenna adaptor
>> > cable?
>> > http://www.hauppauge.de/de/pics/novatdstick_top.jpg
>> > Thankful for any info.
>>
>> Well I've this usb stick with these two small connectors - and it runs
>> just fine.
>>
>> Though I think there is some problem with suspend/resume recently
>> (2.6.32-rc5)  and it needs some inspection.
>>
>> But it works just fine for dual dvb-t viewing.
>>
>> And yes - it contains two small antennas with small connectors and
>> one adapter for normal antenna - i.e. 1 antenna input goes to 2 small
>> antenna connectors.
>
> zdenek, your nova-td stick works just fine for dual dvb-t viewing?
> I always had this problem:
> When one channel is streaming and the other channel is switched on, the
> stream of the already running channel gets broken.
> see also:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg06376.html
>
> Can you please test this case on your nova-td stick?

I'll recheck in the evening whether there are no regression, but I've
been able to get 3 dvb-t independent (different mux) TV streams (with
the usage of the second stick Aver Hybrid Volar HX & proprietary Aver
driver) with 2.6.29/30 vanilla kernels played at the same time on my
C2D T61.

Zdenek
