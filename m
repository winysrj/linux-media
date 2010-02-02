Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:50964 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab0BBQOA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 11:14:00 -0500
Message-ID: <4B684C99.4030808@qvantel.com>
Date: Tue, 02 Feb 2010 18:02:33 +0200
From: Pekka Sarnila <pekka.sarnila@qvantel.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
	Pekka Sarnila <sarnila@adit.fi>, linux-media@vger.kernel.org,
	pb@linuxtv.org, js@linuxtv.org
Subject: Re: dvb-usb-remote woes [was: HID: ignore afatech 9016]
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz> <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz> <4B672EB8.3010609@suse.cz> <4B674637.8020403@iki.fi>
In-Reply-To: <4B674637.8020403@iki.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please, no mail to this address, use only sarnila@adit.fi.

Pekka

Antti Palosaari wrote:
> On 02/01/2010 09:42 PM, Jiri Slaby wrote:
> 
>> On 02/01/2010 07:28 PM, Jiri Kosina wrote:
>>
>>> On Mon, 1 Feb 2010, Pekka Sarnila wrote:
>>>
>>>> I pulled few days ago latest
>>>>
>>>>     
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>>>
>>>> and compiled it. Everything works fine including the tv-stick and the
>>>> remote. However I get:
>>>>
>>>>    <3>af9015: command failed:255
>>>>    <3>dvb-usb: error while querying for an remote control event.
>>
>>
>> Yes, I saw this quite recently too. For me it appears when it is booted
>> up with the stick in. It's still to be fixed.
> 
> 
> I suspect you are using old firmware, 4.65.0.0 probably, that does not 
> support remote polling and thus this 255 errors seen.
> 
> regards
> Antti
