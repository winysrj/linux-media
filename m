Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:33036 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0ARNid (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 08:38:33 -0500
Received: by qyk32 with SMTP id 32so118868qyk.4
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 05:38:32 -0800 (PST)
Message-ID: <4B5464BC.20001@gmail.com>
Date: Mon, 18 Jan 2010 09:40:12 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: CI USB
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>	 <3f3a053b1001021411i2e9484d7rd2d13f1a355939fe@mail.gmail.com>	 <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>	 <d9def9db1001091811s6dbed557vfca9ce410e41d3d3@mail.gmail.com>	 <4B49D1A4.4040702@gmail.com>	 <1a297b361001100535u1875de01jfe2b724c6643dfc0@mail.gmail.com> <846899811001100728x27eaf4faqd83373dd16ef58d3@mail.gmail.com>
In-Reply-To: <846899811001100728x27eaf4faqd83373dd16ef58d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HoP a écrit :
>> I don't know the details into the USB device, but each of those CAM's
>> have bandwidth limits on them and they vary from one CAM to the other.
>> Also, there is a limit on the number of simultaneous PID's that which
>> you can decrypt.
>>
>> Some allow only 1 PID, some allow 3. Those are the basic CAM's for
>> home usage.The most expensive CAM's allow a maximum of 24 PID's. But
>>     
>
> You, of course, ment number of descramblers not PIDS because it is evident
> that getting TV service descrambled, you need as minimum 2 PIDS for A/V.
>
> Anyway, it is very good note. Users, in general, don't know about it.
>
> /Honza
>   
Just a quick note here: you might want to post to the mythtv ML and the 
VDR one also (probably others but I dont know them off hand) and see how 
people feel about this. My guess is that quite a few potential users are 
on these ML, and the CI threads are recurrent there because of good 
dvb-s cards but without CI support.
A usb-CI or equivalent HW + good drivers would allow people to pick the 
dvb-s(2) cards without worrying about CI support.
HTH
Bye
Manu
