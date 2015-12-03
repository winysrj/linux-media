Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55404 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbbLCULd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 15:11:33 -0500
Subject: Re: [PATCH 07/10] si2165: Fix DVB-T bandwidth default
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
 <1447963442-9764-8-git-send-email-zzam@gentoo.org>
 <20151203121524.33bd3130@recife.lan>
Cc: linux-media@vger.kernel.org, crope@iki.fi, xpert-reactos@gmx.de
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <5660A1DC.8050701@gentoo.org>
Date: Thu, 3 Dec 2015 21:11:08 +0100
MIME-Version: 1.0
In-Reply-To: <20151203121524.33bd3130@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.12.2015 um 15:15 schrieb Mauro Carvalho Chehab:
> Em Thu, 19 Nov 2015 21:03:59 +0100
> Matthias Schwarzott <zzam@gentoo.org> escreveu:
> 
> 
> Please, add a description to your patches.
> 
> That's said, this patch should be called, instead:
> 
> si2165: Fix DVB-T bandwidth auto
> 
> DVB auto bandwidth mode (bandwidth_hz == 0) logic was setting
> the initial value for dvb_rate to a wrong value. Fix it.
> 
> as a zero value here means to let the frontend to auto-detect
> the bandwidth. Of course, assuming that si2165 is capable of
> doing that.
> 
> If si2165 chip or driver doesn't support bandwidth auto-detection, it
> should, instead, return -EINVAL.
> 
> Are you sure that it will auto-detect the bandwidth if we keep it
> as 8MHz?
> 

Thanks for the feedback.
As far as I know si2165 does not support auto-detection of bandwidth.

I only have 8MHz channels available I tried what happens when
configuring other bandwidth values - it will not lock.

So I will resend the modified the patch.

Regards
Matthias

