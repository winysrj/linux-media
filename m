Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:40500 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759323AbZE0PDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 11:03:03 -0400
Received: by pxi29 with SMTP id 29so444146pxi.33
        for <linux-media@vger.kernel.org>; Wed, 27 May 2009 08:03:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1D54A5.40602@kernellabs.com>
References: <4A1C2C0F.9090808@gmail.com>
	 <829197380905261105k6f1a8f9dl1bcd067863e85e67@mail.gmail.com>
	 <4A1D54A5.40602@kernellabs.com>
Date: Wed, 27 May 2009 11:03:04 -0400
Message-ID: <829197380905270803s2ea5abceh579ef1dc101dc6df@mail.gmail.com>
Subject: Re: [linux-dvb] EPG (Electronic Program Guide) Tools
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 27, 2009 at 10:56 AM, Steven Toth <stoth@kernellabs.com> wrote:
> Chris,
>
> You'd expect to be able to get 3-4 days of advanced data to populate a guide
> with, in reality you can often get as little a six hours and that's it. The
> mandatory side of the spec is weak in this area. six hours is fine for Now /
> Next but of little use for anything else.
>
> Depending on your needs, your mileage may vary.
>
> Regards,
>
> - Steve

Steve,

The spec requires that at a minimum EIT-0 thorugh EIT-3 be sent
(discussed on page 41 of A/65C).  Of course, I don't know if
broadcasters actually comply with the requirement (although I suspect
they could be liable for FCC fines if they do not).  I will get a
better idea when I start working on EIT support for Kaffeine.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
