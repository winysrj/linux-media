Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51954 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbCVTxg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 15:53:36 -0400
Message-ID: <550F1DBD.2090807@iki.fi>
Date: Sun, 22 Mar 2015 21:53:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] mn88473: implement lock for all delivery systems
References: <1426714629-15640-1-git-send-email-benjamin@southpole.se> <550AE0CC.5050407@iki.fi> <550CA9B4.4050903@southpole.se> <550CAC52.50700@iki.fi> <550D455F.4050500@southpole.se> <550EA7BC.60206@iki.fi> <550EE797.2070603@southpole.se>
In-Reply-To: <550EE797.2070603@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2015 06:02 PM, Benjamin Larsson wrote:
>> Now it works. Next time I really expect you will test your patches
>> somehow before sending. Now I tested 3 different patch versions, find 2
>> first to be broken and last one working. It took around 2 hours of my
>> time.
>>
>> Patch applied.
>>
>> Antti
>>
>
> Yeah, my bad. Next I want to move the driver out of staging. What do I
> need to fix to make it suitable for the main tree ?
>
> There is locking code for both 88472 and 88473.
> There is a workaround for the I2C errors.
> The r820t is now able to receive dvb-c at frequencies around 300MHz.
>
> So I think all TODO's are taken care of. Is it inly the missing register
> I/O checks left ?

I think technically it is in a condition that it could be moved out from 
stating.

There is surely a lot of things that could be done better or improve, 
but all the must be fixed things are fixed.

regards
Antti

-- 
http://palosaari.fi/
