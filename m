Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58961 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab2F2RKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 13:10:53 -0400
Received: by ghrr11 with SMTP id r11so2943356ghr.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 10:10:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206291649.000461@ms2.cniteam.com>
References: <201206291649.000461@ms2.cniteam.com>
Date: Fri, 29 Jun 2012 13:10:51 -0400
Message-ID: <CAGoCfiwqJ93O5iHW96tJHFZ7uNdvKAwk==3R2YGUnwy=i-rQPg@mail.gmail.com>
Subject: Re: AverTVHD Volar Max (h286DU)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: aschuler@bright.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 29, 2012 at 12:49 PM,  <aschuler@bright.net> wrote:
> Hello all,
>
> I'm currently working on an automated process to increase the
> number of online Closed Captions for the hearing-impaired
> community on a popular video-streaming service. I've had a
> successful proof-of-concept on mac and PC platforms, but to
> take this process to scale, I'd like to design a linux
> solution.
>
> The device I'm currently using is the AverTVHD Volar Max
> (h286DU). I've attempted to use the Aver-supplied drivers in
> Ubuntu 10.4 and 9.10 to no avail. Any help in developing a
> working driver / installation method for my device would be
> greatly appreciated by me, and, potentially, a very large and
> very under-represented audience of hard-of-hearing.
>
> Thanks for any support in this matter, and for all the
> development done up to this point.

Given you're looking to do this on a large scale, you might be better
suited to choose a device that is actively maintained by the LinuxTV
community rather than a device that the vendor shipped a driver for
years ago, is not in the mainline kernel, and as far as I know doesn't
work with current kernels.

Just a suggestion though.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
