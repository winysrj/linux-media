Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47109 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3ACASn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 19:18:43 -0500
Date: Thu, 3 Jan 2013 01:18:39 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Antti Palosaari <crope@iki.fi>
Cc: Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20130103001839.GC13132@hardeman.nu>
References: <50C4D011.6010700@pyther.net>
 <50C60220.8050908@googlemail.com>
 <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
 <50C60772.2010904@googlemail.com>
 <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
 <50C6226C.8090302@iki!.fi>
 <50C636E7.8060003@googlemail.com>
 <50C64AB0.7020407@iki.fi>
 <50C79CD6.4060501@googlemail.com>
 <50C79E9A.3050301@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50C79E9A.3050301@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 11, 2012 at 10:59:06PM +0200, Antti Palosaari wrote:
>Yes, that is. I have said it "million" times I would like to see that
>implemented as a one single 4 byte NEC, but it is currently what it
>is. What I understand David Härdeman has done some work toward that
>too, but it is not ready.

Correct. Still working on it. The main problem is providing it in
a sensibly backwards-compatible manner. I will post patches to the ML
again once it is ready.

-- 
David Härdeman
