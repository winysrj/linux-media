Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m341jI0K028505
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 21:45:18 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m341j5m6012328
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 21:45:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JhazG-0006Ht-NU
	for video4linux-list@redhat.com; Fri, 04 Apr 2008 01:45:02 +0000
Received: from c9346dce.virtua.com.br ([201.52.109.206])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 04 Apr 2008 01:45:02 +0000
Received: from fragabr by c9346dce.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 04 Apr 2008 01:45:02 +0000
To: video4linux-list@redhat.com
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Date: Thu, 3 Apr 2008 22:18:20 -0300
Message-ID: <20080403221820.38797430@tux.abusar.org.br>
References: <20080401190033.68c821ed@tux.abusar.org.br>
	<1207093795.16537.4.camel@localhost.localdomain>
	<20080402183820.6c917a0a@tux.abusar.org.br>
	<1207204144.2386.1.camel@localhost.localdomain>
	<20080403144456.1e6bf438@tux.abusar.org.br>
	<pan.2008.04.03.20.14.56.901338@gimpelevich.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Thu, 03 Apr 2008 13:14:56 -0700
Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us> wrote:

> Those changes are wrong, especially WRT gpio2, which carries the IR


	You're completely right ;) Now everything is ok. I'm sending a
unified patch to this list so you can review it. If it's ok, I'll ask
Mauro Chehab to merge it.
	
	Thank you very much!

-- 
Linux 2.6.24: Arr Matey! A Hairy Bilge Rat!
http://u-br.net


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
