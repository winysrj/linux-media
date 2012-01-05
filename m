Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55986 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2AEWv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 17:51:27 -0500
Received: by vbbfc26 with SMTP id fc26so780144vbb.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 14:51:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixsMvcxAV2ww8KVCKGWdzX3dxjVu9coDN1Fi32a5jQHpQ@mail.gmail.com>
References: <CAGoCfiw7c8=o5doJcYctmRbsj-idmxsRKVE5OzCOQ_xhLGBxMg@mail.gmail.com>
	<4F0627E5.9050004@yahoo.com>
	<CAGoCfixsMvcxAV2ww8KVCKGWdzX3dxjVu9coDN1Fi32a5jQHpQ@mail.gmail.com>
Date: Thu, 5 Jan 2012 17:51:26 -0500
Message-ID: <CAGoCfiyz+Uy9b8CP7N-BZd0M=J=55aKr0LpWi7AqAtKQYXN+Mw@mail.gmail.com>
Subject: Re: Support for RC-6 in em28xx driver?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 5, 2012 at 5:48 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Yes, it can.  Like almost every IR receiver provided by the linux
> media subsystem, the 290e is configured with the keymap of the
> pinnacle remote *by default*.  There are userland tools (e.g.
> ir-keytable) which allow you to load keymaps in for other remotes.

I should clarify my previous statement by saying that the support for
other remotes is constrained by what the hardware supports.  If the IR
receiver hardware only supports RC5 and NEC, then you can't use an RC6
remote with it.

But to your point, I actually used my Hauppauge remote when I
originally wrote the em2874 IR support (and only at the end
reconfigured it to use the PCTV remote).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
