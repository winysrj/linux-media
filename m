Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:38881 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbZDKSHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 14:07:33 -0400
Received: by an-out-0708.google.com with SMTP id d14so1355592and.1
        for <linux-media@vger.kernel.org>; Sat, 11 Apr 2009 11:07:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <621110570904110547v6b22ad5fv4db760816cb67338@mail.gmail.com>
References: <621110570904100418r9d7e583j5ae4982a77e9dba9@mail.gmail.com>
	 <49DF9CB7.5080802@ewetel.net>
	 <621110570904101437g5843eb21h8a0c894cc9bb48d@mail.gmail.com>
	 <a3ef07920904101559me72e8f7xa288b99bcc4a058@mail.gmail.com>
	 <621110570904110547v6b22ad5fv4db760816cb67338@mail.gmail.com>
Date: Sat, 11 Apr 2009 20:07:31 +0200
Message-ID: <621110570904111107p2395bd4dq47dfd31e48444660@mail.gmail.com>
Subject: Re: [linux-dvb] SkyStar HD2 (TwinHan VP-1041/Mantis) S2API support
From: Dave Lister <foceni@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/11 Dave Lister <foceni@gmail.com>:
>
> RESULTS (using "s2" dvb-apps):
> - scanning DVB-S works
> - scanning DVB-S2 doesn't work
> - zapping DVB-S is fast
>
> BUT there is a big problem now; even when I have FE_HAS_LOCK,
> /dev/dvb/adapter0/dvr0 is dead; trying to read dvr0 blocks as if there
> was no lock! Any suggestions? I'd really like to make this work - this
> driver seems the best of both worlds! :)
>

My bad, didn't know -r had to be used with szap. :) Now both drivers
(mantis-v4l, liplianin-s2) seem to work fine, although when I do
something with DVB-S2, I loose signal altogether and have to reboot.
Module reload doesn't help, so I'd say the drivers botch something
inside the HW. :) Will report back as soon as I know more.

Thank you for helping me out, everybody!

-- 
David Lister
