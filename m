Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:42386 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZBRO4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 09:56:25 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF900758O5PCBV0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 18 Feb 2009 09:56:14 -0500 (EST)
Date: Wed, 18 Feb 2009 09:56:13 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: PVR x50 corrupts ATSC 115 streams
In-reply-to: <20090218051945.GA12934@opus.istwok.net>
To: David Engel <david@istwok.net>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Message-id: <499C218D.7050406@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090217155335.GB6196@opus.istwok.net>
 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
 <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I then removed the 250 from slot 4 leaving the 115s in slots 1 and 2.
> The ber was through the roof and the recorded strams were filled with
> errors and were barely playable at best.

This ^^^^ is bad, you have something wrong with your feeds. They're probably 
over amp'd and your leaking RF like crazy.

Go back to basics, put the single unsplit and unamped feed into a single 115 and 
get that working reliably. Then, split (or amp) and try the second 115.

Try to work out what's causing BER to be > 0 and fix that first.

Personally, I wouldn't add the 250/350 back into the system until I had both 
115's running flawlessly with 0 BER and 0 UNC.

Chances are, the 250/350 will work correctly after this - unless the drivers 
really do have a DMA issue. It's too early to say given the BER/UNC issues 
you're seeing though.

- Steve

