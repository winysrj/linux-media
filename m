Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54054 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2EUAgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 20:36:46 -0400
Received: by obbtb18 with SMTP id tb18so7345333obb.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 17:36:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz_LpOet3qDpW1H6M=1oEdzKGuXVd6zD_ZprNKkZQgs+g@mail.gmail.com>
References: <4FB95A3B.9070800@iki.fi>
	<CAA7C2qiDQJ33OTfq9WxtAgqm0+iaLANoNVKSrvbZ3JpCD=ZGrA@mail.gmail.com>
	<CAGoCfiz_LpOet3qDpW1H6M=1oEdzKGuXVd6zD_ZprNKkZQgs+g@mail.gmail.com>
Date: Sun, 20 May 2012 17:36:45 -0700
Message-ID: <CAA7C2qiTesB+bZ0pzPvWTmO7p=_3oaoR+egw_WpEmiowidAD4g@mail.gmail.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
From: VDR User <user.vdr@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 20, 2012 at 4:10 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> If you think this is important, then you should feel free to submit
> patches to Antti's tree.  Otherwise, this is the sort of optimization
> that brings so little value as to not really be worth the engineering
> effort.  The time is better spent working on problems that *actually*
> have a visible effect to users (and a few extra modules being loaded
> does not fall into this category).
>
> I think you'll find after spending a few hours trying to abstract out
> the logic and the ugly solution that results that it *really* isn't
> worth it.

So you think that it makes more sense to ignore existing issues rather
than fix them. Isn't fixing issues & flaws the whole point of an
overhaul/redesign? Yes, it is. I do get the point you're trying to
make -- there are bigger fish to fry. But this is not an urgent
project and I disagree with the attitude to just disregard whatever
you deem unimportant. If you're going to do it, do it right.
