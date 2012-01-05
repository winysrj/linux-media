Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53693 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2AEWsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 17:48:54 -0500
Received: by vbbfc26 with SMTP id fc26so778820vbb.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 14:48:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0627E5.9050004@yahoo.com>
References: <CAGoCfiw7c8=o5doJcYctmRbsj-idmxsRKVE5OzCOQ_xhLGBxMg@mail.gmail.com>
	<4F0627E5.9050004@yahoo.com>
Date: Thu, 5 Jan 2012 17:48:53 -0500
Message-ID: <CAGoCfixsMvcxAV2ww8KVCKGWdzX3dxjVu9coDN1Fi32a5jQHpQ@mail.gmail.com>
Subject: Re: Support for RC-6 in em28xx driver?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 5, 2012 at 5:44 PM, Chris Rankin <rankincj@yahoo.com> wrote:
> Hi,
>
> As someone who also owns a PCTV 290e device, I must agree that the remote
> control that it ships with is useless for VDR. Its biggest flaw is a lack of
> red, green, yellow and blue buttons, unlike the very nice remote control
> that ships with the Hauppauge NOVA-T2.
>
> Are you suggesting that the 290e could (potentially) use *any* NEC, RC-5 or
> RC-6/6A remote control, please? Because I would find that "useful"... ;-).

Hi Chris,

Yes, it can.  Like almost every IR receiver provided by the linux
media subsystem, the 290e is configured with the keymap of the
pinnacle remote *by default*.  There are userland tools (e.g.
ir-keytable) which allow you to load keymaps in for other remotes.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
