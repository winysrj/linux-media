Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3G7oCU7006238
	for <video4linux-list@redhat.com>; Thu, 16 Apr 2009 03:50:12 -0400
Received: from sohosted4.com (ns1.sohosted4.com [195.8.208.32])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3G7nw7l005821
	for <video4linux-list@redhat.com>; Thu, 16 Apr 2009 03:49:59 -0400
Date: Thu, 16 Apr 2009 09:50:20 +0200
To: Brian <linuxtv@leafcom.co.uk>
Message-ID: <20090416075020.GA22778@pazuzu.ehv.virtualproteins.com>
References: <49E5BAF4.6020200@leafcom.co.uk>
	<20090415105918.GA5232@pazuzu.ehv.virtualproteins.com>
	<49E5C85B.8090600@leafcom.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5C85B.8090600@leafcom.co.uk>
From: hlambermont@virtualproteins.com (Hans Lambermont)
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge DVB s/s2 card: Problem installing driver
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
> Hans Lambermont wrote:
>> Brian wrote on 20090415: ...
>>> File not found: /lib/modules/2.6.24-23-generic/build/.config at ./scripts/ make_kconfig.pl line 32, <IN> line 4.
>> You need to install the kernel headers and sources.
>>   
> Thanks for the reply Hans. I thought that if I had run an apt-get for
> update and upgrade the system would be fully up to date. Am I wrong?

Yes, this is not FreeBSD where a.o. the kernel sources are part of the
base install ;-)

You need to install the kernel headers, linux-headers-2.6.24-23 and
linux-headers-2.6.24-23-generic in your case.

-- Hans Lambermont

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
