Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47739 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2FOLPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 07:15:53 -0400
Received: by obbtb18 with SMTP id tb18so3836904obb.19
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 04:15:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+MoWDq-exxGDbP4KjWJjU8RJKBb4vGO_Dk_C6UcGrzRmu-hiA@mail.gmail.com>
References: <CA+MoWDpfKTsW1YDwVwWYqDHrT=yXih6YVUtttSHerku83MSUGg@mail.gmail.com>
	<4FDA5B07.4040304@xenotime.net>
	<CA+MoWDq-exxGDbP4KjWJjU8RJKBb4vGO_Dk_C6UcGrzRmu-hiA@mail.gmail.com>
Date: Fri, 15 Jun 2012 08:15:53 -0300
Message-ID: <CALF0-+XLMpK=_Y7wqANyQYcQwJ2KZ7ZCB6csO59hu4i34VTvSg@mail.gmail.com>
Subject: Re: Patches
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Thu, Jun 14, 2012 at 9:23 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
>
> When I run it pointing to the patch, it also includes Julia Lawall and
> Greg Kroah-Hartman. See:
>
> $ scripts/get_maintainer.pl
> outgoing/0001-RESEND-cx231xx-Paranoic-stack-memory-save.patch
> Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT
> INFRA...,commit_signer:11/12=92%)
> Thomas Petazzoni <thomas.petazzoni@free-electrons.com> (commit_signer:3/12=25%)
> Devin Heitmueller <dheitmueller@kernellabs.com> (commit_signer:2/12=17%)
> Julia Lawall <julia@diku.dk> (commit_signer:1/12=8%)
> Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:1/12=8%)

My guess is that you have applied some patches from Greg and/or Julia
to your tree.
Keep in mind that get_maintainer.pl is just a script, that will go
through "git log" output
to tell you who has been working on some area.

On a personal note, I take get_maintainer.pl (along with
checkpatch.pl) as a **guide only**,
to tell me who should I send patches to.
I like to also search the mailing lists for recent patches to find
relevant people to put on cc.

Regards,
Ezequiel.
