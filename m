Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58450 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZKITlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 14:41:51 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so3840205bwz.21
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 11:41:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <303c92ca0911091113j5f181335w45518676330c5f32@mail.gmail.com>
References: <303c92ca0911091106s72910abdmb0df8c3fa7a4cf1b@mail.gmail.com>
	 <303c92ca0911091113j5f181335w45518676330c5f32@mail.gmail.com>
Date: Mon, 9 Nov 2009 14:41:56 -0500
Message-ID: <829197380911091141s4941cd08r2ddfb1457a1ced8a@mail.gmail.com>
Subject: Re: Terratec Cinergy Hybrid T USB XS FM and 2.6.31 : no more support
	?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florent nouvellon <flonouvellon@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 2:13 PM, Florent nouvellon
<flonouvellon@gmail.com> wrote:
> Hi,
>
> Terratec Cinergy Hybrid T USB XS FM is fully supported by em28xx-new
> project, but em28xx-new project is no more supported and not compatible with
> kernel 2.6.31.
> Is this hardware still supported ?

This device has never been supported in the mainline kernel.  I don't
foresee it getting implemented anytime soon since I don't have a board
to debug/test with (and since this is the first instance where we
would be doing xc5000 on em28xx, I wanted to have a unit I could debug
personally).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
