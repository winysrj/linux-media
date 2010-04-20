Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o3K97ZJR005795
	for <video4linux-list@redhat.com>; Tue, 20 Apr 2010 05:07:35 -0400
Received: from gateway.tuioptics.com (gateway.tuioptics.com [213.183.22.85])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3K97II0010826
	for <video4linux-list@redhat.com>; Tue, 20 Apr 2010 05:07:20 -0400
Date: Tue, 20 Apr 2010 11:05:17 +0200
From: Arno Euteneuer <arno.euteneuer@toptica.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <4BCD6E4D.2060708@toptica.com>
In-Reply-To: <Pine.LNX.4.64.1003100849200.4618@axis700.grange>
References: <4B960AE2.3090803@toptica.com>
References: <4B974A71.5030506@toptica.com>
References: <Pine.LNX.4.64.1003100849200.4618@axis700.grange>
Subject: Re: soc-camera driver for i.MX25
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

>>> More
>>> importantly, it certainly has to be updated for 2.6.32 and 2.6.33 - the
>>> biggest change since 2.6.31 has been the conversion to the v4l2-subdev
>>> API, and a smaller one - the addition of the mediabus API.
>> I already suspected that I have to update it :D Currently I'm using a 2.6.31
>> kernel that has been patched with a BSP from the board supplier. So, I have to
>> first update these patches in order to be able to run my system with a current
>> kernel,I guess. I will try that ...
>
> Good, looking forward to an updated patch;)

It seems that I will not find the time for preparing my driver for a newer 
kernel in the near future :( I started upgrading the BSP of my board a few weeks 
ago, but was interrupted by urgent work on several other things. I will now have 
to use my driver rather than updating and improving it. Sorry. But I'm sure I 
will have to update it sooner or later and will hopefully come back then ;)

Regards,
Arno

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
