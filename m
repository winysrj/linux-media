Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71JropI015542
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 15:53:51 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m71JrbU7013313
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 15:53:38 -0400
Message-ID: <48936BD4.20905@hhs.nl>
Date: Fri, 01 Aug 2008 22:02:28 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <1217614143.1686.12.camel@localhost>
In-Reply-To: <1217614143.1686.12.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] libv4l decoding to rgb24
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
> The RGB24 pixel format is often used in X11 applications.
> This patch adds it to the V4L library.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> 

Thanks, the yuv part of the patch is not correct as u and v have different 
weight factors in the conversion so simply swapping them is not correct, but 
I'll fix that myself.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
