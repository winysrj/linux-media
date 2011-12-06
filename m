Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58048 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1LFPfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 10:35:42 -0500
Received: by ggnr5 with SMTP id r5so6398938ggn.19
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2011 07:35:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EDE34B7.9030609@teksavvy.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
	<1321800978-27912-2-git-send-email-mchehab@redhat.com>
	<1321800978-27912-3-git-send-email-mchehab@redhat.com>
	<1321800978-27912-4-git-send-email-mchehab@redhat.com>
	<1321800978-27912-5-git-send-email-mchehab@redhat.com>
	<CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
	<4EDD0F01.7040808@redhat.com>
	<CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com>
	<CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com>
	<CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com>
	<CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com>
	<4EDE0FD7.4020603@teksavvy.com>
	<4EDE1C0C.2060701@redhat.com>
	<CAGoCfizuMQMz3_ihh1AB2uRUn5-1DkCVju1VFMzOnUkqA+tJJQ@mail.gmail.com>
	<4EDE34B7.9030609@teksavvy.com>
Date: Tue, 6 Dec 2011 10:35:41 -0500
Message-ID: <CAGoCfiyXcpWQ24sEVk1O3x8mHZeOk6BdUS=n9VcMbR-FBQojCA@mail.gmail.com>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE
 HVR-930C again
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 6, 2011 at 10:28 AM, Mark Lord <kernel@teksavvy.com> wrote:
> It's always exhibited races for me here.  I have long since worked around
> the issue(s), so my own systems currently behave.   But with the newer
> HVR-950Q revision (B4F0), the issue is far more prevalent than before.

I'll ask around and see if I can find out what they changed in the
B4F0 revision.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
