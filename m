Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58731 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZJWOsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 10:48:35 -0400
Received: by bwz27 with SMTP id 27so944519bwz.21
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 07:48:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56601b784c3fd9cde05d75ad15ca98a9.squirrel@squirrel-webmail.surftown.com>
References: <56601b784c3fd9cde05d75ad15ca98a9.squirrel@squirrel-webmail.surftown.com>
Date: Fri, 23 Oct 2009 10:48:38 -0400
Message-ID: <829197380910230748s697f9efdtaebdf67ba3eed780@mail.gmail.com>
Subject: Re: Pinnacle PCTV DVB-T support.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: mark@spanberg.se
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 23, 2009 at 10:12 AM,  <mark@spanberg.se> wrote:
> Hi!
>
> I found my old Pinnacle PCTV DVB-T card and thought I might put it to use.
> Since I have used it on linux before (about two years ago) with the em28xx
> driver I didn't think it would be any problems.
>
> However I can't seem to get it to work.
<snip>

Yes, that particular board is known to not work.  I never got around
to adding the support for the mainline driver.  I started to work on
it with a user earlier in the year, but I couldn't get it to work
immediately and since I didn't have the hardware I couldn't really
debug it further without a level of effort that wasn't worth my time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
