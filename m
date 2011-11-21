Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1KUVVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:21:33 -0500
Received: by mail-yw0-f46.google.com with SMTP id 32so5170847ywt.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:21:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9+e0K__EWdc=ckHURjjYMbez22=xup0d7=H7k2xQNVnyw@mail.gmail.com>
References: <CAHFNz9+e0K__EWdc=ckHURjjYMbez22=xup0d7=H7k2xQNVnyw@mail.gmail.com>
Date: Mon, 21 Nov 2011 16:21:32 -0500
Message-ID: <CAOcJUbyPPJe_ONV5bOXx_r+cwNd43eyThyRrawA0Gi1JydQV=Q@mail.gmail.com>
Subject: Re: PATCH 04/13: 0004-TDA18271-Allow-frontend-to-set-DELSYS
From: Michael Krufky <mkrufky@linuxtv.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you, Manu... After the Linux Kernel Summit in Prague, I had
intentions of solving this exact problem, but you did it first -- good
job!

I have reviewed the patch to the tda18271 driver, and the changes make
good sense to me.  I have one question, however:

Perhaps my eyes have overlooked something -- I fail to see any code
that defines the new "set_state" callback or any code that calls this
new callback within dvb-core (assuming dvb_frontend.c)  I also can't
find the structure declaration of the "tuner_state" struct... ... is
this patch missing from your series, or did I just overlook it?

That missing patch is what interests me most.  Once I can see that
missing code, I'd like to begin discussion on whether we actually need
the additional callback, or if it can simply be handled by the
set_params call.  Likewise, I'm not exactly sure why we need this
affional "struct tuner_state" ...  Perhaps the answer will be
self-explanatory once I see the code - maybe no discussion is
necessary :-P

But this does look good to me so far.  I'd be happy to provide my
"reviewed-by" tag once I can see the missing code mentioned above.

Best regards,

Michael Krufky

On Mon, Nov 21, 2011 at 4:06 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>
>
