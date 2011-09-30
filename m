Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45137 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab1I3SFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 14:05:19 -0400
Received: by wyg34 with SMTP id 34so1340609wyg.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 11:05:18 -0700 (PDT)
Message-ID: <4E8604DA.2070008@gmail.com>
Date: Fri, 30 Sep 2011 19:05:14 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, simon.farnsworth@onelan.com
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner)
 - workaround hack included
References: <201109281350.52099.simon.farnsworth@onelan.com>
In-Reply-To: <201109281350.52099.simon.farnsworth@onelan.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/09/11 13:50, Simon Farnsworth wrote:
> (note - the CC list is everyone over 50% certainty from get_maintainer.pl)
>
> I'm having problems getting a Hauppauge HVR-1110 card to successfully
> tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
> determined that the tda18271 is tuning to a frequency 1.25 MHz lower
> than the vision frequency I've requested, so the following workaround
> "fixes" it for me.

Are you sure the transmitter concerned doesn't have a VSB filter for an 
adjacent DVB-T digital transmitter?

VSB fitlers have been used on UK(PAL-I) transmitters for some time.

From
downloads.bbc.co.uk/rd/pubs/whp/whp-pdf-files/WHP023.pdf

"To avoid the likelihood of PAL-I interference to DTT transmissions, the 
proposal is to use a System B/G VSB filter which provides at least 30 dB 
of sideband attenuation at 1.4 MHz below the vision carrier. It is also 
necessary to reduce the image sidebands resulting from transmitter 
non-linearity, and the method is to fit a high-order bandpass filter at 
the transmitter output. Typically, the overall sideband response will be 
-2 dB at (fv - 0.75) MHz and -20 dB at (fv - 1.25) MHz, where fv is the 
frequency of the vision carrier."


