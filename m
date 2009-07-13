Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:52136 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbZGMMN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 08:13:56 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, me@boris64.net,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Date: Mon, 13 Jul 2009 14:13:50 +0200
References: <200907121550.36679.me@boris64.net>
In-Reply-To: <200907121550.36679.me@boris64.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907131413.50826.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sonntag, 12. Juli 2009, Boris Cuber wrote:
> Hi kernel folks!
>
> Problem:
> Since kernel-2.6.31-rc* my dvb-s adapter (Technisat SkyStar2 DVB card)
> refuses to work (worked fine in every kernel up to 2.6.30.1).
> So anything pulled into the new kernel seems to have broken
> something (at least for me :/).
>
> I opened a detailed bug report here:
> http://bugzilla.kernel.org/show_bug.cgi?id=13709
> Please let me know if i can help in finding a solution
> or testing a patch /whatever.

This looks like it is related to this patch:

commit d66b94b4aa2f40e134f8c07c58ae74ef3d523ee0
Author: Patrick Boettcher <pb@linuxtv.org>
Date:   Wed May 20 05:08:26 2009 -0300

    V4L/DVB (11829): Rewrote frontend-attach mechanism to gain noise-less 
deactivation of submodules

    This patch is reorganizing the frontend-attach mechanism in order to
    gain noise-less (superflous prints) deactivation of submodules.

    Credits go to Uwe Bugla for helping to clean and test the code.

    Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
    Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>



All frontend-attach related code is wrapped by ifdefs like this:
#if defined(CONFIG_DVB_MT312_MODULE) || defined(CONFIG_DVB_STV0299_MODULE)
<CODE>
#endif

So this code will only be compiled if one of the two drivers is compiled as a 
module, having them compiled in will omit this code.

Trent Piepho seems to already have a patch for this, but it is not yet merged 
into the kernel.

Regards
Matthias
