Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:51500 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab3BNHym (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 02:54:42 -0500
Message-ID: <511C980E.40305@schinagl.nl>
Date: Thu, 14 Feb 2013 08:53:50 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Michael Stilmant <michael.stilmant@gmail.com>
Subject: Re: [DTV-TABLE] lu-all
References: <CA+YD7UG8RApCsqA4adKEOZ7_8a69RhszzWrTBmr_gBoc3pGqxw@mail.gmail.com>
In-Reply-To: <CA+YD7UG8RApCsqA4adKEOZ7_8a69RhszzWrTBmr_gBoc3pGqxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13-02-13 14:56, Michael Stilmant wrote:
> Hello,
>
> On Mon, Jan 28, 2013 at 4:12 PM, Oliver Schinagl
> <oliver+list@schinagl.nl> wrote:
>> "send a git-patch to the mailing list"
> In attachment what I think is a patch for Luxembourg DVB-T initial
> scan ("git diff origin master > lux-all.diff")
> "Adding Channel 21 broadcasting 'Air' since 28/02/2011"
Applied in c57839aad2260306e6adecc0058fb683a8b34bc4
> I'm not sure if it is the diff format you expect.
> I used "git://linuxtv.org/dtv-scan-tables.git" but I can't do a push
> or I don't know how to do.
If everybody could push to the repo, it would become a huge mess ;) If a 
scanfile would needed to be updated on a regular basis (very unlikely) 
someone could maintain it of course. For now it is based on user 
contributions.
>
> isn't expected/easier that I would push the change to some branch and you would
> commit on master if accepted? or similar?
You can always do this to your local clone and have a pull request to 
your branch. But it's much easier to review on the mailing list using a 
patch. btw, git send-email or git format-patch help greatly in that regard.
>
>>> Indeed in dvb-apps scan /util/scan/dvb-t folder there is still a  fr-Bordeaux files.
>>> In July 2011 Christoph Pfister removed all France regional initial scan files.
>>> http://linuxtv.org/hg/dvb-apps/rev/0b1e26f79698
>>> with commit message: "remove outdated scan files fr-* submitted by mossroy
>>> free.fr use auto-Default or auto-With167kHzOffsets instead"
>>>
>>> I don't know why but Bordeaux escaped from the genocide.
>> IF you have accurate details of fr-Bordeaux (most have those values online,
>> check some of the scanfiles, like nl-All for here in the NL) you'll see that they
>> where actually hand-made from the available resources.
> I don't have accurate scan for Bordeaux, I believe fr-Bordeaux should
> been deleted like
> all region was deleted in July 2011 in one batch by Christoph Pfister.
>
> this if all region should have been deleted.. it is strange that
> decision was made.
> it is like initial scan files are not needed in fact. (why not needed
> for france?)
I have no clue what the current situation is in France and why certain 
decisions where made. If anybody has accurate information to fix things, 
we can happily fix things.
>
> best regards,
>
> Michael

