Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FBhkH7012030
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 07:43:46 -0400
Received: from smtp-out2.blueyonder.co.uk (smtp-out2.blueyonder.co.uk
	[195.188.213.5])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3FBhRK2031321
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 07:43:27 -0400
Received: from [172.23.170.138] (helo=anti-virus01-09)
	by smtp-out2.blueyonder.co.uk with smtp (Exim 4.52)
	id 1Lu3WZ-00088K-7Z
	for video4linux-list@redhat.com; Wed, 15 Apr 2009 12:43:27 +0100
Received: from [77.97.147.200] (helo=[192.168.178.23])
	by asmtp-out6.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1Lu3WY-0001TN-IU
	for video4linux-list@redhat.com; Wed, 15 Apr 2009 12:43:26 +0100
Message-ID: <49E5C85B.8090600@leafcom.co.uk>
Date: Wed, 15 Apr 2009 12:43:23 +0100
From: Brian <linuxtv@leafcom.co.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49E5BAF4.6020200@leafcom.co.uk>
	<20090415105918.GA5232@pazuzu.ehv.virtualproteins.com>
In-Reply-To: <20090415105918.GA5232@pazuzu.ehv.virtualproteins.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Hauppauge DVB s/s2 card: Problem installing driver
Reply-To: linuxtv@leafcom.co.uk
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

Hans Lambermont wrote:
> Brian wrote on 20090415:
> ...
>   
>> File not found: /lib/modules/2.6.24-23-generic/build/.config at ./scripts/ make_kconfig.pl line 32, <IN> line 4.
>>     
>
> You need to install the kernel headers and sources.
>
> -- Hans Lambermont
>   
Thanks for the reply Hans. I thought that if I had run an apt-get for 
update and upgrade the system would be fully up to date. Am I wrong?

These are the active entries in  /etc/apt/sources.list

deb http://gb.archive.ubuntu.com/ubuntu/ hardy multiverse
deb-src http://gb.archive.ubuntu.com/ubuntu/ hardy multiverse
deb http://gb.archive.ubuntu.com/ubuntu/ hardy-updates multiverse
deb-src http://gb.archive.ubuntu.com/ubuntu/ hardy-updates multiverse

deb http://archive.canonical.com/ubuntu hardy partner
deb-src http://archive.canonical.com/ubuntu hardy partner

deb http://security.ubuntu.com/ubuntu hardy-security main restricted
deb-src http://security.ubuntu.com/ubuntu hardy-security main restricted
deb http://security.ubuntu.com/ubuntu hardy-security universe
deb-src http://security.ubuntu.com/ubuntu hardy-security universe
deb http://security.ubuntu.com/ubuntu hardy-security multiverse
deb-src http://security.ubuntu.com/ubuntu hardy-security multiverse
deb http://packages.medibuntu.org/ hardy free non-free
deb http://ppa.launchpad.net/team-xbmc-hardy/ppa/ubuntu hardy main
deb-src http://ppa.launchpad.net/team-xbmc-hardy/ppa/ubuntu hardy main

Brian




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
