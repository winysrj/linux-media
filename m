Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GFKXcQ016231
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 11:20:33 -0400
Received: from stockholm.opq.se ([62.209.160.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GFKKNP018917
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 11:20:21 -0400
Received: from acme.pacific (acme.pacific [192.30.105.200])
	by stockholm.opq.se (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id
	m4GEZg3e001576
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 16:35:44 +0200
From: Roger Oberholtzer <roger@opq.se>
To: video4linux-list@redhat.com
In-Reply-To: <a5eaedfa0805160656t29d2858ao3c1c81469b87b0af@mail.gmail.com>
References: <a5eaedfa0805160656t29d2858ao3c1c81469b87b0af@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 May 2008 16:35:42 +0200
Message-Id: <1210948542.18713.45.camel@acme.pacific>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pixel count doubts
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

On Fri, 2008-05-16 at 19:26 +0530, Veda N wrote:
> Hi,
> I am trying to write a camera sensor driver.
> 
> The sensor documents says that -
> For the resolution VGA, The pixel count is 640x480x3.
> 
> I did not understand what is meant by x3 in pixel count.
> 
> Usually it is 60x480. The number of bytes per pixel is 2.
> 
> Does this mean that instead of 2 bytes per pixel. it is 3 bytes?

Just guessing, as I do not know the exact context, but I am guessing it
is RGB VGA, in which you are probably correct: a byte each for RGB.

> 
> 
> How should i account this pixel count in my driver.
> How much should be  bytesperline and sizeimage
> How should i account this in my application as well.

First decide if your images are RGB. Maybe they are 8-bit? Or maybe
there is an alpha channel? It is up to your application. All are
possible and valid. That is what makes all this so much fun.

> 
> Regards,
> vedan
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
-- 
Roger Oberholtzer

OPQ Systems / Ramböll RST

Ramböll Sverige AB
Kapellgränd 7
P.O. Box 4205
SE-102 65 Stockholm, Sweden

Office: Int +46 8-615 60 20
Mobile: Int +46 70-815 1696

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
