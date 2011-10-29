Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34449 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1J2KWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 06:22:33 -0400
Received: by faan17 with SMTP id n17so4282724faa.19
        for <linux-media@vger.kernel.org>; Sat, 29 Oct 2011 03:22:32 -0700 (PDT)
Message-ID: <4EABD3E2.3070302@gmail.com>
Date: Sat, 29 Oct 2011 12:22:26 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Piotr Chmura <chmooreck@poczta.onet.pl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [RESEND PATCH 4/14] staging/media/as102: checkpatch fixes
References: <4E7F1FB5.5030803@gmail.com>	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>	<4E7FF0A0.7060004@gmail.com>	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>	<20110927094409.7a5fcd5a@stein>	<20110927174307.GD24197@suse.de>	<20110927213300.6893677a@stein>	<4E999733.2010802@poczta.onet.pl>	<4E99F2FC.5030200@poczta.onet.pl>	<20111016105731.09d66f03@stein>	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>	<4E9ADFAE.8050208@redhat.com>	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>	<20111018111151.635ac39e.chmooreck@poczta.onet.pl> <20111018215146.1fbc223f@darkstar>
In-Reply-To: <20111018215146.1fbc223f@darkstar>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2011 09:51 PM, Piotr Chmura wrote:
> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> 
> Original source and comment:
> # HG changeset patch
> # User Devin Heitmueller<dheitmueller@kernellabs.com>
> # Date 1267318701 18000
> # Node ID 69c8f5172790784738bcc18f8301919ef3d5373f
> # Parent  b91e96a07bee27c1d421b4c3702e33ee8075de83
> as102: checkpatch fixes
> 
> From: Devin Heitmueller<dheitmueller@kernellabs.com>
> 
> Fix make checkpatch issues reported against as10x_cmd.c.
> 
> Priority: normal
> 
> Signed-off-by: Devin Heitmueller<dheitmueller@kernellabs.com>
> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>

Hi Piotr,

starting from this patch the series doesn't apply cleanly to
staging/for_v3.2 tree. Which branch is it based on ?

---
Thanks,
Sylwester
