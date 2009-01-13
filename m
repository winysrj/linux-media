Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:9581 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZAMXQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 18:16:55 -0500
Received: by qw-out-2122.google.com with SMTP id 3so95543qwe.37
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2009 15:16:54 -0800 (PST)
Message-ID: <412bdbff0901131516p44867478jdef953d0e8ccab66@mail.gmail.com>
Date: Tue, 13 Jan 2009 18:16:53 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Bastian Beekes" <bastian.beekes@gmx.de>
Subject: Re: MSI DigiVox A/D II
Cc: linux-media@vger.kernel.org
In-Reply-To: <496D1F1B.8080801@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <S1755369AbZAMWYU/20090113222421Z+45@vger.kernel.org>
	 <496D1C18.3010403@gmx.de>
	 <412bdbff0901131502g12d62917ka4fbebf7b74c6579@mail.gmail.com>
	 <496D1F1B.8080801@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 13, 2009 at 6:09 PM, Bastian Beekes <bastian.beekes@gmx.de> wrote:
> Hm, ok...
>
> thanks for your reply in *no time* :)
> So is the only option to upgrade to 8.10? I'd prefer to stick with the LTS
> release...
>
> Bastian

I suspect there is some hackary you could do if you install the kernel
source and recompile to include properly include CONFIG_SND, but
nobody ever went through the effort (as far as I know).  I believe
Markus did in his codebase, which is why he has been distributing
binaries for Ubuntu instead of having people build from source (but I
could be wrong there).

The core of the issue is Ubuntu provided an updated ALSA separate from
the rest of the kernel distro, but then screwed up the kernel headers
so that we think ALSA isn't present, so v4l-dvb doesn't compile any of
the alsa modules.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
