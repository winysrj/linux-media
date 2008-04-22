Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MD4LpZ002493
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 09:04:21 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MD47f5025146
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 09:04:07 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZQ00BQF9M76710@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Tue, 22 Apr 2008 09:03:45 -0400 (EDT)
Date: Tue, 22 Apr 2008 09:03:43 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080422034449.GC24855@plankton.ifup.org>
To: Brandon Philips <brandon@ifup.org>
Message-id: <480DE22F.1060109@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <480D5AF9.4030808@linuxtv.org>
	<20080422034449.GC24855@plankton.ifup.org>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: Hauppauge HVR1400 DVB-T support / XC3028L
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


Hi Brandon,

> On 23:26 Mon 21 Apr 2008, Steven Toth wrote:
>>  I've passed some patches to Mauro that add support for the Hauppauge
>>  HVR1400 Expresscard in DVB-T mode. (cx23885 bridge, dib7000p
>>  demodulator and the xceive xc3028L silicon tuner)
>>
>>  If you're interested in testing then wait for the patches to appear
>>  in the http://linuxtv.org/hg/v4l-dvb tree.
>>
>>  You'll need to download firmware from
>>  http://steventoth.net/linux/hvr1400
>>
>>  Post any questions or issues here.
> 
> Could you post the patches to the lists for review?  CC'ing both
> linux-dvb@linuxtv.org and video4linux-list@redhat.com is appropriate.

The last time I mailed personal tree info to the lists I had people 
referencing my local trees for way too long, posting support messages 
for code that was getting older and more and more out of date.

It created more of a problem than it solved so I rarely do that any more.

I like to engage the non-developers on this list only when it makes sense.


> 
> It is really difficult staying on top of V4L with private trees and
> private mails going around  :(
> 

Agreed, I guess.

I posted the patches to the appropriate maintainers for review, along 
with all of the dvb/v4l maintainers and Mauro. Nothing nefarious here, 
I've always done this.

The only difference is that I'm informing a number of people who've 
contacted me personally to ask for support - that support is about to 
arrive. (I did that over the weekend also with the 
HVR1200/HVR1700/TDA10048 email, and it kick-started a rather nice thread 
for people trying to bring up the TDA10048 on another product).

In summary, I have sign-off from the only other maintainer effected by 
the patches so I'd expect them to get merged very quickly into hg/v4l-dvb.

Comments / feedback welcome.

Regards,

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
