Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49664
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759256AbcIHSde (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 14:33:34 -0400
Date: Thu, 8 Sep 2016 15:33:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Chris Mayo <aklhfex@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
Message-ID: <20160908153327.545961df@vento.lan>
In-Reply-To: <CAA7C2qh-XGBxsZk_GdO+Oj2Q8x9SqA1XOAb+b0ZRbsNCR2eesw@mail.gmail.com>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
        <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
        <20160824114927.3c6ab0d6@vento.lan>
        <20160824115241.7e2c90ca@vento.lan>
        <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de>
        <20160905102511.6de3dbe4@vento.lan>
        <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com>
        <20160906064108.5bd84045@vento.lan>
        <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com>
        <20160906124723.6783fd39@vento.lan>
        <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
        <CAA7C2qh-XGBxsZk_GdO+Oj2Q8x9SqA1XOAb+b0ZRbsNCR2eesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 7 Sep 2016 10:59:32 -0700
VDR User <user.vdr@gmail.com> escreveu:

> I use nscan, which has easily been the
> most successful of the scanners. An additional benefit to nscan is you
> only supply a single transponder on the command line and it will
> populate a channel list for the entire sat. You don't need to supply
> an entire list of transponders to scan.

Well, AFAIKT, nowadays, almost all scanners need just one frequency for
satellite and cable to get all channels (and even for some DVB-T/T2
broadcasters, but this is a way more commonly found on DVB-S/S2/C).

If the extra transponders are listed via other NIT tables (it depends on
the broadcaster), an extra parameter is needed (-N, in the case of
dvbv5-scan), as the scan time per channel increases a lot if it has to
wait to receive all NIT tables. So, most scanners default to use just
the main NIT table, providing an option to parse the other ones.


Thanks,
Mauro
