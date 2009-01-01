Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01GVHAx011349
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 11:31:17 -0500
Received: from patsy.thehobsons.co.uk (patsy.thehobsons.co.uk [81.174.135.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01GV4Hs011657
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 11:31:04 -0500
Received: from localhost (localhost [127.0.0.1])
	by patsy.thehobsons.co.uk (Postfix) with ESMTP id 1D3E51B44A6
	for <video4linux-list@redhat.com>; Thu,  1 Jan 2009 16:31:02 +0000 (GMT)
Received: from patsy.thehobsons.co.uk ([127.0.0.1])
	by localhost (patsy.thehobsons.co.uk [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id UpuaSxxz3-gb for <video4linux-list@redhat.com>;
	Thu,  1 Jan 2009 16:31:02 +0000 (GMT)
Received: from simon.thehobsons.co.uk (Simons-MacBookPro.thehobsons.co.uk
	[192.168.0.149])
	by patsy.thehobsons.co.uk (Postfix) with ESMTP id C86071B436C
	for <video4linux-list@redhat.com>; Thu,  1 Jan 2009 16:31:01 +0000 (GMT)
Mime-Version: 1.0
Message-Id: <a0624080fc5829ec402a2@simon.thehobsons.co.uk>
In-Reply-To: <1230824289.2669.2.camel@pc10.localdom.local>
References: <a06240804c580f44d7a48@simon.thehobsons.co.uk>	
	<a0624080bc58126e6561c@simon.thehobsons.co.uk>
	<1230824289.2669.2.camel@pc10.localdom.local>
Date: Thu, 1 Jan 2009 16:30:52 +0000
To: video4linux-list@redhat.com
From: Simon Hobson <linux@thehobsons.co.uk>
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Subject: Re: Problem setting up HVR-1110
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

hermann pitton wrote:

>yep, 2.6.18 was too old.

Hmm, I'd been going from the Wiki that suggested it was supported in 
2.6.18. From http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards :

>>Supported with the latest 2.6.18 kernel

Anyway, forced me to upgrade a few things AND learn some more about 
fixing stuff I broke !

Mind you, it took some time to figure out why I couldn't find any 
channels. Borrowed the portable telly from another room to check the 
aerial and found ... that I'd got a wonky plug and the pin was pushed 
over and shorting out. Works a lot better with a signal :-/

-- 
Simon Hobson

Visit http://www.magpiesnestpublishing.co.uk/ for books by acclaimed
author Gladys Hobson. Novels - poetry - short stories - ideal as
Christmas stocking fillers. Some available as e-books.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
