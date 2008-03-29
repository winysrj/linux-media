Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2TBIRtK009690
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 07:18:27 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2TBICSo019977
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 07:18:13 -0400
Received: by fg-out-1718.google.com with SMTP id e12so627994fga.7
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 04:18:12 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@infradead.org>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <20080328154302.2dc73781@gaivota> (Mauro Carvalho Chehab's
	message of "Fri, 28 Mar 2008 15:43:02 -0300")
References: <patchbomb.1206312199@liva.fdsoft.se>
	<da854c7e2b4372794c04.1206312205@liva.fdsoft.se>
	<20080328154302.2dc73781@gaivota>
Date: Sat, 29 Mar 2008 12:18:07 +0100
Message-ID: <kr6dtwzgw.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 6 of 6] cx88: Enable color killer by default
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

> Patches 1 to 5 applied, thanks.

Great.

> I don't think it is a good idea to enable the color killer by
> default. This may lead to weird effects, if the stream uses some
> black and white images, with just a few colors, to produce some sort
> of visual effect.

In the scenario you describe the broadcaster will still generate a
color burst (as color information is present) and that is what the
color killer detects. The color killer protects against decoding color
when no color information is present (i.e. no color burst). Most
better quality TV-sets have the functionality and no way to disable
it.

> Better to have this disabled. If someone wants to see a
> black-and-white movie, or is on an area where the color carrier is
> bogus, he can manually enable the filter.

A more probable scenario is that you have a low quality signal source
(a low amplitude color burst) and want to disable the killer to allow
recovery of at least some color. But anyway, the control is there so I
can just enable it in my start-up scripts...

Regards,

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
