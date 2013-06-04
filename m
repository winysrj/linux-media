Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39898 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3FDLXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 07:23:05 -0400
Received: by mail-ee0-f47.google.com with SMTP id e49so25921eek.20
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 04:23:03 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Diversity support?
Date: Tue, 04 Jun 2013 13:23:01 +0200
Message-ID: <4964507.arsPbG4Yym@dibcom294>
In-Reply-To: <51ACB2CA.6060503@ventoso.org>
References: <507EE702.2010103@ventoso.org> <5091691A.4070903@ventoso.org> <51ACB2CA.6060503@ventoso.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 03 June 2013 17:14:18 Luca Olivetti wrote:
> >> So, what's the real status of diversity support?
> > 
> > Nobody knows?
> 
> I'm not easily discouraged :-) so here's the question again: is there
> some dvb-t usb stick (possibly available on the EU market) with
> diversity support under Linux?

There is some diversity support hidden in the dib8000-driver and in some 
board-drivers which use it. Basically it creates several instances of the 
dib8000-driver (one for each demod) but it exposes only one dvb-frontend to 
userspace via the API. When the user is tuning the frontend he is, in fact, 
tuning all of them in diversity.

IMO, the question which needs to be discussed is for diversity-support is an 
"how to change the API"-question and how does userspace can control it?

In my experience with multi-frontend-hardware, which can do diversity or 
dual/triple-reception or both at the same time, is that the question is the 
routing and the grouping of frontend and assigning them to their sinks 
(stream-interfaces).

Right now DVB-API can expose several frontends and dvrs and demuxes for one 
device, but there is no way to userspace telling the hardware to combine 
frontend0 and frontend1 to do diversity.

When looking at diversity/multi-frontend problems, IMHO, we should not limit 
ourselves to USB-devices. The real usage of those MFE-devices is in an 
embedded hardware (STB in a car or at home).

--
Patrick
