Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53IG00d021754
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 14:16:00 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53IFidm013092
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 14:15:45 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K3b2q-0003C1-UI
	for video4linux-list@redhat.com; Tue, 03 Jun 2008 18:15:41 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 18:15:40 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 18:15:40 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Tue, 3 Jun 2008 18:15:30 +0000 (UTC)
Message-ID: <loom.20080603T165006-806@post.gmane.org>
References: <48457617.mail5YC1S9Z5F@vesta.asc.rssi.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Re: v4l API question: any support for HDTV is possible?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Sergey Kostyuk <kostyuk <at> vesta.asc.rssi.ru> writes:

> > Have you not seen this at all? http://dxr3.sf.net
> 
> I know that project. The DXR3 boards dont have HDTV capabilities.

The v4l API is a framework for frame grabbers and hardware encoders. There
exists no unified API for hardware decoders such as yours. Each hardware decoder
driver supplies an API of its own. The DXR3 project is most similar
hardware-wise to what you're coding. Other projects in that category include:

http://sf.net/projects/viaexp/
http://myhd.sf.net
https://wiki.ubuntu.com/mobile-hw-decode

The video output portion of the v4l API is also inadequate for this:
http://www.linuxtv.org/docs/dvbapi/DVB_Video_Device.html

If you want to output to a digital overlay, you'll likely need an Xorg module,
too. I wish you luck.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
