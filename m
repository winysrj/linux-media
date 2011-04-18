Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52924 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1DRFsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 01:48:32 -0400
Received: by bwz15 with SMTP id 15so3528910bwz.19
        for <linux-media@vger.kernel.org>; Sun, 17 Apr 2011 22:48:31 -0700 (PDT)
Date: Mon, 18 Apr 2011 07:48:22 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Lutz Sammer <johns98@gmx.net>
Cc: linux-media@vger.kernel.org, liplianin@me.by,
	abraham.manu@gmail.com
Subject: Re: [PATCH] Fixes stb0899 not locking
Message-ID: <20110418074822.0d2174a2@grobi>
In-Reply-To: <4D99B357.50804@gmx.net>
References: <4D99B357.50804@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 04 Apr 2011 14:02:31 +0200
Lutz Sammer <johns98@gmx.net> wrote:

> Fixes stb0899 not locking.
> See http://www.spinics.net/lists/linux-media/msg30486.html ...
> 
> When stb0899_check_data is entered, it could happen, that the data is
> already locked and the data search looped.  stb0899_check_data fails
> to lock on a good frequency.  stb0899_search_data uses an extrem big
> search step and fails to lock.
> 
> The new code checks for lock before starting a new search.
> The first read ignores the loop bit, for the case that the loop bit is
> set during the search setup.  I also added the msleep to reduce the
> traffic on the i2c bus.
> 

Thanks Lutz for getting down to the problem :) !

Manu, Mauro,

Any comments ? Let's have that finally sorted. 

I think its proven now that its a bug. We have a fix. 

---
A few test result on 2.6.39-rc3 from vdr-portal(thx to jrie, hope its
ok for him). This is tuning a pre defined channel list until we have a
lock and then tune the next. 


Astra_only.txt + Original
TOT: lok_errs =172, runs=1136 of sequ=1135, multi=56032, multi_max=931
real 101m40.777s
user 0m0.083s
sys 0m19.039s

Astra_only.txt + stb0899_not_locking_fix.diff
TOT: lok_errs =0, runs=1136 of sequ=1135, multi=289, multi_max=99
real 17m15.636s
user 0m0.007s
sys 0m9.445s



