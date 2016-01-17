Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38619 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbcAQXIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2016 18:08:17 -0500
Received: by mail-wm0-f46.google.com with SMTP id b14so98104682wmb.1
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2016 15:08:16 -0800 (PST)
Subject: Re: Pinnacle PCTV DVB-S2 Stick (461e) - HD Streams with artefacts
To: Rainer Dorsch <ml@bokomoko.de>
Cc: linux-media@vger.kernel.org
References: <13463113.ozc26Vzdzi@blackbox> <2761448.7zDNhWqk2x@blackbox>
 <569B6C83.5080104@gmail.com> <2981088.9zBP1qGkLn@blackbox>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <569C1ECD.3040506@gmail.com>
Date: Sun, 17 Jan 2016 23:07:57 +0000
MIME-Version: 1.0
In-Reply-To: <2981088.9zBP1qGkLn@blackbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rainer Dorsch wrote:
> Hi Andy,
>
> thanks for your reply.
>
> On Sunday 17 January 2016 10:27:15 Andy Furniss wrote:
>> Not that I know of at kernel level. The only way really is to infer
>> loss from the continuity counters, which TVH already logs.
>
> That is already new for me. I do not find the tvheadend.log in
> openelec, and grep did not find a match either. Do you how I enable
> logging continuity errors in tvheadend?

I don't know about openelec, but for me tvh by default (well I can't
remember setting it up and the debugging tab under configure is empty),
logs to /var/log/daemon.log and /var/log/sys.log.

It may be different on openelec, have a look in /var/log/.


