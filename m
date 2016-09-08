Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:39316 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbcIHHPd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 03:15:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <CAA7C2qh-XGBxsZk_GdO+Oj2Q8x9SqA1XOAb+b0ZRbsNCR2eesw@mail.gmail.com>
Date: Thu, 8 Sep 2016 09:15:13 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Chris Mayo <aklhfex@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <973834E5-E192-4EE3-AAAE-AD28086CF3D0@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de> <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de> <20160824114927.3c6ab0d6@vento.lan> <20160824115241.7e2c90ca@vento.lan> <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de> <20160905102511.6de3dbe4@vento.lan> <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com> <20160906064108.5bd84045@vento.lan> <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com> <20160906124723.6783fd39@vento.lan> <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de> <CAA7C2qh-XGBxsZk_GdO+Oj2Q8x9SqA1XOAb+b0ZRbsNCR2eesw@mail.gmail.com>
To: VDR User <user.vdr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 07.09.2016 um 19:59 schrieb VDR User <user.vdr@gmail.com>:

>> It is broken (see below). Have you ever used dvbv5 tools with vdr format
>> output or did you know a "VDR user" who is using dvbv5-scan and not wscan?
> 
> In my experience the v4l scanner, wscan, and VDR's internal scanner
> has never worked well (for NA). I use nscan, which has easily been the
> most successful of the scanners. An additional benefit to nscan is you
> only supply a single transponder on the command line and it will
> populate a channel list for the entire sat. You don't need to supply
> an entire list of transponders to scan.
> 
> As far as other VDR users, of which I know many being a long time
> user, they tend to use whatever works best for them.
> 
>>> Well, the libdvbv5 VDR output support was written aiming VDR version 2.1.6.
>>> I've no idea if it works with VDR 1.6.0.
> 
> It's not uncommon to find VDR users who run versions as old as 1.6.0*.
> Some are completely satisfied leaving their perfectly stable system be
> with no concern about updating it.
> 
>> Since these bugs are from the beginning and no one has rejected,
>> I suppose, that these VDR 1.6.0 users are using wscan and not the
>> dvbv5 tools. IMHO the VDR format has never been worked,
>> so we can't break backwards compatible ;) and since there is wscan
>> widely used by old vdr hats, we do not need to care pre-DVB-[T|S]-2
>> formats.
> 
> Instead of making that kind of assumption, why not ask VDR users
> directly on the VDR mailing list?
> 
>> As I said, it might be more helpful to place vdr in a public
>> repository and to document channel's format well. It is always a
>> hell for me to dig into the vdr sources without a version
>> context and an ambiguous documentation ...
> 
> There is already a publicly available VDR repository offering the
> current stable & developer versions, along with all previous versions:
> http://www.tvdr.de/download.htm

?? these are tarballs, where is the version control system?

> 
>> Different formats (compare):
>> * http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Unterschiede
>> * https://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf#Differences
> 
> It's best to refer to VDRs packaged documention. You can get the
> channels.conf format definition with `man 5 vdr`.

Good point, but I have only 2.2 installed, so where get I the backward 
informations .. should I extract all theses tarballs and read through
them .. you see my point?


>> VDR wiki recommends wscan
>> * http://www.vdr-wiki.de/wiki/index.php/W_scan
> 
> That wiki shouldn't be viewed as a main reference point in general but
> especially for scanning.

And the main ref is https://www.linuxtv.org ... which is not updated?

> As mentioned earlier, people tend to use what
> works for them. In NA/SA nscan tends to be the top choice. Europe/Asia
> tends to be other scanners.

What I said, nobody use the vdr format of dvbv5-tools, since it 
is broken and now, Chris and I want to fix it.

> 
>> I think, there is much room left to support developers and users
>> outside the vdr community ;)
>> 
>> Would you like to test these patches from Chris and mine / Thanks
>> that will be very helpful.
> 
> I'd recommend posting to the VDR mailing list where you'll find more
> people who use and would be affected by these changes. Additionally,
> you could inquire at vdr-portal.de, which is one of the most supported
> VDR forums for both users and developers.

Chris and I want to patch something in v4l-utils which is broken 
and YOU make the assumption that our patches are not OK ... and now, #
I have to ask someone other on a different projects ML and their portal?

If you have a doubt about the patches from Chris and mine, make a test and
if you see any regression it would be great to post your experience here ...

thanks.

-- Markus --


