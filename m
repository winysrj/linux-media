Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BLHv4h011288
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 17:17:57 -0400
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BLHOrZ026082
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 17:17:24 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: itman <itman@fm.com.ua>
In-Reply-To: <47D6F12C.7040102@fm.com.ua>
References: <47D6F12C.7040102@fm.com.ua>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 22:09:21 +0100
Message-Id: <1205269761.5927.77.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: simon@kalmarkaglan.se, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	midimaker@yandex.ru, xyzzy@speakeasy.org
Subject: Re: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
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

Am Dienstag, den 11.03.2008, 22:53 +0200 schrieb itman:
> Hi Herman, Mauro.
> 
> Status with 2.6.24 is OK, BUT with the following changes:
> 
> 1) mkdir /usr/src/linux/tmpmsi
> 2) cd tmpmsi
> 3) hg init
> 4) hg pull http://linuxtv.org/hg/v4l-dvb
> 5) make
> 6) make install
> 
> and changes for 2.6.24.3 :
> 
> Adding to /etc/modprobe.conf  this line:
> 
> options tda9887 port1=0 port2=0 qss=1
> 
> After reboot it works fine!
> 
> In 2.6.23 was used tuner instead tda9887
> so it was
> options tuner port1=0 port2=0 qss=1
> 
> 
> Rgs,
>     Serge.

Hi Serge,

fine, that was what I tried to explain.

I have started to write a mail on it already, maybe it provides some
deeper insights and is useful for the records. So I send it despite off
you have realized the problem now.

Thanks,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
