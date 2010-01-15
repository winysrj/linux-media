Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64952 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0AOXFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 18:05:25 -0500
Received: by fxm25 with SMTP id 25so673754fxm.21
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 15:05:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001160000.31965@orion.escape-edv.de>
References: <4B4F39BB.2060605@motama.com> <4B4F3FD5.5000603@motama.com>
	 <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
	 <201001160000.31965@orion.escape-edv.de>
Date: Fri, 15 Jan 2010 18:05:23 -0500
Message-ID: <829197381001151505k269f6b38wf4150f587bbf7f4d@mail.gmail.com>
Subject: Re: Order of dvb devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Andreas Besse <besse@motama.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 15, 2010 at 6:00 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
>> I believe your assumption is incorrect.  I believe the enumeration
>> order is not deterministic even for multiple instances of the same
>> driver.  It is not uncommon to hear mythtv users complain that "I have
>> two PVR-150 cards installed in my PC and the order sometimes get
>> reversed on reboot".
>
> Afaik the indeterministic behaviour is caused by udev, not by the
> kernel. We never had these problems before udev was introduced.

I suppose it's possible that udev does not process the events in the
order in which they are received.  Admittedly I have not done any real
analysis as to how that part of the kernel works.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
