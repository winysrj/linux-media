Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24FWbPk031252
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 10:32:37 -0500
Received: from smtpout1.ngs.ru (smtpout1.ngs.ru [195.93.186.195])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24FW5ek019897
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 10:32:06 -0500
Received: from [192.168.3.4] (unknown [192.168.3.4])
	(Authenticated sender: aptem@ngs.ru)
	by smtp.ngs.ru (smtp) with ESMTP id C55ED3CCA6BD
	for <video4linux-list@redhat.com>;
	Tue,  4 Mar 2008 21:32:00 +0600 (NOVT)
Message-ID: <47CD6B7A.7080904@ngs.ru>
Date: Tue, 04 Mar 2008 21:32:10 +0600
From: Bokhan Artem <APTEM@ngs.ru>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47CD5B18.3000409@ngs.ru>
In-Reply-To: <47CD5B18.3000409@ngs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: how to disable nicam stereo on saa7134?
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

Seems that it's possible via modprobe saa7134 ... audio_ddep=8
Don't think this is right way, nicam stereo should be disabled when 
passing "mono" to v4l ...
May be some day developers will see this message :)

Bokhan Artem пишет:
> I need to disable nicam stereo, if it's possible. When I pass "mono" 
> via v4l, the driver still tries to detect nicam stereo.
>
> kernel: saa7133[4]/audio: tvaudio thread status: 0x198029 [D/K 
> NICAM,stereo]
> kernel: saa7133[4]/audio: detailed status: ######## VDSP # NICST ### 
> NICAM reserve sound # init done
>
> May somebody help with saa7134 source code, possible with 
> saa7134-tvaudio.c?
>
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
