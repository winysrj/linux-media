Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53931 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2FMQgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 12:36:45 -0400
Received: by yenl2 with SMTP id l2so135796yen.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 09:36:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <76B80933-CE9A-4886-B4EB-22C26CAEC8E8@dinkum.org.uk>
References: <CAPz3gmnaPdm1V6GyPB8wPv5WCcg_pJ4HctsQiqROLanbLA=amA@mail.gmail.com>
	<BE0BB692-35BF-42C3-B2F1-5AC9AB053321@dinkum.org.uk>
	<CAPz3gmke-ASEXzhcqn+9R-5f10hrux3cqS1NAQ6VYmH3JSjb-Q@mail.gmail.com>
	<76B80933-CE9A-4886-B4EB-22C26CAEC8E8@dinkum.org.uk>
Date: Wed, 13 Jun 2012 18:36:44 +0200
Message-ID: <CAPz3gmnFsW4aVDEn-mydmNZf6ckH6oeE_Mqm5NEApmBsHkvz_Q@mail.gmail.com>
Subject: Re: Hauppauge WinTV Nova S Plus Composite IN
From: shacky <shacky83@gmail.com>
To: Andre <linux-media@dinkum.org.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Only to play with the volume= parameter, I'm sure you tried that, maybe there are some audio controls but I haven't found them. The VCR tapes I have to transfer have very quiet and muffled audio, old home videos so I thought the audio sounded ok.

Thank you very much.
I tried with the "volume=" parameter, but it seems to be useless.

I also see that I cannot use alsamixer with the capture device of the
audio card of the Nova-S, which is managed by the cx88-alsa module. I
cannot set any volume level, so I think it works at 100% every time,
and I cannot find any useful information on how to add the mixer
functionality to cx88-alsa module...
