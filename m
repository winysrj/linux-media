Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35747 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1LYRj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 12:39:27 -0500
Received: by werm1 with SMTP id m1so4710890wer.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 09:39:26 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [RFCv1] add DTMB support for DVB API
Date: Fri, 23 Dec 2011 18:27:12 +0100
Cc: Antti Palosaari <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
References: <4EF3A171.3030906@iki.fi> <4EF48473.3020207@linuxtv.org>
In-Reply-To: <4EF48473.3020207@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112231827.13375.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, December 23, 2011 02:38:59 PM Andreas Oberritter wrote:
> On 22.12.2011 22:30, Antti Palosaari wrote:
> > @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
> > 
> >      GUARD_INTERVAL_1_128,
> >      GUARD_INTERVAL_19_128,
> >      GUARD_INTERVAL_19_256,
> > 
> > +    GUARD_INTERVAL_PN420,
> > +    GUARD_INTERVAL_PN595,
> > +    GUARD_INTERVAL_PN945,
> > 
> >  } fe_guard_interval_t;
> 
> What does PN mean in this context?

While I (right now) cannot remember what the PN abbreviation stands for, the 
numbers are the guard time in micro-seconds. At least if I remember 
correctly.

I can confirm that Tuesday next week if no one else corrects me before.

--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
