Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50692 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3FDLN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 07:13:29 -0400
Received: by mail-ee0-f45.google.com with SMTP id l10so23573eei.18
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 04:13:28 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Luca Olivetti <luca@ventoso.org>, linux-media@vger.kernel.org
Subject: Re: Diversity support?
Date: Tue, 04 Jun 2013 13:13:24 +0200
Message-ID: <6801297.RAWCgALf3Z@dibcom294>
In-Reply-To: <51ADBECD.1070102@iki.fi>
References: <507EE702.2010103@ventoso.org> <51AD9758.2050009@ventoso.org> <51ADBECD.1070102@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 04 June 2013 13:17:49 Antti Palosaari wrote:
> On 06/04/2013 10:29 AM, Luca Olivetti wrote:
> > Al 04/06/13 01:17, En/na Antti Palosaari ha escrit:
> >>> I'm not easily discouraged :-) so here's the question again: is there
> >>> some dvb-t usb stick (possibly available on the EU market) with
> >>> diversity support under Linux?
> >> 
> >> I have feeling AF9035/IT9135 dual devices could do that.
> > 
> > Looking at the wiki, most devices based on those demodulators are either
> > unsupported or have a dual tuner but not diversity.
> 
> Because diversity is not interesting feature at all in normal use case.
> Whole DVB-T standard fits poorly for mobile usage and you cannot make
> situation that much better using diversity.

Well, I have to disagree on this statement.

Diversity does not do a lot in fixed reception. That's right, but depending 
on the TV-standard the diversity gain in mobile reception can be enormous.

Several field trials we did in the past years have shown that large parts of 
the trial route which have not worked at at all in single receiver work like 
a charm in diversity.

Maybe the route-selection in this cases was biased to show off the 
performance of diversity ... well, it worked - diversity showed off.

best regards,
--
Patrick
