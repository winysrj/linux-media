Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:47807 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZFIOVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 10:21:19 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KKZ00J3F6JI3Z30@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 09 Jun 2009 10:21:21 -0400 (EDT)
Date: Tue, 09 Jun 2009 10:21:17 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
In-reply-to: <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: David Ward <david.ward@gatech.edu>, linux-media@vger.kernel.org
Message-id: <4A2E6FDD.5000602@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
 <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>
 <4A2D4778.4090505@gatech.edu> <4A2D7277.7080400@kernellabs.com>
 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Steven,
> 
> One thing that is interesting is that he is getting BER/UNC errors
> even on ATSC, when he has a 30.2 dB signal.  While I agree that the
> cable company could be sending a weak signal, 30 dB should be plenty
> for ATSC.
> 
> Also, it's possible that the playback application/codec in question
> poorly handles recovery from MPEG errors such as discontinuity, which
> results in the experience appearing to be worse under Linux.
> 
> I'm going to see if I can find some cycles to do some testing here
> with s5h1409/s5h1411 and see if I can reproduce what David is seeing.

Thanks.

I ruled out 30db on ATSC because that sounds incredibly high, I assumed cable 
because that would be consistent with the numbers. You could well be right.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
