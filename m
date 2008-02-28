Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1S3sStK014806
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 22:54:28 -0500
Received: from mta4.srv.hcvlny.cv.net (mta4.srv.hcvlny.cv.net [167.206.4.199])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1S3ruJE007121
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 22:53:56 -0500
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JWX0075QK5MVK31@mta4.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Wed, 27 Feb 2008 22:53:46 -0500 (EST)
Date: Wed, 27 Feb 2008 22:53:45 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <47C611BC.1050302@sbcglobal.net>
To: Rodney Mathes <linen0ise@sbcglobal.net>
Message-id: <47C63049.80707@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <ced06bb70802261904x15645611xed4bdd8fe72e70c1@mail.gmail.com>
	<47C611BC.1050302@sbcglobal.net>
Cc: video4linux-list@redhat.com
Subject: Re: HVR-1600 ATSC support: hverkuil or stoth tree?
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

Rodney Mathes wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Jejo Koola wrote:
>> Sorry to beat a dead horse, but I read there was experimental support for
>> ATSC in the Hauppauge HVR-1600.  If this is true, should I try the
>> stoth/cx18 trunk or the hverkuil/cx18 trunk?
>>
>> thanks for the insight
>>
> Wondering the same.   What needs to be serviced on the ATSC side so we
> the developers can participate?  Anyone reversed engineered the Window
> drivers?

I have the major pieces of the DVB code in stoth/cx18, as yet the DVB 
portioning does not function as the cx23418 needs some registry tweaks, 
and the tuner driver may need some time. This project isn't right at the 
top of my list right now.

However, if you feel like testing the analog stuff then that's working 
quite well but you should grab Hans's tree.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
