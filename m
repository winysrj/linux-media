Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33035 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbFKTZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 15:25:26 -0400
Received: by qcnj1 with SMTP id j1so4903485qcn.0
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 12:25:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5579DA5F.1000107@gmail.com>
References: <5578728A.4020106@gmail.com>
	<CALzAhNVg=uoq2TGb605iugxxzVuWBxEfp3t3hGZShXrQ2dKR4Q@mail.gmail.com>
	<5579DA5F.1000107@gmail.com>
Date: Thu, 11 Jun 2015 15:25:25 -0400
Message-ID: <CALzAhNUB5fsCYEuTKTKfjY4iW2baRBVE1Dkbut2HLSggs5YKZQ@mail.gmail.com>
Subject: Re: Hauppauge 2250 on Ubuntu 15.04
From: Steven Toth <stoth@kernellabs.com>
To: Jeff Allen <worthspending@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 11, 2015 at 2:58 PM, Jeff Allen <worthspending@gmail.com> wrote:
> Thanks, I did that and it is working now.  However, I ran into another
> problem.  The card will not scan any channels.  I live in the Chicago area
> and my cable provider is Wowway.  Wowway requires a main set top box and
> digital adapters for every other TV in the home.  Cable ready TV's after
> 2010 are suppose to work without the need for a digital adapter.  I have a
> feeling that the 2255 card I have will not work with my cable provider.
>
> Any thoughts?

Cc'ing linux-media back in.

I'm not aware of any US cable provider that the HVR2255 cannot
tune/demodulate. I'd be highly surprised if your HVR2255 isn't
delivering packets, unless its faulty.

However, depending on your provider, those multiplexes may only
contain encrypted tv channels - not watchable by you. I have a handful
of channels from my provider that are watchable. 300+ are fully
encrypted.... the data delivered by the card isn't that useful, for
encrypted channels.

I suggest you share the output from your scan tests with the mailing
list and see if anyone can help.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
