Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TLEoaR015786
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 17:14:50 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TLEbYd009001
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 17:14:38 -0400
Message-ID: <4867FCAC.8070607@hhs.nl>
Date: Sun, 29 Jun 2008 23:20:44 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Antoine Cellerier <dionoea@videolan.org>
References: <4867F380.1040803@hhs.nl> <20080629210349.GA26587@chewa.net>
In-Reply-To: <20080629210349.GA26587@chewa.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Announcing libv4l 0.3.1 aka "the vlc release"
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

Antoine Cellerier wrote:
> On Sun, Jun 29, 2008, Hans de Goede wrote:
>> * Do not return an uninitialized variable as result code for GPICT
>>   (fixes vlc, but see below)
>> * Add a patches directory which includes:
>>   * vlc-0.8.6-libv4l1.patch, modify vlc's v4l1 plugin to directly call into
>>     libv4l1, in the end we want all apps todo this as its better then
>>     LD_PRELOAD tricks, but for vlc this is needed as vlc's plugin system
>>     causes LD_PRELOAD to not work on symbols in the plugins
> 
> You might want to submit those VLC specific patches upstream ...

A very valid point, and I will as soon as libv4l gets something resembling an 
official release (as port of the v4l-dvb tree). I see that you are from 
upstream. So what are your thoughts on this, is libv4l proven enough already to 
submit patches?

The patches will probably need a couple of #ifdefs added to allow compilation 
on systems without libv4l, right?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
