Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83CZGwt018746
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 08:35:17 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m83CZ4De007884
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 08:35:04 -0400
Message-ID: <48BE8739.3050003@hhs.nl>
Date: Wed, 03 Sep 2008 14:46:49 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <1220256268.1753.17.camel@localhost>
In-Reply-To: <1220256268.1753.17.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] v4l library YVYU decoding
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

Jean-Francois Moine wrote:
> Hi Hans,
> 
> Here is a new YVYU decoding patch which replaces the previous one.
> 
> Sorry for it is not tested: the webcam 046d:0896 does not work well.
> 

Thanks,

I've found a cam which does YUYV and used your patch to add YUYV support as 
well, that seems to work well so I guess YVYU will work well too.

This support is in the just released 0.4.3 release (I must still send the 
announcement).

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
