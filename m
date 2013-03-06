Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:57616 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab3CFWYd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 17:24:33 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH v2 0/4] saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
Date: Wed, 6 Mar 2013 23:23:49 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359750087-1155-1-git-send-email-linux@rainbow-software.org> <201302161739.49850.linux@rainbow-software.org> <CAOcJUbwPFoBANp0J_unvN9R91gRLrBfVOpp3TqE7iQR4tHG7kA@mail.gmail.com>
In-Reply-To: <CAOcJUbwPFoBANp0J_unvN9R91gRLrBfVOpp3TqE7iQR4tHG7kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201303062323.50139.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 18 February 2013 03:57:01 Michael Krufky wrote:
> On Sat, Feb 16, 2013 at 11:39 AM, Ondrej Zary
>
> <linux@rainbow-software.org> wrote:
> > On Friday 01 February 2013 21:21:23 Ondrej Zary wrote:
> >> Add AverMedia AverTV Satellite Hybrid+FM (A706) card to saa7134 driver.
> >>
> >> This requires some changes to tda8290 - disabling I2C gate control and
> >> passing custom std_map to tda18271.
> >> Also tuner-core needs to be changed because there's currently no way to
> >> pass any complex configuration to analog tuners.
> >
> > What's the status of this patch series?
> >
> > The two tda8290 patches are in Michael's dvb tree.
> > I've sent an additional clean-up patch (on Mauro's suggestion) for the
> > tuner-core change.
> > I guess that the final AverMedia A706 patch would be easily merged once
> > the tda8290 and tuner-core changess are done.
> >
> > Should I resend something?
>
> I've just been a bit busier lately that I had foreseen, but no need to
> resend anything - I have your patches.  You'll hear back from me
> shortly.

Any news about these patches?

-- 
Ondrej Zary
