Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934328Ab1JaLrr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 07:47:47 -0400
Message-ID: <4EAE8AC8.603@redhat.com>
Date: Mon, 31 Oct 2011 09:47:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 4/14] staging/media/as102: checkpatch fixes
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl> <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein> <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com> <4E9ADFAE.8050208@redhat.com> <20111018094647.d4982eb2.chmooreck@poczta.onet.pl> <20111018111151.635ac39e.chmooreck@poczta.onet.pl> <20111018215146.1fbc223f@darkstar> <4EABD3E2.3070302@gmail.com> <4EABFCF8.2010003@poczta.onet.pl> <4EAC2676.8030808@gmail.com> <4EAC3C57.5070701@poczta.onet.pl> <4EAC7214.5030008@gmail.com> <20111030081156.14b70914@darkstar> <20111030121710.73f9ee11@stein> <4EAE7CE4.10809@s5r6.in-berlin.de>
In-Reply-To: <4EAE7CE4.10809@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-10-2011 08:48, Stefan Richter escreveu:
>> On Oct 30 Piotr Chmura wrote:
>>> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
>>>
>>> Original source and comment:
>>> # HG changeset patch
> 
> By the way, the brand new git 1.7.8.rc0 features some HG support in "git am":
> https://code.google.com/p/git-core/source/detail?spec=svnbe3fa9125e708348c7baf04ebe9507a72a9d1800&r=0cfd112032017ab68ed576f6bb5258452084ebf1
> 
> This converts the "# User" and "# Date" lines of HG patches into RFC 2822
> "From: " and "Date: " lines which are then used as authorship metadata.

hg headers are fine. As we moved from hg a few years, the scripts I use here already
handles hg headers, converting them to rfc-2822 (it also does other neat things like
calling checkpatch.pl ;) ).

Cheers,
Mauro

