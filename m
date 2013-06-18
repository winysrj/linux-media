Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64000 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855Ab3FRXG5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 19:06:57 -0400
Received: from mailout-de.gmx.net ([10.1.76.33]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MXkSn-1UmWhz2cGF-00Wqsv for
 <linux-media@vger.kernel.org>; Wed, 19 Jun 2013 01:06:56 +0200
Date: Wed, 19 Jun 2013 01:06:55 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Steve Cookson <it@sca-uk.com>
Cc: 'James Board' <jpboard2@yahoo.com>, linux-media@vger.kernel.org
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels
Message-ID: <20130618230655.GA23989@minime.bse>
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com>
 <8B18C28300FE4A6595829F526C5BA94A@SACWS001>
 <1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>
 <8737EBB72A154800A3A695B49F355F07@SACWS001>
 <1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com>
 <7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 18, 2013 at 05:55:15PM -0300, Steve Cookson wrote:
> > I don't want to configure a RAID either, but if I purchase one SSD with
> 400 MB/sec write speeds, that might be good.
> 
> Hmm... nice idea.  Did you have any particular model in mind?  If you had a
> link, I might be interested. I wouldn't know about sizing.  I don't know how
> much space HD raw video takes up per hour, say.

That's easy. My current video mode is 24 bit 1920x1080 at 50 fps.
So there are 3*1920*1080*50 bytes per second or about 1.1TB per hour.
But you won't be able to capture all frames with that card. The single
lane PCIe 1.x bus will max out at 200~250MB/s.

  Daniel
