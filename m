Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([67.18.82.11]:51060 "EHLO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933453Ab3FSBe6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 21:34:58 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway14.websitewelcome.com (Postfix) with ESMTP id 9B16462170B15
	for <linux-media@vger.kernel.org>; Tue, 18 Jun 2013 19:38:00 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: =?iso-8859-1?Q?'Daniel_Gl=F6ckner'?= <daniel-gl@gmx.net>,
	"'Steve Cookson'" <it@sca-uk.com>
Cc: "'James Board'" <jpboard2@yahoo.com>, <linux-media@vger.kernel.org>
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com> <8B18C28300FE4A6595829F526C5BA94A@SACWS001> <1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com> <8737EBB72A154800A3A695B49F355F07@SACWS001> <1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com> <7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001> <20130618230655.GA23989@minime.bse>
In-Reply-To: <20130618230655.GA23989@minime.bse>
Subject: RE: HD Capture Card (HDMI and Component) output raw pixels
Date: Tue, 18 Jun 2013 17:38:00 -0700
Message-ID: <012601ce6c85$40930470$c1b90d50$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right -- not practical, since you need 1920*1080*3*50 = 311.04MB/s bandwidth
to transfer from PCIe and save the raw date onto a SSD, at which the PCIe
1.x link x1 (max 250MB/s) can not really meet such requirement. 

Well, PCIe 2.x link x1 can meet since its max is 500MB/s. Or, using YUYV, a
more common format, would be fine, since it requires 207.36MB/s and reduces
the storage requirement from 1.119744GB (1920*1080*3*50*60*60, with RGB
format) to 0.746496GB (1920*1080*2*50*60*60, with YUYV format).

Best,

Charlie X. Liu


-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Daniel Glöckner
Sent: Tuesday, June 18, 2013 4:07 PM
To: Steve Cookson
Cc: 'James Board'; linux-media@vger.kernel.org
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels

On Tue, Jun 18, 2013 at 05:55:15PM -0300, Steve Cookson wrote:
> > I don't want to configure a RAID either, but if I purchase one SSD 
> > with
> 400 MB/sec write speeds, that might be good.
> 
> Hmm... nice idea.  Did you have any particular model in mind?  If you 
> had a link, I might be interested. I wouldn't know about sizing.  I 
> don't know how much space HD raw video takes up per hour, say.

That's easy. My current video mode is 24 bit 1920x1080 at 50 fps.
So there are 3*1920*1080*50 bytes per second or about 1.1TB per hour.
But you won't be able to capture all frames with that card. The single lane
PCIe 1.x bus will max out at 200~250MB/s.

  Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

