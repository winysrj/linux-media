Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:37218 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLUUNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 15:13:18 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2448112fgg.1
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2009 12:13:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <34373e030912211209r78ff1912vfd0acc6f661e6878@mail.gmail.com>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
	 <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
	 <1260523942.3087.21.camel@palomino.walls.org>
	 <34373e030912181159k32d36a40yc989dfd777504aaa@mail.gmail.com>
	 <83bcf6340912181213i31e455a0tad3ab0b070caf508@mail.gmail.com>
	 <34373e030912211209r78ff1912vfd0acc6f661e6878@mail.gmail.com>
Date: Mon, 21 Dec 2009 15:13:16 -0500
Message-ID: <829197380912211213y7368f435jf1bf693cfe7d16f2@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Longfield <robert.longfield@gmail.com>
Cc: Steven Toth <stoth@kernellabs.com>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 21, 2009 at 3:09 PM, Robert Longfield
<robert.longfield@gmail.com> wrote:
> Well it gets even better.
> So on the weekend I was able to steal a few minutes to properly
> trouble shoot the issue now that I know it was in the mythbuntu box.
> As a long shot I pulled out the Promise Tech Ultra133 TX2 / ATA card I
> am using for the backup drive. With this card removed the sync issue
> went away, when I put the card back in the issue returned. Now this
> card was in the slot right next to the PVR-150 card. I moved the
> controller card as far away as I could get from the PVR-150 and the
> sync issue was gone.
>
> So it would appear that the Promise Tech card was causing some EM
> interference with the PVR-150 card. I will keep an eye on this to make
> sure that this was indeed the issue.
>
> Does it seem reasonable that this card would kick out interference like this?

Having worked at a lab that did EMI compliance testing, I can
definitely tell some stories of cases far stranger than that.  But
yeah, if the card works in a different slot, then it's unlikely any
sort of PCI bus congestion issue but rather an EMI problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
