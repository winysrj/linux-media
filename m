Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54557
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751428AbdFGW7s (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 18:59:48 -0400
Date: Wed, 7 Jun 2017 19:59:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com
Subject: Re: [PATCH 01/11] [media] dvb-core/dvb_ca_en50221.c: Rename
 STATUSREG_??
Message-ID: <20170607195940.3f54b6c3@vento.lan>
In-Reply-To: <b6ce894d-8387-3568-902a-e203cc4f1d7f@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
        <1494192214-20082-2-git-send-email-jasmin@anw.at>
        <20170508065545.52b26fc9@vento.lan>
        <3d4c4a10-0c65-9eee-b4e2-b19f1eddb31a@anw.at>
        <20170607134319.6b90c6a4@vento.lan>
        <b6ce894d-8387-3568-902a-e203cc4f1d7f@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 7 Jun 2017 21:37:02 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro!
> 
> > If you want it applied, this is needed anyway, as the patch doesn't apply 
> > cleanly:  
> Because you didn't apply the first series!
> In the first series
>    [PATCH 0/7] Add block read/write to en50221 CAM functions
> I wrote:
>  There is another patch series coming soon "Fix coding style in en50221 CAM
>  functions" which fixes nearly all the style issues in
>  dvb-core/dvb_ca_en50221.c/.h, based on this patch series. So please be
>  patient, if any of the dvb_ca_en50221.c/.h might be not 100% checkpatch.pl
>  compliant.
> 
> It was NOT intended to apply the second series with the code style changes
> before the first series! And now, that you accepted two out of this series
> the first series might not apply also and I need to rework it.
> Sorry for my feelings about this issue, but this is a bit frustrating!
> 
> In the preamble of the style fix series I wrote:
>  These patch series is a follow up to the series "Add block read/write to
>  en50221 CAM functions". It fixed nearly all the style issues reported by
>  checkpatch.pl in dvb-core/dvb_ca_en50221.c
> 
> I can't do more as writing what is the right order!

Sorry, I missed it. Unfortunately, patchwork doesn't retrieve patch 00/xx.
So, sometimes I end by not noticing that a patch series has a cover letter.

> > Btw, don't spend time fixing issues pointed by checkpatch on existing
> > code, except if you're rewriting most of the code. We don't want to handle
> > merge conflicts due to checkpatch-only changes.  
> I think you are talking about
>  [PATCH 04/11] [media] dvb-core/dvb_ca_en50221.c: Refactored dvb_ca_en50221_thread
> This function is a mess and breaking it into smaller pieces helps for the 80cols
> limit and for the complexity. You just wrote:

No, I'm actually talking about patches 1 and 2 of this series. Renaming
macros just due to 80 cols is usually a bad idea, as it causes conflict
with other stuff.

The idea behind patch 04/11 makes sense to me. I'll review it carefully
after having everything applied.

Please re-send the first series, making sure that the authorship is
preserved.

Thanks,
Mauro
