Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab0JLDTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 23:19:41 -0400
Received: by fxm4 with SMTP id 4so822321fxm.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 20:19:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimabbX5PzA_ozkuuv5=CQGEr-hw_bzHynum8cFU@mail.gmail.com>
References: <AANLkTima57h2Zz23y885AnyzWJOOUNWZxzt4o4gRjaUX@mail.gmail.com>
	<4CB37BB6.4050307@infradead.org>
	<4CB38A7C.5040603@redhat.com>
	<AANLkTimabbX5PzA_ozkuuv5=CQGEr-hw_bzHynum8cFU@mail.gmail.com>
Date: Mon, 11 Oct 2010 20:19:38 -0700
Message-ID: <AANLkTin1bJWMZ0G+8a2wnsYmvEtZPWv7WtgwXmOyyNC9@mail.gmail.com>
Subject: Re: [PULL] http://kernellabs.com/hg/~stoth/saa7164-v4l
From: Gavin Hurlbut <gjhurlbu@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I replied earlier, but due to gmail wanting to send HTML mail by
default (grr), it bounced when sending to the list....   Original
reply (slightly reformatted) follows:

>    commit 86ae40b5f3da13c5fd0c70731aac6447c6af4cd8
>    Author: Gavin Hurlbut <gjhurlbu@gmail.com>
>    Date:   Thu Sep 30 18:21:20 2010 -0300
>
>    V4L/DVB: Fix the -E{*} returns in the VBI device as well
>
>    commit f92f45822ce73cfc4bde8d61a75598fb9db35d6b
>    Author: Gavin Hurlbut <gjhurlbu@gmail.com>
>    Date:   Wed Sep 29 15:18:20 2010 -0300
>
>    V4L/DVB: Fix the negative -E{BLAH} returns from fops_read
>
>    commit 25b5ab78a5240c82baa78167e55c8d74a6e0a276
>    Author: Gavin Hurlbut <gjhurlbu@gmail.com>
>    Date:   Mon Sep 27 23:50:43 2010 -0300
>
>    V4L/DVB: Change the second input names to include " 2" to distinguish them
>
> Those three patches are missing your Signed-off-by: and Gavin's Signed-off-by:
>
> Could you please provide it?

Chock those up to me missing putting the Signed-off-by: lines in the
patches I sent to Steven due to me being new to mercurial.  Is there a
way for me to add it posthumously, as it were?  I'll be sure to add
that in any future patches, and I apologize for the oversight.  It
would be (for all three patches):

Signed-off-by: Gavin Hurlbut <gjhurlbu@gmail.com>
