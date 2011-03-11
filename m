Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57285 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1CKVwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 16:52:13 -0500
Received: by fxm17 with SMTP id 17so1426248fxm.19
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 13:52:12 -0800 (PST)
Message-ID: <4D7A97BB.4020704@gmail.com>
Date: Fri, 11 Mar 2011 22:44:27 +0100
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: obi@linuxtv.org
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home> <4D7A452C.7020700@linuxtv.org>
In-Reply-To: <4D7A452C.7020700@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter wrote:
> On 03/10/2011 04:29 PM, Issa Gorissen wrote:
>   
>> As the cxd20099 driver is in staging due to abuse of the sec0 device, this
>> patch renames it to cam0. The sec0 device is not in use and can be removed
>>     
>
> That doesn't solve anything. Besides, your patch doesn't even do what
> you describe.
>
> Wouldn't it be possible to extend the current CA API? If not, shouldn't
> a new API be created that covers both old and new requirements?
>
> It's rather unintuitive that some CAMs appear as ca0, while others as cam0.
>   
Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
transport stream. To me it  looks like an extension of the current API.

The sec name needs changing obviously, but there seem to be some other
problems too.
> If it was that easy to fix, it wouldn't be in staging today.
>
> Regards,
> Andreas
>   
Regards,
Martin
