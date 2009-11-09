Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:55908 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZKIUGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 15:06:35 -0500
Received: by gv-out-0910.google.com with SMTP id r4so296124gve.37
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 12:06:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <664add070911091203g3aeb0bf8tc54aa0d7f9037565@mail.gmail.com>
References: <303c92ca0911091106s72910abdmb0df8c3fa7a4cf1b@mail.gmail.com>
	 <303c92ca0911091113j5f181335w45518676330c5f32@mail.gmail.com>
	 <829197380911091141s4941cd08r2ddfb1457a1ced8a@mail.gmail.com>
	 <664add070911091203g3aeb0bf8tc54aa0d7f9037565@mail.gmail.com>
Date: Mon, 9 Nov 2009 15:06:39 -0500
Message-ID: <829197380911091206j5202512axa1ccf1c245c6d686@mail.gmail.com>
Subject: Re: Terratec Cinergy Hybrid T USB XS FM and 2.6.31 : no more support
	?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florent NOUVELLON <flonouvellon@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 3:03 PM, Florent NOUVELLON
<flonouvellon@gmail.com> wrote:
> Right, this was supported in em28xx-new project (for krnl 2.6.30), now
> aborted. I tried to make myself a dirty patch to 2.6.31but I lack competence
> to do that !
>
>
> Don't you think there could be a way to use previous em28xx-new data to hack
> kernel em28xx drivers ?
> I could make some test if you wish...

Probably.  I have no intention of going within ten miles of the
em28xx-new code though.  if you get your device working in the
mainline, feel free to submit patches and they will be merged
upstream.  I just don't have the time (nor the hardware) to dedicate
to getting that device to work.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
