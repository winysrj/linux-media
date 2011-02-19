Return-path: <mchehab@pedra>
Received: from mx06.syd.iprimus.net.au ([210.50.76.235]:28702 "EHLO
	mx06.syd.iprimus.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1BSX7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 18:59:50 -0500
Message-Id: <e05367$6mkr9m@smtp06.syd.iprimus.net.au>
From: Mike Booth <mike_booth76@iprimus.com.au>
To: linux-media@vger.kernel.org
Subject: v4l-utils-0.8.3 and KVDR
Date: Sun, 20 Feb 2011 10:48:12 +1100
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

My understanding of the "wrappers"contained in this library is that v4l 
applications should work with kernels from 2.6.36 onwards if the compat.so is 
preloaded.

I use KVDR for watching and controlling VDR on my TV.

Xine and Xineliboutput or not options as they don't provide TV out and TV out 
fronm the video card is also not an option because of where things are in the 
house.

KVDR fails with 


Xv-VIDIOCGCAP: Invalid argument
Xv-VIDIOCGMBUF: Invalid argument

works perfectly fine on linux-2.6.35


Anyone have any ideas


Mike

