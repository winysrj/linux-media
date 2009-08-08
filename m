Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52018 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753073AbZHHUQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Aug 2009 16:16:32 -0400
Message-ID: <4A7DDD1C.1030906@gmx.de>
Date: Sat, 08 Aug 2009 22:16:28 +0200
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: Trent Piepho <xyzzy@speakeasy.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch review 6/6] radio-mr800: redesign radio->users counter
References: <1249753576.15160.251.camel@tux.localhost>	 <Pine.LNX.4.58.0908081101310.11911@shell2.speakeasy.net> <208cbae30908081208o5a048fb0qdd6c356b0c6d3eb9@mail.gmail.com>
In-Reply-To: <208cbae30908081208o5a048fb0qdd6c356b0c6d3eb9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexey Klimov schrieb:
> On Sat, Aug 8, 2009 at 10:01 PM, Trent Piepho<xyzzy@speakeasy.org> wrote:
>   
>> On Sat, 8 Aug 2009, Alexey Klimov wrote:
>>     
>>> Redesign radio->users counter. Don't allow more that 5 users on radio in
>>>       
>> Why?
>>     
>
> Well, v4l2 specs says that multiple opens are optional. Honestly, i
> think that five userspace applications open /dev/radio is enough. Btw,
> if too many userspace applications opened radio that means that
> something wrong happened in userspace. And driver can handle such
> situation by disallowing new open calls(returning EBUSY). I can't
> imagine user that runs more than five mplayers or gnomeradios, or
> kradios and so on.
>
> Am i totally wrong here?
>
> Thanks.
>   
"I can't imagine.." Funny answer, reminds at the 640kB limit of old 
computers.. :)
But if there's no real technical restriction, the driver should not 
restrict access a device at all.

