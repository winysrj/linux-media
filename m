Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:59717 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZA1Tsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 14:48:31 -0500
Message-ID: <4980B682.4010406@gmail.com>
Date: Wed, 28 Jan 2009 23:48:18 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: crow <crow@linux.org.ba>
CC: linux-media@vger.kernel.org
Subject: Re: Re : [linux-dvb] Technotrend Budget S2-3200 Digital artefacts
 on 	HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	 <1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>	 <c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>	 <497F6B2E.6010305@gmail.com>	 <c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>	 <497F7C40.6030300@gmail.com>	 <c74595dc0901271402g5a44fe05pecae642570e54e0f@mail.gmail.com>	 <497F927E.8050009@gmail.com>	 <b1dab3a10901280303s62a5afd8oe906ce93f05614dd@mail.gmail.com>	 <1233159564.8255.0@manu-laptop> <3c031ccc0901280907i46d8c7b2i5e92581b265ba7c9@mail.gmail.com>
In-Reply-To: <3c031ccc0901280907i46d8c7b2i5e92581b265ba7c9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

crow wrote:
> Hi,
> I have also TT-3200 and would like to have driver which are not able
> to burn anything, but to WORK as they should. I am currently using
> liplianindvb repository, because it seems only one working with my
> card. To bad that they have code which "can burn demodulator" in some
> case, as i don't wanna that. Well till now i have had luck then seems
> so, but....
> I can use multiproto driver to but they should work OK with tt-3200 (i
> can test them to if needed) have only Astra 19.2E and Hotbird 13.0.

You can use either multiproto or S2API according to your desire.
The S2API based driver is found here: http://jusst.de/hg/v4l-dvb

If you want to try the multiproto version the driver is found here:
http://jusst.de/hg/multiproto

Please do a vanilla test of the v4l-dvb tree (from jusst.de),
whether you see any further difference.

Please try the changes that which i posted on top of the multiproto
or the v4l-dvb tree and test your changes.

You can test with loading the modules with the verbose=5 option,
such that you can see what's happening internally.

To test, rather than doing a scan, you should try doing a szap,
since it is better for testing and to find issues. Testing with scan
 will not help much as there will be other issues involved in it as
well.

Regards,
Manu

