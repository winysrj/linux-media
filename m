Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1FNOg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 10:36:56 -0400
Message-ID: <4DF77229.2020607@redhat.com>
Date: Tue, 14 Jun 2011 16:37:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com>
In-Reply-To: <4DF76D88.5000506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/14/2011 04:17 PM, Mauro Carvalho Chehab wrote:
> Em 14-06-2011 10:52, Devin Heitmueller escreveu:

<snip>

> Yes.
>
> The default for capture is the one detected via sysfs.
>
> The default for playback is not really hw:0,0. It defaults to the first hw: that it is not
> associated with a video device.
>

I have a really weird idea, why not make the default output device be "default", so that
xawtv will use whatever the distro (or user if overriden by the user) has configured as
default alsa output device?

This will do the right thing for pulseaudio and not pulseaudio users alike.

Regards,

Hans
