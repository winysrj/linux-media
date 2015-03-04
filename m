Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:36722 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbCDPOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 10:14:07 -0500
Received: by yks20 with SMTP id 20so3393941yks.3
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2015 07:14:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150304112422.7c9a6dc1@recife.lan>
References: <CALzAhNXOAJR6tV6PGL4-zqeE-Kx0BYgOxZpEfRvN6fmv9_wMKA@mail.gmail.com>
	<20150304112422.7c9a6dc1@recife.lan>
Date: Wed, 4 Mar 2015 10:14:06 -0500
Message-ID: <CALzAhNUWX0G9HNf_i5qHBH7BLbMN8fHi3n7g7Cr+xzC3QHmn9g@mail.gmail.com>
Subject: Re: HVR2205 / HVR2255 support
From: Steven Toth <stoth@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Mauro, what's the plan to pull the LGDT3306A branch into tip? The
>> SAA7164/HVR2255 driver need this for demod support.
>
> Merged yesterday. Today, I added one fix from Olli to extend the
> si2157 minimal frequency to match the ATSC tuner range (needed by
> HVR-955Q - not sure if HVR2255 also uses si2157 as tuner).

Thank you sir.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
