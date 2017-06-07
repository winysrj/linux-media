Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53124
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750831AbdFGQn1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 12:43:27 -0400
Date: Wed, 7 Jun 2017 13:43:19 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com
Subject: Re: [PATCH 01/11] [media] dvb-core/dvb_ca_en50221.c: Rename
 STATUSREG_??
Message-ID: <20170607134319.6b90c6a4@vento.lan>
In-Reply-To: <3d4c4a10-0c65-9eee-b4e2-b19f1eddb31a@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
        <1494192214-20082-2-git-send-email-jasmin@anw.at>
        <20170508065545.52b26fc9@vento.lan>
        <3d4c4a10-0c65-9eee-b4e2-b19f1eddb31a@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 May 2017 19:28:48 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro!
> 
>  >> Rename STATUSREG_?? -> STATREG_?? to reduce the line length.  
>  > That sounds a bad idea. We use "stat" on the DVB subsystem as an
>  > alias for statistics.  
> At the beginning of the style fixes, I thought it is a good idea to reduce
> as much as possible to get more characters, but at the end this patch
> doesn't save so much, so we can omit it.

Renaming things is usually not a good idea, specially at core level,
as it makes a way harder to apply patches from other sources.

Also, if you're doing that just because of the 80cols warning, that's
the wrong way of doing it ;)

The hole idea when the 80cols warning was introduced is to point places at 
the code were there are potentially too much indentation or code complexity,
possibly indicating complex functions that could otherwise be split.
This is useful when new code gets added, but it usually doesn't make
much sense to fix it on existing code, except when some function has to 
be re-implemented.

So, I please drop patches 1 and 2 from this series.

> What is then the right procedure now?
> When I omit it in the first place, I can redo the whole work again and
> this were a lot of hours. Would it be acceptable to make a patch no. 12 at
> the end of the sequence, which renames it back?

If you want it applied, this is needed anyway, as the patch doesn't apply 
cleanly:

patching file drivers/media/dvb-core/dvb_ca_en50221.c
Hunk #2 FAILED at 347.
Hunk #4 succeeded at 649 (offset -12 lines).
Hunk #5 succeeded at 702 (offset -11 lines).
Hunk #6 succeeded at 763 (offset -15 lines).
Hunk #7 succeeded at 779 (offset -15 lines).
Hunk #8 succeeded at 800 (offset -15 lines).
Hunk #9 succeeded at 824 (offset -15 lines).
Hunk #10 succeeded at 937 (offset -15 lines).
Hunk #11 succeeded at 1151 (offset -15 lines).
1 out of 11 hunks FAILED -- rejects in file drivers/media/dvb-core/dvb_ca_en50221.c
Patch patches/lmml_41185_01_11_media_dvb_core_dvb_ca_en50221_c_rename_statusreg.patch does not apply (enforce with -f)
Patch didn't apply. Aborting

>From this patch series, I was able to apply 2 patches.

Btw, don't spend time fixing issues pointed by checkpatch on existing
code, except if you're rewriting most of the code. We don't want to handle
merge conflicts due to checkpatch-only changes.

Thanks,
Mauro
