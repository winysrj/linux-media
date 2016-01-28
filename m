Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41229 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbcA1IvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 03:51:23 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video capture cards
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
	<CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
	<m31t96j8u4.fsf@t19.piap.pl>
	<CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
	<m3si1kioa9.fsf@t19.piap.pl>
	<CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
	<m3io2gfksk.fsf@t19.piap.pl>
	<CAAEAJfDb84ZbRkq9GVOmeWp=vpn_GBX9Fx0w+aGnZ9n29PsR8A@mail.gmail.com>
	<m3a8nqf9mk.fsf@t19.piap.pl> <56A9C6BC.6040208@xs4all.nl>
Date: Thu, 28 Jan 2016 09:51:20 +0100
In-Reply-To: <56A9C6BC.6040208@xs4all.nl> (Hans Verkuil's message of "Thu, 28
	Jan 2016 08:43:56 +0100")
Message-ID: <m3y4badr3r.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

>> In my country, it wouldn't be even legal.
>
> It's legal for the GPL license since that gives explicit permission.

In my country, claiming authorship (not co-authorship) of someone's code
is illegal. Even if done with author's permission.

>> I have at least one similar situation here. I'm using frame grabber
>> drivers for an I.MX6 processor on-chip feature. The problem is, the
>> author hasn't yet managed (for years now) to have this functionality
>> merged into the official tree. Obviously, I'm putting some considerable
>> work in it. Does this mean I'm free to grab it as my own and request
>> that it is to be merged instead? No, I have to wait until the original
>> work is merged, and only then I can ask for my patches to be applied
>> (in the form of changes, not a raw driver code).
>
> Wrong. As long as the original code is distributed as GPL you can
> certainly take it, fix it and ask for it to be merged.
>
> This happens all the time if the original author has left the scene, or has
> no time or interest to follow-up on his patches.

This doesn't seem to be applicable in either case.

> For future reference: if someone posts code to a kernel mailinglist and does
> not fix any comments made on the code in, let's say, 1-2 months, then
> someone else might just step in.

Oh, come on. I let it go because Ezequiel wrote he had rewritten the
driver and wanted to merge it instead. I first asked for diffs vs. my
code, but in case of a rewrite such diffs don't make sense.


I don't say nobody is allowed to take my work and add his own on top.
Actually, this was what I proposed at least twice.

Is there a problem with rebasing his work on top of mine, and showing
the real changes? Git makes it easy.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
