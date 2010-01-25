Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:48704 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0AYUcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 15:32:42 -0500
Received: by fxm20 with SMTP id 20so4000414fxm.21
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 12:32:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bcb3ef431001251222x364c5d6fvd8d07498353ed518@mail.gmail.com>
References: <4B578073.4030103@googlemail.com> <4B588FDE.3090203@googlemail.com>
	 <bcb3ef431001251222x364c5d6fvd8d07498353ed518@mail.gmail.com>
Date: Mon, 25 Jan 2010 21:32:40 +0100
Message-ID: <bcb3ef431001251232t438a26dctdacdfdcfbac51547@mail.gmail.com>
Subject: Re: Remote for Terratec Cinergy C PCI HD (DVB-C)
From: MartinG <gronslet@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2010 at 9:22 PM, MartinG <gronslet@gmail.com> wrote:
> Hi, I've got the exact same device as you, use the s2-liplianin
> driver, and after reading your post I tried the remote as well.
> But how do I configure it? Some of the keys are working (arrow keys,
> numeric keys, Home, volume, mute), but not all.
> Is the remote handled as an input device by X itself? So what file(s)
> do I need to change/update?
>
> If you have some working config files, or a nice link, I'd appreciate it :)

Replying to myself; I found that 'xev' give the keycodes for most of
the keys, but not eg. the "OK" key, wich is quite important. Is there
a way to add those? Something I can contribute? Where? :)

And by the way - I too really appreciate the work on the mantis driver!

Best,
MartinG
