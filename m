Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:32921 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1JCI4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Oct 2011 04:56:04 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner) - workaround hack included
Date: Mon, 3 Oct 2011 09:56:01 +0100
Cc: linux-media@vger.kernel.org
References: <201109281350.52099.simon.farnsworth@onelan.com> <4E8604DA.2070008@gmail.com>
In-Reply-To: <4E8604DA.2070008@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110030956.01130.simon.farnsworth@onelan.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 September 2011, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> On 28/09/11 13:50, Simon Farnsworth wrote:
> > (note - the CC list is everyone over 50% certainty from get_maintainer.pl)
> >
> > I'm having problems getting a Hauppauge HVR-1110 card to successfully
> > tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
> > determined that the tda18271 is tuning to a frequency 1.25 MHz lower
> > than the vision frequency I've requested, so the following workaround
> > "fixes" it for me.
> 
> Are you sure the transmitter concerned doesn't have a VSB filter for an 
> adjacent DVB-T digital transmitter?
>
The "transmitter" concerned is a test pattern generator - it has no filters
applied to its output.

The intended customer for this device is in China, hence the use of PAL-D.
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
