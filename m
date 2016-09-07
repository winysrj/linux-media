Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35079 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcIGR7e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 13:59:34 -0400
Received: by mail-it0-f50.google.com with SMTP id e124so211729199ith.0
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 10:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
 <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
 <20160824114927.3c6ab0d6@vento.lan> <20160824115241.7e2c90ca@vento.lan>
 <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de> <20160905102511.6de3dbe4@vento.lan>
 <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com> <20160906064108.5bd84045@vento.lan>
 <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com>
 <20160906124723.6783fd39@vento.lan> <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
From: VDR User <user.vdr@gmail.com>
Date: Wed, 7 Sep 2016 10:59:32 -0700
Message-ID: <CAA7C2qh-XGBxsZk_GdO+Oj2Q8x9SqA1XOAb+b0ZRbsNCR2eesw@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Chris Mayo <aklhfex@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> It is broken (see below). Have you ever used dvbv5 tools with vdr format
> output or did you know a "VDR user" who is using dvbv5-scan and not wscan?

In my experience the v4l scanner, wscan, and VDR's internal scanner
has never worked well (for NA). I use nscan, which has easily been the
most successful of the scanners. An additional benefit to nscan is you
only supply a single transponder on the command line and it will
populate a channel list for the entire sat. You don't need to supply
an entire list of transponders to scan.

As far as other VDR users, of which I know many being a long time
user, they tend to use whatever works best for them.

>> Well, the libdvbv5 VDR output support was written aiming VDR version 2.1.6.
>> I've no idea if it works with VDR 1.6.0.

It's not uncommon to find VDR users who run versions as old as 1.6.0*.
Some are completely satisfied leaving their perfectly stable system be
with no concern about updating it.

> Since these bugs are from the beginning and no one has rejected,
> I suppose, that these VDR 1.6.0 users are using wscan and not the
> dvbv5 tools. IMHO the VDR format has never been worked,
> so we can't break backwards compatible ;) and since there is wscan
> widely used by old vdr hats, we do not need to care pre-DVB-[T|S]-2
> formats.

Instead of making that kind of assumption, why not ask VDR users
directly on the VDR mailing list?

> As I said, it might be more helpful to place vdr in a public
> repository and to document channel's format well. It is always a
> hell for me to dig into the vdr sources without a version
> context and an ambiguous documentation ...

There is already a publicly available VDR repository offering the
current stable & developer versions, along with all previous versions:
http://www.tvdr.de/download.htm

> Different formats (compare):
> * http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Unterschiede
> * https://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf#Differences

It's best to refer to VDRs packaged documention. You can get the
channels.conf format definition with `man 5 vdr`.

> VDR wiki recommends wscan
> * http://www.vdr-wiki.de/wiki/index.php/W_scan

That wiki shouldn't be viewed as a main reference point in general but
especially for scanning. As mentioned earlier, people tend to use what
works for them. In NA/SA nscan tends to be the top choice. Europe/Asia
tends to be other scanners.

> I think, there is much room left to support developers and users
> outside the vdr community ;)
>
> Would you like to test these patches from Chris and mine / Thanks
> that will be very helpful.

I'd recommend posting to the VDR mailing list where you'll find more
people who use and would be affected by these changes. Additionally,
you could inquire at vdr-portal.de, which is one of the most supported
VDR forums for both users and developers.
