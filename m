Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:62177 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756867AbZKBW6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:58:52 -0500
Message-ID: <4AEF5FE5.2000607@stud.uni-hannover.de>
Date: Mon, 02 Nov 2009 23:40:37 +0100
From: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
MIME-Version: 1.0
To: zdenek.kabelac@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] NOVA-TD exeriences?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


 > > Hi. I would be happy to hear if anyone has tried both the NOVA-TD 
and the
 > > NOVA-T. The NOVA-T has always worked perfectly here but I would 
like to know
 > > if the -TD will do the job of two NOVA-T's. And there also seems to 
be a new
 > > version out with two small antenna connectors instead of the previous
 > > configuration. Anyone tried it? Does it come with an antenna 
adaptor cable?
 > > http://www.hauppauge.de/de/pics/novatdstick_top.jpg
 > > Thankful for any info.
 >
 > Well I've this usb stick with these two small connectors - and it runs
 > just fine.
 >
 > Though I think there is some problem with suspend/resume recently
 > (2.6.32-rc5)  and it needs some inspection.
 >
 > But it works just fine for dual dvb-t viewing.
 >
 > And yes - it contains two small antennas with small connectors and
 > one adapter for normal antenna - i.e. 1 antenna input goes to 2 small
 > antenna connectors.

zdenek, your nova-td stick works just fine for dual dvb-t viewing?
I always had this problem:
When one channel is streaming and the other channel is switched on, the
stream of the already running channel gets broken.
see also: 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg06376.html

Can you please test this case on your nova-td stick?

Thanks,
Soeren
