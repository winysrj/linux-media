Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:43111 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab1FNKnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 06:43:51 -0400
Message-ID: <4DF73B45.7000900@usa.net>
Date: Tue, 14 Jun 2011 12:43:17 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Bart Coninckx <bart.coninckx@telenet.be>
CC: linux-media@vger.kernel.org
Subject: Re: "dvb_ca adaptor 0: PC card did not respond :(" with Technotrend
 S2-3200
References: <4DF53E1F.7010903@telenet.be>
In-Reply-To: <4DF53E1F.7010903@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 13/06/2011 00:30, Bart Coninckx wrote:
> Hi all,
>
>
> hope you can help me this one, because there's not a whole of info
> about similar problems to be found.
>
> I have a Technotrend S2-3200 with CI and on three different distros I
> get this
>
> "dvb_ca adaptor 0: PC card did not respond :(
>
>
> in /var/log/messages.

Hi Bart,

I've got the same card running under OpenSuse 11.4 and Mythtv 0.24.1

I also have the same warning message, but somehow, when Mythtv grabs the
device, the CAM will be reset successfully (at least, in my case).

In the past, I solved this annoyance by adding a sleep in the CAM init
code [1] relevant to the S2-3200 until I found out Mythtv does something
about it.

[1] drivers/media/dvb/dvb-core/dvb_ca_en50221.c in function
dvb_ca_en50221_thread(void) add a sleep of 5 or 10 secs between the 1st
dprintk and the main loop.

Hope this helps,
--
Issa
