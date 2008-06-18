Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5IFFHt5013388
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 11:15:17 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5IFF5wM026988
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 11:15:06 -0400
Received: by fg-out-1718.google.com with SMTP id e21so188877fga.7
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 08:15:05 -0700 (PDT)
Message-ID: <a5eaedfa0806180815t6172ad0qf7fa6ccb764c20c0@mail.gmail.com>
Date: Wed, 18 Jun 2008 20:45:05 +0530
From: "Veda N" <veda74@gmail.com>
To: "Veda N" <veda74@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <20080617172433.GA227@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
	<a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
	<20080617094510.GA726@daniel.bse>
	<a5eaedfa0806170322v382f5b98o22f2b94830585f7c@mail.gmail.com>
	<20080617104614.GA781@daniel.bse>
	<a5eaedfa0806170815m2911f480lbed9b4fc18622b09@mail.gmail.com>
	<20080617172433.GA227@daniel.bse>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: v4l2_pix_format doubts
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

Hi,
Thank you for your response.

Does this value depend on any way of bpp (bits per pixel?)

If so, how?

-- 
Regards,
N. S. Veda




On Tue, Jun 17, 2008 at 10:54 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Tue, Jun 17, 2008 at 08:45:21PM +0530, Veda N wrote:
>>  1) I am having a pixel format (UYVY)
>>  2) RGB565
>
> In both cases
> bytesperline=2*width;
> (minimum)
>
>  Daniel
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
