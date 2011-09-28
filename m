Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:60999 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030Ab1I1O1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 10:27:08 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner) - workaround hack included
Date: Wed, 28 Sep 2011 15:27:03 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>
References: <201109281350.52099.simon.farnsworth@onelan.com> <CAGoCfiwUm268x3JF-YS5DLLmtPr-A4EADP+oFaZNErB=kHsC9A@mail.gmail.com>
In-Reply-To: <CAGoCfiwUm268x3JF-YS5DLLmtPr-A4EADP+oFaZNErB=kHsC9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281527.03620.simon.farnsworth@onelan.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 28 September 2011, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> Hi Simon,
> 
> On Wed, Sep 28, 2011 at 8:50 AM, Simon Farnsworth
> 
> <simon.farnsworth@onelan.com> wrote:
> > 
> > I'm having problems getting a Hauppauge HVR-1110 card to successfully
> > tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
> > determined that the tda18271 is tuning to a frequency 1.25 MHz lower
> > than the vision frequency I've requested, so the following workaround
> > "fixes" it for me.
> > 
> > I'm going to run with this hack in place, but I'd appreciate it if
> > someone who knew more about the TDA18271 looked at this, and either
> > gave me a proper fix for testing, or confirmed that what I'm doing is
> > right.
> 
> Hi Simon,
> 
> This is interesting.  I did some testing with an 18271 based device a
> few months back (a Hauppauge cx231xx based tuner), and I believe
> PAL-DK was working (although I did have unrelated issues with the DIF
> configuration).
> 
> When you are doing the tuning request, are you explicitly stating
> PAL-D in your calling application?  Or are you passing "PAL" to the
> V4L layer and expecting it to work with a PAL-D feed?
>
I'm noticing this problem because I fixed a bug of ours, where we were
passing PAL to the V4L2 layer, and expecting it to work (video did, at the
correct frequency, but audio did not, as the TDA18271 chose PAL-B).

Having fixed the bug, I was having to either adjust my signal generator down
by 1.25MHz, or adjust the frequency I passed to V4L2 up by 1.25MHz to make
PAL-D work.

Hence the hack - I've confirmed that with the hack in place, I can get
colour video from the signal if I use PAL-B or PAL-D, and sound if I use
PAL-D. Without the hack, I need to change the frequency as I toggle between
PAL-B and PAL-D, or I lose video.

-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
