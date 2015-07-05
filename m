Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33215 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbGEJu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2015 05:50:28 -0400
Received: by wiwl6 with SMTP id l6so260507755wiw.0
        for <linux-media@vger.kernel.org>; Sun, 05 Jul 2015 02:50:27 -0700 (PDT)
Message-ID: <5598FDDC.7020804@gmail.com>
Date: Sun, 05 Jul 2015 10:50:20 +0100
From: Andy Furniss <adf.lists@gmail.com>
MIME-Version: 1.0
To: Peter Fassberg <pf@leissner.se>, linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
In-Reply-To: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Peter Fassberg wrote:
> Hi all!
>
> I'm trying to get PCTV TripleStick 292e working in a Raspberry Pi B+
>  environment.
>
> I have no problem getting DVB-T to work, but I can't tune to any
> DVB-T2 channels. I have tried with three different kernels: 3.18.11,
> 3.18.16 and 4.0.6.  Same problem.  I also cloned the media_build
> under 4.0.6 to no avail.
>
> The same physical stick works perfectly with DVB-T2 in an Intel
> platform using kernel 3.16.0.
>
> Do you have any suggestions what I can do to get this running or is
> there a known problem with Raspberry/ARM?

What are you trying to tune with?

Maybe that could be the difference - unlike the 290 the 292e won't tune
with apps that are not dvb-t2 "aware" eg. dvbv5-zap will work but not tzap.

The current version of w_scan and eg. tvheadend will work, but older
versions may not.
