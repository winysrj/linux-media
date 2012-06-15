Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51666 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2FOAXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 20:23:09 -0400
Received: by wibhj8 with SMTP id hj8so17011wib.1
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 17:23:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FDA5B07.4040304@xenotime.net>
References: <CA+MoWDpfKTsW1YDwVwWYqDHrT=yXih6YVUtttSHerku83MSUGg@mail.gmail.com>
	<4FDA5B07.4040304@xenotime.net>
Date: Thu, 14 Jun 2012 21:23:01 -0300
Message-ID: <CA+MoWDq-exxGDbP4KjWJjU8RJKBb4vGO_Dk_C6UcGrzRmu-hiA@mail.gmail.com>
Subject: Re: Patches
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Randy,

>> ./scripts/get_maintainer.pl  -f drivers/media/video/cx231xx/
> Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT INFRA...,commit_signer:23/24=96%)
> Devin Heitmueller <dheitmueller@kernellabs.com> (commit_signer:4/24=17%)
> Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:4/24=17%)
> Thomas Petazzoni <thomas.petazzoni@free-electrons.com> (commit_signer:4/24=17%)
> linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
> linux-kernel@vger.kernel.org (open list)

When I run it pointing to the patch, it also includes Julia Lawall and
Greg Kroah-Hartman. See:

$ scripts/get_maintainer.pl
outgoing/0001-RESEND-cx231xx-Paranoic-stack-memory-save.patch
Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT
INFRA...,commit_signer:11/12=92%)
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> (commit_signer:3/12=25%)
Devin Heitmueller <dheitmueller@kernellabs.com> (commit_signer:2/12=17%)
Julia Lawall <julia@diku.dk> (commit_signer:1/12=8%)
Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:1/12=8%)
linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
linux-kernel@vger.kernel.org (open list)

The patch was sent to all people above but Greg did not get it due
invalid E-mail. I've removed linux-kernel@vger.kernel.org list.

>
>
> That (above) should be enough.
> If you feel that you need to copy GregKH on the patches, his current
> email address is in the MAINTAINERS file.
I feel there is no need of sending the patch to him, but I'm not sure
about the need of reporting the broken E-mail.

>
>
> thanks,
> --
> ~Randy

Thanks,

Peter

-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
