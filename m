Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp108.rog.mail.re2.yahoo.com ([68.142.225.206]:33036 "HELO
	smtp108.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752069AbZALDNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 22:13:47 -0500
Message-ID: <496AB569.50503@rogers.com>
Date: Sun, 11 Jan 2009 22:13:45 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Josh Borke <joshborke@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <496A9485.7060808@gmail.com>
In-Reply-To: <496A9485.7060808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Josh Borke wrote:
> After upgrading to Fedora 10 I am no longer able to tune analog or dvb
> channels using my KWorld ATSC 115. When I try to view a channel with
> tvtime all I can see is static and when I try to scandvb I keep
> getting tuning failed even though I know that there are channels being
> broadcast on the channels scanned. I have tried to find tips on the
> wiki of how to resolve my static problem but I could not find any. I'm
> not sure where to look for clues as to why it isn't working.
>
> I have a 1-to-4 splitter with 2 outputs going to the inputs of the
> KWorld ATSC and another going to a TV so I know there is signal on the
> cable.
>
> Any help would be really appreciated.

Josh,

The analog issue was obviously addressed in my last message.

Now, in regards to the DVB handling -- there have been a number of
recent Fedora 10 related problems being reported on the lists, and you
may happen to fall within that category.  I'd suggest having a look at
your dmesg output to see if there is any error being reported.  Saving
that -- search the lists in regard to the recent rash of Fedora
problems.  And finally, try switching the RF input on which you attempt
to obtain a digital signal. 

