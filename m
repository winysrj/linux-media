Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:57290 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab0BAVl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 16:41:26 -0500
Received: by bwz23 with SMTP id 23so87874bwz.21
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 13:41:24 -0800 (PST)
Message-ID: <4B674A7F.60108@suse.cz>
Date: Mon, 01 Feb 2010 22:41:19 +0100
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jiri Kosina <jkosina@suse.cz>,
	Pekka Sarnila <pekka.sarnila@qvantel.com>,
	Pekka Sarnila <sarnila@adit.fi>, linux-media@vger.kernel.org,
	pb@linuxtv.org, js@linuxtv.org
Subject: Re: dvb-usb-remote woes [was: HID: ignore afatech 9016]
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz> <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz> <4B672EB8.3010609@suse.cz> <4B674637.8020403@iki.fi>
In-Reply-To: <4B674637.8020403@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2010 10:23 PM, Antti Palosaari wrote:
> On 02/01/2010 09:42 PM, Jiri Slaby wrote:
>> On 02/01/2010 07:28 PM, Jiri Kosina wrote:
>>> On Mon, 1 Feb 2010, Pekka Sarnila wrote:
>>>>    <3>af9015: command failed:255
>>>>    <3>dvb-usb: error while querying for an remote control event.
>>
>> Yes, I saw this quite recently too. For me it appears when it is booted
>> up with the stick in. It's still to be fixed.
> 
> I suspect you are using old firmware, 4.65.0.0 probably, that does not
> support remote polling and thus this 255 errors seen.

For me:
af9013: firmware version:4.95.0

As I wrote, for me it happens iff it is plugged-in while booting. I'll
investigate it further later -- that it a reason why I haven't reported
it yet.

-- 
js
suse labs
