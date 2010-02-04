Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o14MMwcP023014
	for <video4linux-list@redhat.com>; Thu, 4 Feb 2010 17:22:58 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o14MMb2O014382
	for <video4linux-list@redhat.com>; Thu, 4 Feb 2010 17:22:41 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 05C7CD48031
	for <video4linux-list@redhat.com>; Thu,  4 Feb 2010 23:22:35 +0100 (CET)
Received: from UNKNOWN (imp1-g19.priv.proxad.net [172.20.243.131])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 30FA7D4815D
	for <video4linux-list@redhat.com>; Thu,  4 Feb 2010 23:22:33 +0100 (CET)
Message-ID: <1265322153.4b6b48a9137c7@imp.free.fr>
Date: Thu, 04 Feb 2010 23:22:33 +0100
From: yann.lepetitcorps@free.fr
To: video4linux-list@redhat.com
Subject: Re: video4linux-list Digest, Vol 72, Issue 3
References: <mailman.14.1265302803.11313.video4linux-list@redhat.com>
In-Reply-To: <mailman.14.1265302803.11313.video4linux-list@redhat.com>
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a formula that I use and that work very well in a vertex shader for a
YCbCr to RGB conversion :

	y =  1.1643 * (y - 0.0625);

	r = y + 1.5958 * v;
	g = y - 0.39173 * u - 0.8129 * v;
	b = y + 2.017 * u;

@+
Yannoo


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
