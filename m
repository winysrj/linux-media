Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671Ab1FPSSw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 14:18:52 -0400
Message-ID: <4DFA4931.6070300@redhat.com>
Date: Thu, 16 Jun 2011 20:19:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com> <4DF8D37C.7010307@redhat.com> <4DF9F734.1090508@redhat.com> <4DFA1561.1030905@redhat.com> <4DFA1D05.6020004@redhat.com> <4DFA22A5.1080303@redhat.com>
In-Reply-To: <4DFA22A5.1080303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/16/2011 05:35 PM, Mauro Carvalho Chehab wrote:
> Em 16-06-2011 12:11, Hans de Goede escreveu:

<snip>

> While developers are not comfortable with pulseaudio, turning it into a default
> is a bad idea.
>

1) Some developers are fine with pulseaudio, so please speak on behalf of
    yourself rather then of "developers". Disclaimer I've written patches
    to the alsa code for many a program to work properly with pulseaudio's
    alsa glue layer as well as (re)written the SDL pulseaudio backend.

2) Developers who are not comfortable with pulseaudio now, should better
    learn pulseaudio since that is what the majority of our users are using

3) I'm not making pulseaudio default *at all*. I'm making the "default"
    alsa device the default. Which seems like a very sane default to me.

Does your "default" alsa device happen to point to pulseaudio, and you
don't want that, plenty of options:

1) pass -alsa-pb hw.... to xawtv (requires no pulseaudio knowledge)
2) Set a different default alsa device in .alsarc
    (requires no pulseaudio knowledge, trivial alsa knowledge)
3) Do rpm -e alsa-plugins-pulseaudio

Noe that 3 will permanently make any alsa using app use alsa directly
instead of PA, which seems to be just what you want.

Regards,

Hans
