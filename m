Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVDiCMF016149
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 08:44:12 -0500
Received: from patsy.thehobsons.co.uk (patsy.thehobsons.co.uk [81.174.135.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVDhxGg017402
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 08:44:00 -0500
Received: from localhost (localhost [127.0.0.1])
	by patsy.thehobsons.co.uk (Postfix) with ESMTP id CBDEB1B4745
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 13:43:58 +0000 (GMT)
Received: from patsy.thehobsons.co.uk ([127.0.0.1])
	by localhost (patsy.thehobsons.co.uk [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id 35prL25MuA9x for <video4linux-list@redhat.com>;
	Wed, 31 Dec 2008 13:43:58 +0000 (GMT)
Received: from simon.thehobsons.co.uk (Simons-MacBookPro.thehobsons.co.uk
	[192.168.0.149])
	by patsy.thehobsons.co.uk (Postfix) with ESMTP id 78B4A1B4740
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 13:43:58 +0000 (GMT)
Mime-Version: 1.0
Message-Id: <a0624080bc58126e6561c@simon.thehobsons.co.uk>
In-Reply-To: <a06240804c580f44d7a48@simon.thehobsons.co.uk>
References: <a06240804c580f44d7a48@simon.thehobsons.co.uk>
Date: Wed, 31 Dec 2008 13:43:54 +0000
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

I wrote:
>I've got MythTV installed and bought a Hauppage HVR-1110 card for 
>it. The card is detected and the saa7134 driver loaded - but that 
>seems to be it. Everything I can find suggests that the card should 
>be identified automatically (and the TDA1004X driver & firmware 
>loaded), but it isn't.

<snip>

>uname -a reports :
>>Linux eddi 2.6.18-6-xen-amd64 #1 SMP Fri Dec 12 07:02:03 UTC 2008 
>>x86_64 GNU/Linux
>
>
>Yes, this is running in a Xen guest - but I've also tried booting 
>the machine into a non-Xen mode (with non-Xen kernel) and it behaves 
>exactly the same. In both cases, the OS is Debian Lenny.

Hmm, memory isn't what it used to be :-(

Went back and double checked, my Dom0 is Etch. Long story short - 
upgraded guest to 2.6.26, upgraded Xen to run it, fixed all the 
things the Xen upgrade changes, and it now is recognised and the 
firmware loaded etc.

-- 
Simon Hobson

Visit http://www.magpiesnestpublishing.co.uk/ for books by acclaimed
author Gladys Hobson. Novels - poetry - short stories - ideal as
Christmas stocking fillers. Some available as e-books.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
