Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FAxAuj021500
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 06:59:10 -0400
Received: from sohosted4.com (ns1.sohosted4.com [195.8.208.32])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3FAwuFS008770
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 06:58:56 -0400
Date: Wed, 15 Apr 2009 12:59:18 +0200
To: Brian <linuxtv@leafcom.co.uk>
Message-ID: <20090415105918.GA5232@pazuzu.ehv.virtualproteins.com>
References: <49E5BAF4.6020200@leafcom.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5BAF4.6020200@leafcom.co.uk>
From: hlambermont@virtualproteins.com (Hans Lambermont)
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge DVB s/s2 card: Problem installing driver
Reply-To: video4linux-list@redhat.com
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

Brian wrote on 20090415:
...
> File not found: /lib/modules/2.6.24-23-generic/build/.config at ./scripts/ make_kconfig.pl line 32, <IN> line 4.

You need to install the kernel headers and sources.

-- Hans Lambermont

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
