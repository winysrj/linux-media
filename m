Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36816 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab1BXUj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 15:39:28 -0500
Received: by iwn34 with SMTP id 34so529464iwn.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 12:39:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110221214906.GA27284@mess.org>
References: <20110221214906.GA27284@mess.org>
Date: Thu, 24 Feb 2011 12:39:27 -0800
Message-ID: <AANLkTi=oQvwvMxrXvPEyX02cQApek0gVh5oJbWaiRmV0@mail.gmail.com>
Subject: Re: [PATCH] DVB USB should not depend on RC
From: VDR User <user.vdr@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 21, 2011 at 1:49 PM, Sean Young <sean@mess.org> wrote:
> I have a SheevaPlug which has no (human) input or output devices, with a
> DVB USB device connected with a mythtv backend running. The DVB USB drivers
> pull in the remote control tree, which is unneeded in this case; the
> mythtv client runs elsewhere (where RC is used). However the RC tree depends
> on input which also has dependants.
>
> This can save a reasonable amount of memory:
>
>  $ ./scripts/bloat-o-meter vmlinux vmlinux-no-rc add/remove: 0/909 grow/shrink: 1/20 up/down: 4/-159171 (-159167)
>
> Diff against current mainline.
>
> Signed-off-by: Sean Young <sean@mess.org>

I'm one of those people with a usb device that doesn't have rc/input
capabilities and would like to see this dependency fixed.  Has anyone
confirmed the patch is working?
