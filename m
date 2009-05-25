Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:33238 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZEYMe0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 08:34:26 -0400
Received: by ey-out-2122.google.com with SMTP id 9so788019eyd.37
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 05:34:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090525T113704-857@post.gmane.org>
References: <20080525020028.GA22425@ska.dandreoli.com>
	 <20080526073959.5a624288@gaivota>
	 <20090104151427.GA4683@tilt.dandreoli.com>
	 <loom.20090525T113704-857@post.gmane.org>
Date: Mon, 25 May 2009 14:34:25 +0200
Message-ID: <b40acdb70905250534k31bb8aa4v10a6ddea6f28d297@mail.gmail.com>
Subject: Re: TW6800 based video capture boards (updates)
From: Domenico Andreoli <cavokz@gmail.com>
To: Vito <vcovito@libero.it>
Cc: linux-media@vger.kernel.org, "William M. Brack" <wbrack@mmm.com.hk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 25, 2009 at 1:55 PM, Vito <vcovito@libero.it> wrote:
>
> Hi all.

Hi Vito,

> I've bought a Provideo 16 in capture PCI-Experess card for my own DVR solution.
> http://www.provideo.com.tw/DVRCARD_PV988.htm
> This card have 8 TW6805 chip installed.
> I've installed the card in a PC with Fedora Core 9 Linux OS
> With this kernel.
>
> There is some possibility that this card can work in some manner?

Few days ago I created a repository on gitorious, http://gitorious.org/tw68.
I pushed the clean room driver written by William, mine is not available
for publication. My plan is to dig into it and see what improvements I can
bring. Anybody interested is free to jump onboard.

Currently I am not able to make any statement of usability of the free
one but Willy surely can :)

Best regards,
Domenico Andreoli

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
