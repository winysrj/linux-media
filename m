Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55609 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab2EEQi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 12:38:56 -0400
Received: by obbtb18 with SMTP id tb18so5643306obb.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 09:38:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPfPbo0x7vWh_KjQXWBoU2AkKYu_7xbE1BKAX-5fLQJzdkg-mg@mail.gmail.com>
References: <CAPfPbo0V0v25PbUYXgiFxuS3w-J2u8U10Q9ebV_rJPBTmcOZUw@mail.gmail.com>
	<CAPfPbo0x7vWh_KjQXWBoU2AkKYu_7xbE1BKAX-5fLQJzdkg-mg@mail.gmail.com>
Date: Sat, 5 May 2012 13:38:56 -0300
Message-ID: <CALF0-+X-uKkAK-wLNzG5kzYDvRsPLjfmM+GcBDfaVPC4GuGSEg@mail.gmail.com>
Subject: Re: GENIUS TV-GO A12 tv analog card
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Sebasti=E1n_Misuraca?= <smisuraca@3way.com.ar>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hola Sebastián, :)

On Fri, May 4, 2012 at 12:13 PM, Sebastián Misuraca
<smisuraca@3way.com.ar> wrote:
> Hi,
>
> I add a tv card support for saa7134 driver, the card name is "Genius
> TV Go A12" and i test the RF capture with pal-nc and I test the
> composite input too. I want to known if I would make a patch or what i
> have to do to give us the patch. Here is the code:
>

This is not the right way to submit patches and probably
maintainers won't apply it. For instance, your patch is not
"unified style" (take a look at other patches).

You should read Documentation/SubmittingPatches.

Also, I think you will find much easier to use
git-format-patch and git-send-email to create and
send patches.

Here is a talk that explains how to use it:
"Write and Submit your first Linux kernel Patch"
http://www.youtube.com/watch?v=LLBrBBImJt4

If you have any doubts about this process feel free to ask,
I'll be glad to help.

Regards,
Ezequiel.
