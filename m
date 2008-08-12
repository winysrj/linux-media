Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KSwpL-0003eR-4v
	for linux-dvb@linuxtv.org; Tue, 12 Aug 2008 18:34:32 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5H00HDKY0HQ060@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 12 Aug 2008 12:33:56 -0400 (EDT)
Date: Tue, 12 Aug 2008 12:33:53 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080812042250.B929732675A@ws1-8.us4.outblaze.com>
To: stev391@email.com
Message-id: <48A1BB71.2000409@linuxtv.org>
MIME-version: 1.0
References: <20080812042250.B929732675A@ws1-8.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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


> ---------Leadtek_Winfast_PxDVR3200_H_Signed_Off.diff---------
> cx23885: Add DVB support for Leadtek Winfast PxDVR3200 H
> 
> ---------cx23885_callback_tidyup.diff---------
> cx23885: Remove Redundant if statements in tuner callback

Thanks.

Pull this tree and run a quick test again (I had an odd whitespace merge 
issue - likely thunderbirds fault - that I have to cleanup):

http://linuxtv.org/hg/~stoth/v4l-dvb/

If everything is working then I'll issue the pull request for final merge.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
