Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48087 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbZHWNmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 09:42:07 -0400
Received: by bwz19 with SMTP id 19so1087486bwz.37
        for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 06:42:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4fab9a6f0908221806k408047e6s83aa5c3902255eaa@mail.gmail.com>
References: <4fab9a6f0908221729n5410920fmd38bace3070105a3@mail.gmail.com>
	 <4fab9a6f0908221732g8e061f3t8fc871c3a0b36337@mail.gmail.com>
	 <829197380908221737h46f028ffu9b7a3b1e260f8c22@mail.gmail.com>
	 <4fab9a6f0908221806k408047e6s83aa5c3902255eaa@mail.gmail.com>
Date: Sun, 23 Aug 2009 09:42:07 -0400
Message-ID: <829197380908230642q55879fc5lcc61589b1a1b775a@mail.gmail.com>
Subject: Re: Kernel oops with em28xx device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Fau <dalamenona@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 22, 2009 at 9:06 PM, Fau<dalamenona@gmail.com> wrote:
> Hi Devin,
> in primis thank you for your help, it's a strange thing that the DVB
> is not working,
> in the past i used the em28xx-new and it worked very well, even for the DVB-T
> but now the mercurial repository is empty and the mailing list is
> dead, don't know what happened,
> anyway if you need some testing just ask,
> thank you again,

Markus decided to discontinue distributing his sources.

I've got some code that will make the DVB for this device work, I just
need to get the work finished (in particular, a firmware extract
script still needs to be written).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
