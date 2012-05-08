Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48509 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab2EHCuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 22:50:23 -0400
Received: by yhmm54 with SMTP id m54so4894530yhm.19
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 19:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+X-uKkAK-wLNzG5kzYDvRsPLjfmM+GcBDfaVPC4GuGSEg@mail.gmail.com>
References: <CAPfPbo0V0v25PbUYXgiFxuS3w-J2u8U10Q9ebV_rJPBTmcOZUw@mail.gmail.com>
	<CAPfPbo0x7vWh_KjQXWBoU2AkKYu_7xbE1BKAX-5fLQJzdkg-mg@mail.gmail.com>
	<CALF0-+X-uKkAK-wLNzG5kzYDvRsPLjfmM+GcBDfaVPC4GuGSEg@mail.gmail.com>
Date: Mon, 7 May 2012 23:50:22 -0300
Message-ID: <CAPfPbo27LEjBnN3ZCH_OZi6M+9jwDpbC5+6hvYKJvd99RRCUmQ@mail.gmail.com>
Subject: Re: GENIUS TV-GO A12 tv analog card
From: =?ISO-8859-1?Q?Sebasti=E1n_Misuraca?= <smisuraca@3way.com.ar>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel,

Thanks for the reply.
I am going to watch the video and make the correct patch. When i
finished i will send again.

I have to improve mi english too. jeje
thanks.

2012/5/5 Ezequiel Garcia <elezegarcia@gmail.com>
>
> Hola Sebastián, :)
>
> On Fri, May 4, 2012 at 12:13 PM, Sebastián Misuraca
> <smisuraca@3way.com.ar> wrote:
> > Hi,
> >
> > I add a tv card support for saa7134 driver, the card name is "Genius
> > TV Go A12" and i test the RF capture with pal-nc and I test the
> > composite input too. I want to known if I would make a patch or what i
> > have to do to give us the patch. Here is the code:
> >
>
> This is not the right way to submit patches and probably
> maintainers won't apply it. For instance, your patch is not
> "unified style" (take a look at other patches).
>
> You should read Documentation/SubmittingPatches.
>
> Also, I think you will find much easier to use
> git-format-patch and git-send-email to create and
> send patches.
>
> Here is a talk that explains how to use it:
> "Write and Submit your first Linux kernel Patch"
> http://www.youtube.com/watch?v=LLBrBBImJt4
>
> If you have any doubts about this process feel free to ask,
> I'll be glad to help.
>
> Regards,
> Ezequiel.




--
Sebastián Misuraca
3waySolutions S.A.
TE: 5217-3330
www.3way.com.ar
