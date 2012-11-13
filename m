Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40698 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2KMPCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 10:02:30 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so2236158qat.19
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 07:02:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <k7tkcu$m6j$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org>
Date: Tue, 13 Nov 2012 10:02:29 -0500
Message-ID: <CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com>
Subject: Re: Color problem with MPX-885 card (cx23885)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 9:10 AM, Neuer User <auslands-kv@gmx.de> wrote:
> Hello
>
> First of all, I don't know, if this is the right mailing list. I haven't
> found any other. The video4linux list seems to be abandoned.
>
> I am testing a Commell MPX-885 mini-pcie card, which is based on a
> cx23885 chip. There is "initial" support in the linux kernel for this card:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=2cb9ccd4612907c0a30de9be1c694672e0cd8933
>
> My system is based on Ubuntu 12.04LTS amd64 with kernel 3.2.0.32.

You should start by installing the current media_build tree.  There
were a bunch of cx23885 fixes done back in June, which won't be in
12.04.  I believe this issue may already be fixed.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
