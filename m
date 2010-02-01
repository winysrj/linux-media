Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43246 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab0BAVXN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 16:23:13 -0500
Message-ID: <4B674637.8020403@iki.fi>
Date: Mon, 01 Feb 2010 23:23:03 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Kosina <jkosina@suse.cz>,
	Pekka Sarnila <pekka.sarnila@qvantel.com>,
	Pekka Sarnila <sarnila@adit.fi>, linux-media@vger.kernel.org,
	pb@linuxtv.org, js@linuxtv.org
Subject: Re: dvb-usb-remote woes [was: HID: ignore afatech 9016]
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz> <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz> <4B672EB8.3010609@suse.cz>
In-Reply-To: <4B672EB8.3010609@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2010 09:42 PM, Jiri Slaby wrote:
> On 02/01/2010 07:28 PM, Jiri Kosina wrote:
>> On Mon, 1 Feb 2010, Pekka Sarnila wrote:
>>> I pulled few days ago latest
>>>
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>>
>>> and compiled it. Everything works fine including the tv-stick and the
>>> remote. However I get:
>>>
>>>    <3>af9015: command failed:255
>>>    <3>dvb-usb: error while querying for an remote control event.
>
> Yes, I saw this quite recently too. For me it appears when it is booted
> up with the stick in. It's still to be fixed.

I suspect you are using old firmware, 4.65.0.0 probably, that does not 
support remote polling and thus this 255 errors seen.

regards
Antti
-- 
http://palosaari.fi/
