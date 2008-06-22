Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5MLqbRC011909
	for <video4linux-list@redhat.com>; Sun, 22 Jun 2008 17:52:37 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5MLqBLO030066
	for <video4linux-list@redhat.com>; Sun, 22 Jun 2008 17:52:19 -0400
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 8587912B6CB
	for <video4linux-list@redhat.com>;
	Sun, 22 Jun 2008 23:52:11 +0200 (CEST)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net
	[81.57.151.96])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 6358E12B6D7
	for <video4linux-list@redhat.com>;
	Sun, 22 Jun 2008 23:52:11 +0200 (CEST)
Message-ID: <485EC98B.4050803@free.fr>
Date: Sun, 22 Jun 2008 23:52:11 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
References: <485D4972.2070801@free.fr> <485E8A2C.5030905@free.fr>
In-Reply-To: <485E8A2C.5030905@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: application hanging with 2.6.25 and bttv
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

matthieu castet wrote:
> matthieu castet wrote:
>> Hi,
>>
>> I have got a tv application that doesn't work anymore with 2.6.25 : it 
>> hangs.
>>
> using mplayer with v4l backed produce the same lockup :
> 
Ok the bug is know http://lkml.org/lkml/2008/6/13/293 (and fixed in 
stable kernel version).

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
