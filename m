Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43941 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2GFUEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 16:04:31 -0400
Received: by yhmm54 with SMTP id m54so9788269yhm.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 13:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF73EE1.7050106@redhat.com>
References: <4FECCCB4.9000402@gmail.com>
	<4FED2CA0.6020909@redhat.com>
	<4FED314D.8020900@gmail.com>
	<4FF73EE1.7050106@redhat.com>
Date: Fri, 6 Jul 2012 16:04:30 -0400
Message-ID: <CAGoCfizNuWic0q08FW980tArKOgkut0-V_2JnA5311vq_OD=Dw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add support for newer PCTV 800i cards with s5h1411 demodulators
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mack Stanley <mcs1937@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 6, 2012 at 3:39 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 29-06-2012 01:38, Mack Stanley escreveu:
>> I'm sorry to have missed the word-wrap.  Here's a new copy. ---Mack
>>
>> Testing needed on older (Pinnacle) PCTV 800i cards with S5H1409 demodulators
>> to check that current support for them isn't broken by this patch.
>>
>> Signed-off-by: Mack Stanley <mcs1937@gmail.com>
>> ---
>>   drivers/media/video/cx88/cx88-dvb.c |   40
>> ++++++++++++++++++++++++----------
>
>
> It is still completely mangled. It is impossible to apply it this way.
>
> Regards,
> Mauro

Mack,

Assuming this is a git tree, just use "git format-patch" followed by
"git send-email".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
