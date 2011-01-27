Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p0RM0CtP018555
	for <video4linux-list@redhat.com>; Thu, 27 Jan 2011 17:00:12 -0500
Received: from soapstone1.mail.cornell.edu (soapstone1.mail.cornell.edu
	[128.253.83.143])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0RM01o8002573
	for <video4linux-list@redhat.com>; Thu, 27 Jan 2011 17:00:02 -0500
From: Devin Bougie <devin.bougie@cornell.edu>
To: "Charlie X. Liu" <charlie@sensoray.com>
Date: Thu, 27 Jan 2011 17:00:00 -0500
Subject: Re: xawtv crashes with Sensoray 611 on RHEL5
Message-ID: <F4FFE7D4-65AE-49C7-85CC-40BD4B0FE720@cornell.edu>
References: <3A916790-1E8D-4460-90B6-CF92D9F517F5@cornell.edu>
	<835A8D82-5E54-4958-98A0-F7647EA93317@cornell.edu>
	<000001cbbdb4$dab74d40$9025e7c0$@com>
In-Reply-To: <000001cbbdb4$dab74d40$9025e7c0$@com>
Content-Language: en-US
MIME-Version: 1.0
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi Charlie,

On Jan 26, 2011, at 6:57 PM, Charlie X. Liu wrote:
> Have you tried with other distro's, like Ubuntu or SuSE? If they are Ok, you
> may report to RedHat for investigation or as bug report. If the same behave,
> the PC chipset may not be proper or compatible working at 64-bit mode. Then,
> staying with 32-bit, would be Ok for your application?

I have not yet tried with any distributions besides RHEL5.  We will try to look at this a little more when we get a chance.

> BTW, for multi-channel video/frame capturing, Sensoray has Model 811 (
> http://www.sensoray.com/products/811.htm) for your consideration. It uses a
> better capturing chipset (in terms of video/frame capturing quality),
> SAA7135. Four of the SAA7135's are on one Model 811 board, and it supports
> 4-channel capturing simultaneously. Have you noticed it and would like to
> consider or try out?

Thanks!  It looks like we will order a Model 811 for evaluation.  What will we need in modprobe.conf to support the Model 811 in RHEL5?

Thanks again,
Devin


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
