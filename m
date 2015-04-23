Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:37497 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbbDWOGu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 10:06:50 -0400
Date: Thu, 23 Apr 2015 16:06:46 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: media workshop ML <media-workshop@linuxtv.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] [DRAFT 1] Linux Media Summit report - March,
 26 2015 - San Jose - CA - USA
Message-ID: <20150423160646.4a5a3bf0@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150423074046.1e479e76@recife.lan>
References: <20150422153146.5dd9fce7@recife.lan>
	<20150423090635.67a1656d@dibcom294.coe.adi.dibcom.com>
	<20150423074046.1e479e76@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, 23 Apr 2015 07:40:46 -0300 Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> > What about demod-diversity: demods of some manufacturers can be
> > used to combine their demodulated symbols and, due to their
> > different antennas and RF-paths, improve the overall reception
> > quality.
> > 
> > If we ever have someone contributing in this area with
> > hardware-drivers, it would be nice to have the user-space possible
> > to select demod-combinations. It should be possible to add and
> > remove a demod to a diversity-chain when and when not being tuned
> > to a channel.
> 
> It makes sense to map demod diversity via the media controller.
> 
> Not sure what would be the best way to map it though, as I don't have
> a clear understanding about how the hardware pipelines are set for
> demod diversity.
> 
> The way the media controller currently is is that it maps only the
> data flow. There are discussions about how the control flow should
> happen.
> 
> The data flow for a normal demod is:
> 
> 	IF (or baseband) ---> [demod] ---> MPEG-TS
> 
> 
> From dib0700 demod drivers, I remember that several of the demods have
> a concept of a "slave demod". Are those full demods that can get an
> IF/baseband input and produce a MPEG-TS output, or are those just
> IP blocks that have the IF/baseband input but doesn't produce an
> MPEG-TS output, but, instead, sends some sort of data into the "master
> demod"?
> 
> In other words, would the dataflow be something like
> 
>                  IF                   TS
> 	[tuner] ---> [master demod] ----->[          ]
> 	  | IF                       TS   [ combiner ] ---> [demux]
> 	  |--------> [slave demod]  ----->[          ]
> 
> or:
>                  IF                          TS
> 	[tuner] -----------> [master demod] ---> [demux]
>   	  | IF                     ^
>         |                        | (what sort of data?)
> 	  |----> [slave demod] ----|
> 
> Or is it something else?

Let's define a demodulation object:

+---------------------------------------------------+
|RF tuner --> IF|baseband --> demod --> FEC-decoder |
+---------------------------------------------------+

RF-tuner: RF downconverter (to a low or zero-IF)
IF|baseband: ADC and digital filters
demod: synchonization and symbol extraction
FEC-decoder: viterbi/ldpc/turbo-code forward error correction

Let's call this object a frontend.

Now imagine a board which has 4 frontends:

 high-speed-data-bus
---------------------
  |    |    |    |
 FE3  FE2  FE1  FE0


To create a diversity-chain, for simplicity, we can say we connect at
least 2 frontends in any order. Both frontends are tuned to the same
physical channel and then a combiner will combine symbols decoded at
demod-stage.

Any FE can be connected with any FE in any order. Per board different
standards can be demodulated at the same time. For example: FE3 and FE2
are doing DVB-T and FE1 and FE0 DVB-T2 .

--
Patrick.
