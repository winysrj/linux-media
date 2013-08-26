Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:44887 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3HZNs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 09:48:26 -0400
Received: by mail-we0-f181.google.com with SMTP id q57so2693149wes.40
        for <linux-media@vger.kernel.org>; Mon, 26 Aug 2013 06:48:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130822152331.6e186acd@samsung.com>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost> <20130801141518.258ff0a3@samsung.com>
 <CAER7dwe9biLNZKtW6xQmD8J0Qmh4dMTi=chpUuQ_Dq5KKxJ5UQ@mail.gmail.com>
 <20130805172605.1ba32958@samsung.com> <CAER7dwcDxa4=i453tOU21ZJP9Opd01mZ-QYrLpQTcgB_yU4B+Q@mail.gmail.com>
 <CAJmEX9B=VAEXSto2omRTNcgVdX7akDBUAhJs7nwPUc9xhqFBbg@mail.gmail.com> <20130822152331.6e186acd@samsung.com>
From: Luis Polasek <lpolasek@gmail.com>
Date: Mon, 26 Aug 2013 10:48:05 -0300
Message-ID: <CAER7dwfb6gtqoHh7cx7xgsVtXszsan6nx_CZgCnpBzKbadRvMg@mail.gmail.com>
Subject: Re: dib8000 scanning not working on 3.10.3
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?ISO-8859-1?Q?Javier_B=FAcar?= <jbucar@lifia.info.unlp.edu.ar>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 22, 2013 at 3:23 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Thu, 22 Aug 2013 14:47:33 -0300
> Javier Búcar <jbucar@lifia.info.unlp.edu.ar> escreveu:
>
>> Hello Mauro, we have the bad commit:
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=173a64cb3fcff1993b2aa8113e53fd379f6a968f
>>
>> This is a very big commit. I don't known where to fix it. Can you help
>> me on fixing it
>
> Hmm.... So, the error is on this patch?
>
>         author  Patrick Boettcher <pboettcher@kernellabs.com>   2013-04-22 15:45:52 (GMT)
>         [media] dib8000: enhancement
>
>         The intend of this patch is to improve the support of the dib8000.
>
>         Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
>         Signed-off-by: Patrick Boettcher <patrick.boettcher@parrot.com>
>         Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> If so, then we need either Olivier or Patrick's help, as I don't have any
> documentation about the dib8000 chips.
>
> You can still take a look there at the code that checks for the
> chipset version, like:
>         if (state->revision == 0x8090) {
>                 <some code for newer version>
>         } else {
>                 <some code for the old version>
>         }
>
> If the code for the old version remains the same as before the patch.
> Where it doesn't remains the same, then it could be the source of the
> troubles.
>
> I suggest you to check what state->revision shows on your specific device,
> in order to do such analysis.
>
> I'll try latter to do some tests with the devices I have, but this could
> take some time, as I'm really busy those days.

The PixelView DiB8000B revision is:
   Vendor ID: 0x1b3
   Product ID: 0x8001

Thanks and regards...
