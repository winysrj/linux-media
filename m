Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47025 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab1EaDtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 23:49:55 -0400
Received: by ewy4 with SMTP id 4so1489444ewy.19
        for <linux-media@vger.kernel.org>; Mon, 30 May 2011 20:49:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110531124843.377a2a80@glory.local>
References: <4D764337.6050109@email.cz>
	<20110531124843.377a2a80@glory.local>
Date: Mon, 30 May 2011 23:49:54 -0400
Message-ID: <BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, thunder.m@email.cz,
	"istvan_v@mailbox.hu" <istvan_v@mailbox.hu>, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 30, 2011 at 10:48 PM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
>> Hi Istvan
>>
>>       I am sending you modified patches for kernel 2.6.37.2, they
>> works as expected.
>>
>> First apply kernel_xc4000.diff (your patch) then kernel_dtv3200h.diff
>> for Leadtek DTV3200 XC4000 support.
>
> Can you resend your patches with right Signed-Off string for commit into kernel?
>
> With my best regards, Dmitry.

He cannot offer a Signed-off-by for the entire patch - it's not his
code.  The patches are based on the work that Davide Ferri and I did
about 17 months ago:

http://kernellabs.com/hg/~dheitmueller/pctv-340e-2/shortlog

I'm not against seeing the xc4000 support going in, but the history
needs to be preserved, which means it needs to be broken in to a patch
series that properly credits my and Davide's work.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
