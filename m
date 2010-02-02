Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:55084 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab0BBQOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 11:14:38 -0500
Message-ID: <4B684FF3.1070104@adit.fi>
Date: Tue, 02 Feb 2010 18:16:51 +0200
From: Pekka Sarnila <sarnila@adit.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Antti Palosaari <crope@iki.fi>, Jiri Kosina <jkosina@suse.cz>,
	Pekka Sarnila <pekka.sarnila@qvantel.com>,
	linux-media@vger.kernel.org, pb@linuxtv.org, js@linuxtv.org
Subject: Re: dvb-usb-remote woes [was: HID: ignore afatech 9016]
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz> <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz> <4B672EB8.3010609@suse.cz> <4B674637.8020403@iki.fi> <4B674A7F.60108@suse.cz>
In-Reply-To: <4B674A7F.60108@suse.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the old kernel (2.6.24) it did not work if it was plugged while 
booting. If I recall right then it was due to the order different layers 
are initialized (modules loaded).

Pekka


Jiri Slaby wrote:
> On 02/01/2010 10:23 PM, Antti Palosaari wrote:
> 
>>On 02/01/2010 09:42 PM, Jiri Slaby wrote:
>>
>>>On 02/01/2010 07:28 PM, Jiri Kosina wrote:
>>>
>>>>On Mon, 1 Feb 2010, Pekka Sarnila wrote:
>>>>
>>>>>   <3>af9015: command failed:255
>>>>>   <3>dvb-usb: error while querying for an remote control event.
>>>
>>>Yes, I saw this quite recently too. For me it appears when it is booted
>>>up with the stick in. It's still to be fixed.
>>
>>I suspect you are using old firmware, 4.65.0.0 probably, that does not
>>support remote polling and thus this 255 errors seen.
> 
> 
> For me:
> af9013: firmware version:4.95.0
> 
> As I wrote, for me it happens iff it is plugged-in while booting. I'll
> investigate it further later -- that it a reason why I haven't reported
> it yet.
> 
