Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33105 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2LMR4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 12:56:48 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1257141bkw.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 09:56:47 -0800 (PST)
Message-ID: <50CA16EB.7060201@googlemail.com>
Date: Thu, 13 Dec 2012 18:56:59 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/9] em28xx: refactor the frame data processing code
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com> <CAGoCfiw1wN+KgvNLqDSmbz5AwswPT9K48XOM4RnfKvHkmmR59g@mail.gmail.com>
In-Reply-To: <CAGoCfiw1wN+KgvNLqDSmbz5AwswPT9K48XOM4RnfKvHkmmR59g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.12.2012 18:36, schrieb Devin Heitmueller:
> On Sat, Dec 8, 2012 at 10:31 AM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> This patch series refactors the frame data processing code in em28xx-video.c to
>> - reduce code duplication
>> - fix a bug in vbi data processing
>> - prepare for adding em25xx/em276x frame data processing support
>> - clean up the code and make it easier to understand
> Hi Frank,
>
> Do you have these patches in a git tree somewhere that I can do a git
> pull from?  If not then that's fine - I'll just save off the patches
> and apply them by hand.

No, I have no public git tree.

> I've basically got your patches, fixes Hans did for v4l2 compliance,
> and I've got a tree that converts the driver to videobuf2 (which
> obviously heavily conflicts with the URB handler cleanup you did).
> Plan is to suck them all into a single tree, deal with the merge
> issues, then issue a pull request to Mauro.

Ahhh, videobuf2 !
Good to know, because I've put this on my TODO list... ;)
Yes, there will likely be heavy merge conflicts...
In which tree are the videobuf2 patches ?

Regards,
Frank

>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

