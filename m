Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:52436 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1FNLQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 07:16:02 -0400
Message-ID: <4DF742D7.5020606@usa.net>
Date: Tue, 14 Jun 2011 13:15:35 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Bart Coninckx <bart.coninckx@telenet.be>
CC: linux-media@vger.kernel.org
Subject: Re: "dvb_ca adaptor 0: PC card did not respond :(" with Technotrend
 S2-3200
References: <4DF53E1F.7010903@telenet.be> <4DF73B45.7000900@usa.net> <4DF73C94.7010003@telenet.be>
In-Reply-To: <4DF73C94.7010003@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 14/06/2011 12:48, Bart Coninckx wrote:
>
> I will try your suggestion though. Off topic, but would you advice
> 11.4 in favor of 11.3? As a secondary route, I was thinking about
> using sasc-ng (softcamming, legal in this case) and the code seems not
> to want to compile on 11.4. Also 11.4 broke after updating the kernel.

Except from the different kernel version, you can go for 11.3, as far as
you're concerned only by TV related stuff.

You might want to recompile the kernel with a newer version to get all
the patches related to the S2 3200.

Also, do not hesitate to try out different versions of the kernel if you
stumble upon problem with the S2 3200; I had some trouble with it and
some recent patches do not suit my setup (dish, cable length, diseqc
switch, etc ...)

For the sasc-ng matter, I did play with it last year but figured it is a
time black hole when it does not work. I guess you have a legal
subscription card. Then unless you like to play around, just drop
softcams. And CAMs are not that expensive.

--
Issa
