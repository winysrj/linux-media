Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:57103 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbdFGThJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 15:37:09 -0400
Subject: Re: [PATCH 01/11] [media] dvb-core/dvb_ca_en50221.c: Rename
 STATUSREG_??
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
 <1494192214-20082-2-git-send-email-jasmin@anw.at>
 <20170508065545.52b26fc9@vento.lan>
 <3d4c4a10-0c65-9eee-b4e2-b19f1eddb31a@anw.at>
 <20170607134319.6b90c6a4@vento.lan>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <b6ce894d-8387-3568-902a-e203cc4f1d7f@anw.at>
Date: Wed, 7 Jun 2017 21:37:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170607134319.6b90c6a4@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro!

> If you want it applied, this is needed anyway, as the patch doesn't apply 
> cleanly:
Because you didn't apply the first series!
In the first series
   [PATCH 0/7] Add block read/write to en50221 CAM functions
I wrote:
 There is another patch series coming soon "Fix coding style in en50221 CAM
 functions" which fixes nearly all the style issues in
 dvb-core/dvb_ca_en50221.c/.h, based on this patch series. So please be
 patient, if any of the dvb_ca_en50221.c/.h might be not 100% checkpatch.pl
 compliant.

It was NOT intended to apply the second series with the code style changes
before the first series! And now, that you accepted two out of this series
the first series might not apply also and I need to rework it.
Sorry for my feelings about this issue, but this is a bit frustrating!

In the preamble of the style fix series I wrote:
 These patch series is a follow up to the series "Add block read/write to
 en50221 CAM functions". It fixed nearly all the style issues reported by
 checkpatch.pl in dvb-core/dvb_ca_en50221.c

I can't do more as writing what is the right order!

> Btw, don't spend time fixing issues pointed by checkpatch on existing
> code, except if you're rewriting most of the code. We don't want to handle
> merge conflicts due to checkpatch-only changes.
I think you are talking about
 [PATCH 04/11] [media] dvb-core/dvb_ca_en50221.c: Refactored dvb_ca_en50221_thread
This function is a mess and breaking it into smaller pieces helps for the 80cols
limit and for the complexity. You just wrote:
 > The hole idea when the 80cols warning was introduced is to point places at 
 > the code were there are potentially too much indentation or code complexity,
 > possibly indicating complex functions that could otherwise be split.

But you wrote also:
 > This is useful when new code gets added, but it usually doesn't make
 > much sense to fix it on existing code, except when some function has to 
 > be re-implemented.
I would like to split the thread to make it more readable, but if you say you won't
apply it it makes no sense to put effort on this subject.

So what is your decision about this patch?

BR,
   Jasmin
