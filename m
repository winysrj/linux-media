Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1K8Jd9-0006e4-RS
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 20:40:40 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K2K00MLAJUNBHB0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 16 Jun 2008 14:40:02 -0400 (EDT)
Date: Mon, 16 Jun 2008 14:39:59 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080615190958.GA6792@opus.istwok.net>
To: David Engel <david@istwok.net>
Message-id: <4856B37F.20704@linuxtv.org>
MIME-version: 1.0
References: <20080613163914.GA31437@opus.istwok.net>
	<4852AB58.9010806@linuxtv.org> <20080615190958.GA6792@opus.istwok.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] A couple HVR-1800 questions
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

David Engel wrote:
> On Fri, Jun 13, 2008 at 01:16:08PM -0400, Steven Toth wrote:
>> David Engel wrote:
>>> First, what is the status of the analog capture capability?  My search
>>> ...
>> The analog encoder is running with the tree form linuxtv.org. It has  
>> some cleanup video ioctl2 rework going on by another dev here, but it's  
>> functional as is. It's usable today.
> 
> Thanks for the repsonse, Steven.
> 
>>> Second, as far as I can tell, the hardware can perform simultaneous
>>> analog and digital captures.  Is that correct and, if so, does/will
>>> the Linux driver support it?
>> Yes and yes.
>>
>> Typically the analog video devices are exposed as /dev/video0 (analog  
>> preview) /dev/video1 (encoder output) and /dev/dvb/... for the digital 
>> side.
> 
> Excellent.
> 
> Regarding the encoder and preview devices, that's different than the
> ivtv convention of using /dev/video(N) and and /dev/video(N+16).  Is
> there a reason you did it differently and should it be standardized
> across drivers?

Hi david,

This is how the cx88 driver model works. Pfft, who needs standards ;)

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
