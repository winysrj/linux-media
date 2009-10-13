Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:47983 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760322AbZJMPfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:35:50 -0400
Received: by qw-out-2122.google.com with SMTP id 9so915115qwb.37
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 08:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD3962A.9010209@sagurna.de>
References: <4AD3962A.9010209@sagurna.de>
Date: Tue, 13 Oct 2009 11:34:42 -0400
Message-ID: <bb40fe370910130834m79d25097y399aac0557ac8886@mail.gmail.com>
Subject: Re: Bug in HVR1300. Found part of a patch, if reverted bug seems to
	be gone [spam-bayes][heur][spf]
From: Steven Toth <stoth@hauppauge.com>
To: Frank Sagurna <frank@sagurna.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 4:48 PM, Frank Sagurna <frank@sagurna.de> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi list,
>
> there seems to be a bug in cx88 (HVR1300) that is responsible for not
> switching channels, and not being able to scan.
> Complete description can be found on launchpad:
>
> https://bugs.launchpad.net/mythtv/+bug/439163 (starting from comment #16)
>
> Anyway, i digged it down to this patch:
> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg02195.html
>
> When reverting the following part of the patch it starts working again:
>
> snip----------

Thanks Frank. I'll pick up this patch and start the merge process.

Regards,

- Steve
