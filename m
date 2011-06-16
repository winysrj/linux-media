Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab1FPS2E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 14:28:04 -0400
Message-ID: <4DFA4B30.6020206@redhat.com>
Date: Thu, 16 Jun 2011 15:28:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com> <4DF8D37C.7010307@redhat.com> <4DF9F734.1090508@redhat.com> <4DFA1561.1030905@redhat.com> <4DFA1D05.6020004@redhat.com> <4DFA22A5.1080303@redhat.com> <4DFA4931.6070300@redhat.com>
In-Reply-To: <4DFA4931.6070300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-06-2011 15:19, Hans de Goede escreveu:
> Hi,

> 1) pass -alsa-pb hw.... to xawtv (requires no pulseaudio knowledge)
> 2) Set a different default alsa device in .alsarc
>    (requires no pulseaudio knowledge, trivial alsa knowledge)
> 3) Do rpm -e alsa-plugins-pulseaudio
> 
> Noe that 3 will permanently make any alsa using app use alsa directly
> instead of PA, which seems to be just what you want.

Even 3 still doesn't solve rmmod <alsa-module>

On desktops, an yum remove -y pulseaudio work, but bluetooth depends on it,
so this also doesn't provide a solution for notebooks.

Anyway, for now I'll do it on all my instances with pulseaudio, while
nobody provides a solution for rmmod.

Mauro.
