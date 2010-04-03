Return-path: <linux-media-owner@vger.kernel.org>
Received: from web63407.mail.re1.yahoo.com ([69.147.97.47]:34351 "HELO
	web63407.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753283Ab0DCOkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Apr 2010 10:40:22 -0400
Message-ID: <219774.16036.qm@web63407.mail.re1.yahoo.com>
Date: Sat, 3 Apr 2010 07:33:41 -0700 (PDT)
From: oblib <oblib5@yahoo.com>
Subject: Working Avermedia Duet A188 (saa716x and lgdt3304)
To: linux-media@vger.kernel.org
Cc: mrechberger@empiatech.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to get the Avermedia Duet A188 up and working again (see the list about a year ago) and I'm running into the same problem. I'm using Manu's SAA716x driver, and I've modified the budget version to identify with my card. I copied the vp1028 frontend attach function and modified it to call lgdt3304_attach. 

When I compile and load, I get two dvb adaptors with frontends, but of course it can't tune successfully because I don't know the i2c address to pass to lgdt3304_attach. This where I need some help. I don't see any other driver using the lgdt3304, and even if there was another one, the i2c address wouldn't be the same. How do I determine the address? It's a ubyte value, so I could even manually try all 256 addresses, but I don't know how to tell if it's successfully addressed or not.

Also, seeing as I don't see anyone else using this driver and it's got comments saying "not yet tested," will the driver even work correctly for this application if I get the right address? If not, how do I fix it?

Thanks in advance for the help!


      
