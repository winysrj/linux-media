Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40285
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932874AbcIFPr3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 11:47:29 -0400
Date: Tue, 6 Sep 2016 12:47:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: Chris Mayo <aklhfex@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
Message-ID: <20160906124723.6783fd39@vento.lan>
In-Reply-To: <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
        <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
        <20160824114927.3c6ab0d6@vento.lan>
        <20160824115241.7e2c90ca@vento.lan>
        <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de>
        <20160905102511.6de3dbe4@vento.lan>
        <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com>
        <20160906064108.5bd84045@vento.lan>
        <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Sep 2016 08:16:22 -0700
VDR User <user.vdr@gmail.com> escreveu:

> I can tell you that people do still use VDR-1.6.0-3. It would be
> unwise (and unnecessary) to break backwards compatible, which would be
> grounds for NACK if you ask me. Knowingly causing breakage has always
> been an unpopular thing in the VDR community, and this sounds like
> it's going beyond fixing a small issue to fixing it til it breaks.

Well, the libdvbv5 VDR output support was written aiming VDR version 2.1.6.
I've no idea if it works with VDR 1.6.0. Don't remember if I tested support
for such version when I wrote the code.

Also, as it seems that VDR 1.6.0 was released in 2008, it probably won't
support DVB-T2 (with was added in 2011) and may not support DVB-S2
(added in 2008, but support for DTV_STREAM_ID seems to be added only
in 2012).

So, at least for DVB-T2/DVB-S2, people likely need some version newer
than VDR 1.6.0 for full support. If so, the changes proposed by Markus
and Chris won't be disruptive for 1.6, as they seem to be touching only
on DVB-T2 and DVB-S2 support, right?

Please correct me if I'm wrong.

Thanks,
Mauro
