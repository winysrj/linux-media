Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:33158 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdFUHeC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 03:34:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Jun 2017 09:34:01 +0200
From: Thierry Lelegard <thierry.lelegard@free.fr>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: thierry@lelegard.fr, linux-media@vger.kernel.org
Subject: Re: LinuxTV V3 vs. V4 API doc inconsistency, V4 probably wrong
Reply-To: thierry@lelegard.fr
In-Reply-To: <20170619140806.7e92ae66@vento.lan>
References: <3188f2a2bcba758dccaaa8cdbbd694fb@free.fr>
 <20170619140806.7e92ae66@vento.lan>
Message-ID: <ce5e9d6a3b4aafdcec9ee672a6d15322@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> First of all, there's no Linux DVB API v4. It was skipped, because 
> there
> was a proposal for a v4, with was never adopted.

Alright, whatever, you have understood it was the post-V3 API, S2API, 
you name it.
You should assign it a version number by the way.

> Thanks for reviewing it! Yeah, the asterisks there are wrong.
> The definitions should be, instead:
> 
> int ioctl(int fd, FE_SET_TONE, enum fe_sec_tone_mode tone)
> int ioctl(int fd, FE_SET_VOLTAGE, enum fe_sec_voltage voltage)
> int ioctl(int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd tone)
> 
> As they're passing by value, not by reference[1].

Thanks for the clarification.

> Feel free to send us fix patches.

Do you suggest I should locate the repository, clone it, understand the 
structure,
locate the documentation files, etc? That would take 20 times the time 
it takes to
remove the 3 asterisk characters when you already master the source code 
as you
probably do.

I own a few opensource projects on sourceforge and github. When a user 
reports
a problem, whether it is a functional one or a documentation typo, I fix 
it myself.
I do not expect users to do it for me. For those projects, I am the 
developer and
they are the users. I welcome contributions, but I do not demand or even 
expect them.

Cheers
-Thierry
