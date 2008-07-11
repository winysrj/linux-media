Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BE7S3O002177
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 10:07:28 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6BE7F0P007616
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 10:07:15 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KHJHF-0005Y2-K9
	for video4linux-list@redhat.com; Fri, 11 Jul 2008 16:07:13 +0200
Message-ID: <487768EA.8080200@hhs.nl>
Date: Fri, 11 Jul 2008 16:06:34 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Rainer Koenig <Rainer.Koenig@gmx.de>
References: <200807101924.58802.Rainer.Koenig@gmx.de>
In-Reply-To: <200807101924.58802.Rainer.Koenig@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Flipping the video from webcams
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

Rainer Koenig wrote:
> Hello,
> 
> I've got a notebook with an integrated webcam and I got a driver (r5u870) that 
> works fine with it, except that the camera images I get are all upside down. 
> It seems that due to a desgin flaw the camera was assembled upside down and 
> there is no easy way to turn it. So I need to rotate the picture with 
> software, which practically means "flip X" and "flip Y". I even found some 
> bits in the driver that look like they address this issue, but turning them 
> to "1" (instead of 0) doesn't help at all. 
> 
> So I wonder: Is there a way to flip the picture that is coming from the camera 
> by setting some options somewhere so that my IM client gets the picture in 
> the right orientation?
> 

Most of the time there are some bits in the sensor which will flip the 
pixelscanorder and thus the image, what sensor does your cam use (OV66xx, 
OV73xx, TAS7XX0, ? )

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
