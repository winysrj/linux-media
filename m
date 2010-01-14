Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:39924 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0ANRTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 12:19:37 -0500
Received: by gv-out-0910.google.com with SMTP id r4so284449gve.37
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 09:19:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
References: <4B4F39BB.2060605@motama.com>
	 <829197381001140746g56c5ccf7mc7f6a631cb16e15d@mail.gmail.com>
	 <4B4F3FD5.5000603@motama.com>
	 <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
Date: Thu, 14 Jan 2010 12:19:35 -0500
Message-ID: <37219a841001140919h42303fc9v74ee3c34ff16027@mail.gmail.com>
Subject: Re: Order of dvb devices
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andreas Besse <besse@motama.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 11:09 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Jan 14, 2010 at 11:01 AM, Andreas Besse <besse@motama.com> wrote:
>> yes if there are different drivers I already observed the behaviour that
>> the ordering gets flipped after reboot.
>>
>> But if I assume, that there is only *one* driver that is loaded (e.g.
>> budget_av) for all dvb cards in the system, how is the ordering of these
>> devices determined? How does the driver "search" for available dvb cards?
>
> I believe your assumption is incorrect.  I believe the enumeration
> order is not deterministic even for multiple instances of the same
> driver.  It is not uncommon to hear mythtv users complain that "I have
> two PVR-150 cards installed in my PC and the order sometimes get
> reversed on reboot".
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

If you "modinfo dvb_adapter_driver_foo"  you will see an "adapter_nr"
module option -- you can use this to force your DVB adapter device
minor ordering.

Regards,

Mike
