Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TI0x9K010880
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:00:59 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TI0kfw031809
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:00:47 -0400
Message-ID: <48B83BF4.2080701@hhs.nl>
Date: Fri, 29 Aug 2008 20:12:04 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <1220029074.1730.8.camel@localhost>
In-Reply-To: <1220029074.1730.8.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] YVYU decoding
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
> Here is a patch for decoding the YVYU frames of the vc0321.
> 

Thanks, I'll apply it, but you are missing YVYU (packed) -> YUV420 (planar) 
conversion, while some apps do default to requesting YUV420 (planar) and as 
your patch claims that libv4lconvert supports YUYV (there is no way to claim 
partial support) those apps will get their request granted.

Any chance you could add YVYU (packed) -> YUV420 (planar) conversion, this 
should be easy, just average the U and V values of one YVYU pack from 2 
adjecent rows, and of course do the packed -> planar conversion. If you cannot 
I can write code for this, can you test it then?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
