Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1LMke9-0003Hn-7W
	for linux-dvb@linuxtv.org; Tue, 13 Jan 2009 15:53:38 +0100
Received: from steven-toths-macbook-pro.local
	(ool-45721e5a.dyn.optonline.net [69.114.30.90]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0KDF00CDD006ULF0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 13 Jan 2009 09:52:55 -0500 (EST)
Date: Tue, 13 Jan 2009 09:52:54 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e5df86c90901051829g382b2ef1tecb57c9f3b17c15f@mail.gmail.com>
To: Mark Jenks <mjenks1968@gmail.com>
Message-id: <496CAAC6.9010505@linuxtv.org>
MIME-version: 1.0
References: <e5df86c90901051829g382b2ef1tecb57c9f3b17c15f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx23885 Fix for oops if you install
 HVR-1250 and HVR-1800 in the same computer.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Mark Jenks wrote:
> Analog support for HVR-1250 has not been completed, but does exist for
> the HVR-1800.
> 
> Since both cards use the same driver, it tries to create the analog
> dev for both devices, which is not possible.
> 
> This causes a NULL error to show up in video_open and mpeg_open.
> 
> -Mark
> 
> Signed-off-by: Mark Jenks <mjenks1968@gmail.com>

This makes sense, thanks for the patch.

- Steve

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
