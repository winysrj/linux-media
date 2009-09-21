Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsub1.hostvue.com ([195.26.90.71]:50281 "EHLO
	mailsub1.hostvue.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbZIUP1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 11:27:24 -0400
Message-ID: <29219.188.220.60.62.1253546846.squirrel@webmail.daily.co.uk>
In-Reply-To: <4AB791DE.1020906@linuxtv.org>
References: <1252297247.18025.8.camel@morgan.walls.org>
    <1252369138.2571.17.camel@morgan.walls.org>
    <1253413236.13400.24.camel@morgan.walls.org>
    <4AB78169.5030800@kernellabs.com>
    <34816.188.220.60.62.1253541249.squirrel@webmail.daily.co.uk>
    <4AB791DE.1020906@linuxtv.org>
Date: Mon, 21 Sep 2009 16:27:26 +0100 (BST)
Subject: Re:
From: "George Joseph" <george@playinmedia.com>
To: "Andreas Oberritter" <obi@linuxtv.org>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Andreas, That answers my question. I am using a tree I checkd out 3
months ago. I used the DEMUX_SET_SOURCE API to set the ts feed to the
tuner. Is this explicity done on Linux DVB 3?

Thanks,
Warm regs,
George.


> Hello George,
>
> demux0-3 represent different TS inputs. You can open each demux device
> multiple times. The 128 PID filters are shared between the four devices.
>
> Regards,
> Andreas
>
> George Joseph wrote:
>> Hello All,
>>
>>  I am new to the list. I am currently working on a dm7025 platform and
>> would like to know if there is a possibillity to use the 128 pid filters
>> on the xilleon 226. currently I see only /dev/dvb/adaptor0/demux0-3 in
>> my
>> device directory - i,e; at a point in time I can use only 4 tpid filters
>> from the 128 available at hardware level.
>>
>>
>> Cheers,
>> Warm regs,
>> G.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

