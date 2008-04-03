Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33KFQMY003102
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 16:15:26 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m33KFB5C027429
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 16:15:12 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JhVq1-00007T-48
	for video4linux-list@redhat.com; Thu, 03 Apr 2008 20:15:09 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 03 Apr 2008 20:15:09 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 03 Apr 2008 20:15:09 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Thu, 03 Apr 2008 13:14:56 -0700
Message-ID: <pan.2008.04.03.20.14.56.901338@gimpelevich.san-francisco.ca.us>
References: <20080401190033.68c821ed@tux.abusar.org.br>
	<1207093795.16537.4.camel@localhost.localdomain>
	<20080402183820.6c917a0a@tux.abusar.org.br>
	<1207204144.2386.1.camel@localhost.localdomain>
	<20080403144456.1e6bf438@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Remote controller for Powercolor Real Angel 330
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

On Thu, 03 Apr 2008 15:44:56 -0300, Dâniel Fraga wrote:

> 3) the changes already merged in the v4l-dvb tree are:

Those changes are wrong, especially WRT gpio2, which carries the IR
signal. It's possible that I may be able to order a PSU for the box
containing my RA330 today or tomorrow. After that, I may be able to port
my patch to the current tree. In the meantime, download
http://www.mcentral.de/hg/~mrec/v4l-dvb-experimental/archive/tip.tar.gz
and apply my patch at: http://pastebin.com/f44a13031
Then, you can closely examine the differences between the working code and
the development tree yourselves, thereby gaining a head start in porting
to the active development tree over me. It's possible that you may even
get everything working based on that before I even get to it.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
