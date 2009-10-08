Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58973 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZJHOhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 10:37:02 -0400
Received: by bwz6 with SMTP id 6so829676bwz.37
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2009 07:36:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB>
References: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB>
Date: Thu, 8 Oct 2009 10:36:24 -0400
Message-ID: <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Miroslav Pragl <lists.subscriber@pragl.cz>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/10/8 Miroslav Pragl <lists.subscriber@pragl.cz>:
> Hello,
> are here users of Pinnace 320e (PCTV Hybrid Pro Stick)?
>
> I have lots of problems with tuning, namely
> - scan somehow locks on the first frequency listed in scan file and finds no
> signal on subsequent freqs
> - kaffeine which has own scanning scans RELIABLY two, somehow three of four
> channels available in my region
> - vlc which has great commandline parameters for direc tuning frequency and
> programm (by its ID) works fine
>
> I currently use Fedora 11 with latest stable kernel (64 bit) and try to keep
> up-to-date with linuxtv drivers
>
> any help or atleast bug confirming would help me a lot
>
> Thanks
>
> MP
>
> P.S. although i hated the aggressivnes of Markus' drivers from mcentral.de
> (no longer maintained) and need of FULL kernel sources these atleast worked
> :(

Hi Miroslav,

I did the 320e work with the assistance of a couple of users in
Europe.  Could you confirm that you are running the latest v4l-dvb
tree from http://linuxtv.org/hg/v4l-dvb?  If so, please provide the
output of dmesg after connecting the device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
