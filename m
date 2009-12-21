Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:63687 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLUUJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 15:09:28 -0500
Received: by fxm7 with SMTP id 7so5311591fxm.29
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2009 12:09:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83bcf6340912181213i31e455a0tad3ab0b070caf508@mail.gmail.com>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
	 <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
	 <1260523942.3087.21.camel@palomino.walls.org>
	 <34373e030912181159k32d36a40yc989dfd777504aaa@mail.gmail.com>
	 <83bcf6340912181213i31e455a0tad3ab0b070caf508@mail.gmail.com>
Date: Mon, 21 Dec 2009 15:09:26 -0500
Message-ID: <34373e030912211209r78ff1912vfd0acc6f661e6878@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Robert Longfield <robert.longfield@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well it gets even better.
So on the weekend I was able to steal a few minutes to properly
trouble shoot the issue now that I know it was in the mythbuntu box.
As a long shot I pulled out the Promise Tech Ultra133 TX2 / ATA card I
am using for the backup drive. With this card removed the sync issue
went away, when I put the card back in the issue returned. Now this
card was in the slot right next to the PVR-150 card. I moved the
controller card as far away as I could get from the PVR-150 and the
sync issue was gone.

So it would appear that the Promise Tech card was causing some EM
interference with the PVR-150 card. I will keep an eye on this to make
sure that this was indeed the issue.

Does it seem reasonable that this card would kick out interference like this?

-Rob

On Fri, Dec 18, 2009 at 3:13 PM, Steven Toth <stoth@kernellabs.com> wrote:
>> So it looks like the problem is restricted to my mythbuntu box.
>
> Congrats, that's better news.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>
