Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n081pvqw001192
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 20:51:57 -0500
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n081pc4B032266
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 20:51:39 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: jordi@cdmon.com
In-Reply-To: <49646351.6030709@cdmon.com>
References: <49646351.6030709@cdmon.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 01:28:44 +0100
Message-Id: <1231374524.2613.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: support for remote in lifeview trio
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

Hi Jordi,

Am Mittwoch, den 07.01.2009, 09:09 +0100 schrieb Jordi Moles Blanco:
> hi,
> 
> i've been googling and trying some things during days with no luck.
> 
> i want to get the remote which comes with this card working, and i only 
> found old posts like this one:
> 
> http://www.spinics.net/lists/vfl/msg29862.html
> 
> which assures that the patch gets the remote to work on that card.
> 
> i downloaded the latest v4l source code and tried to patch it with the 
> code proposed on that post, but var names have changed and i don't have 
> a clue on how to apply it properly.
> 
> i haven't seen any more recent post, so i guess it may still be in a 
> to-do list, or may be it was rejected for some reason to go into the 
> main-line.
> 
> Could anyone tell me if this patch will ever be included? or... what v4l 
> version could i download to be able to patch it as described?
> 

the MSI TV@nywhere Plus with similar problems is included now.

http://linuxtv.org/hg/v4l-dvb/rev/7d81fb776d1f

Might be a hook for the Trio as well, but I don't remember the details
offhand anymore.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
