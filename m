Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n158b7YI025644
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 03:37:07 -0500
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n158apkq030526
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 03:36:52 -0500
Message-ID: <498AA511.1030803@maxwell.research.nokia.com>
Date: Thu, 05 Feb 2009 10:36:33 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: halli manjunatha <hallimanju@gmail.com>
References: <ca6476860902040437h710ab4echd5e837502ce796d3@mail.gmail.com>
In-Reply-To: <ca6476860902040437h710ab4echd5e837502ce796d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Missing first 4 frames
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

halli manjunatha wrote:
> Hi ,
>        I am working on omap3 custom board and using the TI's camera patches
> on 2.6.28 kernel  and the problem is that first 4 frames are coming 1/4 of
> HVGA but i am capturing HVGA  images. after 4 frames everything is normal.

I would start looking the problem from the sensor side first, unless you 
already have done it. I haven't seen anything like this not depending on 
sensor on OMAP 3 ISP.

If this is happening only with newer version of drivers then my guess is 
that it's because there was a change that reverted the order in which 
the ISP and sensor were started. Earlier the sensor was started first, 
now it's the ISP (which is generally correct).

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
