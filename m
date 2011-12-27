Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62611 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1L0Q2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 11:28:40 -0500
Received: by wibhm6 with SMTP id hm6so5023261wib.19
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 08:28:38 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [RFCv1] add DTMB support for DVB API
Date: Tue, 27 Dec 2011 17:26:33 +0100
Cc: Antti Palosaari <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
References: <4EF3A171.3030906@iki.fi> <4EF48473.3020207@linuxtv.org> <201112231827.13375.pboettcher@kernellabs.com>
In-Reply-To: <201112231827.13375.pboettcher@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112271726.33733.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 December 2011 18:27:12 Patrick Boettcher wrote:
> On Friday, December 23, 2011 02:38:59 PM Andreas Oberritter wrote:
> > On 22.12.2011 22:30, Antti Palosaari wrote:
> > > @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
> > > 
> > >      GUARD_INTERVAL_1_128,
> > >      GUARD_INTERVAL_19_128,
> > >      GUARD_INTERVAL_19_256,
> > > 
> > > +    GUARD_INTERVAL_PN420,
> > > +    GUARD_INTERVAL_PN595,
> > > +    GUARD_INTERVAL_PN945,
> > > 
> > >  } fe_guard_interval_t;
> > 
> > What does PN mean in this context?
> 
> While I (right now) cannot remember what the PN abbreviation stands
> for, the numbers are the guard time in micro-seconds. At least if I
> remember correctly.

Totally wrong.

The number indicated by the PN-value is in samples. Not in micro-
seconds.

To compare the PN value with the guard-time known from DVB-T we could do 
like that: in DVB-T's 8K mode we have 8192 samples which make one 
symbol. If the guard time is 1/32 we have 8192/32 samples which 
represent the protect the symbols from inter-symbol-interference: 256 in 
this case. 

In DTMB one symbol consists of 3780 samples + the PN-value. Using the 
classical representation we could say: PN420 is 1/9, PN595 is about 1/6 
and PN945 is 1/4.

HTH,

--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
