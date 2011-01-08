Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:56926 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1AHM1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:27:35 -0500
Subject: Re: Failure to build media_build
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <1294489436.2467.2.camel@tvboxspy>
Date: Sat, 8 Jan 2011 22:57:08 +1030
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4B54A1C9-7971-4A12-B8A5-113D71333F8A@dons.net.au>
References: <771EA60D-3B3B-4C28-AD20-2CADDF57E26E@dons.net.au> <1294489436.2467.2.camel@tvboxspy>
To: Malcolm Priestley <tvboxspy@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 08/01/2011, at 22:53, Malcolm Priestley wrote:
>> I don't need/want 1394 (I am testing a cx23885 FusionHDTV) but I don't know how to disable them :(
>> 
>> I tried make config but I have no idea what the "usual" answers would be.. Is there a way to generate a file of the default options which I can review and edit?
>> 
>> Thanks
>> 
> 
> edit v4l/.config and change firedtv to n.

Ahh, great!

Thanks :)

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






