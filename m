Return-path: <mchehab@pedra>
Received: from blu0-omc2-s13.blu0.hotmail.com ([65.55.111.88]:48573 "EHLO
	blu0-omc2-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001Ab0ITIHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 04:07:32 -0400
Message-ID: <BLU0-SMTP149C6D157B323B4A2AA0ECED87E0@phx.gbl>
From: SE <tuxoholic@hotmail.de>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] faster DVB-S lock with cards using stb0899 demod
Date: Mon, 20 Sep 2010 10:07:28 +0200
References: <BLU0-SMTP171C6E7DC623134C34370D5D87B0@phx.gbl>
In-Reply-To: <BLU0-SMTP171C6E7DC623134C34370D5D87B0@phx.gbl>
CC: eallaud@yahoo.fr
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sun 19 Sep 2010, at 22:33:16 Emmanuel ALLAUD wrote:

>
>I will try this with a TT-S2 3200 when I find some time ;-) Do I need a very 
>recent tree?
>
>I have a v4l-dvb tree from a year ago I think.
>

Hello Emmanuel

Testers in vdr-portal reported good result with the TT-s2 3200 so it's worth 
trying.

There has not been much going on in that particular file in v4l-dvb, so you 
might have a chance and use it with your version of v4l-dvb. The majordomo of 
vger.kernel.org blacklisted the domain name on line 7 of the patch as well 
(he's thorough, isn't he? ;-) ) so you'll have to replace that hidden domain 
name inside the patch with the one from the original file and it should apply 
without rejects.

Same goes for line 30 of the szap-s2 patch, there is another domain name to be 
replaced from the original file, and the patch will apply fine.

You had problems two years ago with the patch of Alex at tuning some 8psk 
channels [1], it might be a good idea to test those channels again with v4l-
dvb.

happy patching, compiling, testing and tuning! ...

Should this terribly fail with the patching, there is a tarball attached 
inside posting #1 of vdr-portal you can download and use. Most of the text is 
in German, but feel free to ask questions in English and post your test 
results in English over here or over there.

I'd also like some v4l-dvb maintainers to test and comment on this patch if 
possible. There are quite a bunch of stb0899 cards out there, so I hope you 
guys still use one of these cards and can test it on.

[1] http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029538.html
