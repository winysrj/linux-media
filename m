Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m57EU63L019631
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 10:30:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m57EThS8015285
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 10:29:43 -0400
Date: Sat, 7 Jun 2008 16:29:23 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Veda N <veda74@gmail.com>
Message-ID: <20080607142923.GA588@daniel.bse>
References: <a5eaedfa0806070650x5daabac2ia12cdee022aa9f9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eaedfa0806070650x5daabac2ia12cdee022aa9f9f@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: pixel sizes
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

On Sat, Jun 07, 2008 at 07:20:36PM +0530, Veda N wrote:
>      Are the sizes of each pixels same for all the sensor?

No

>      Does each sensor
>      have its own size description for each pixel.

Yes
You can find the size of a pixel in the datasheet.

>      I guess each LCDs/Display Units have their own pixel sizes.
>      In which case how the captured pixels are displayed on the LCD?

Depends on the user. Either 1:1 pixelwise or scaled to fit/fill the screen.

>      Should the definitions of pixels (sizes & format) of sensor and
>      display unit match?

No.
Some cameras capture anamorph images to have less data.
And a pixel that is a few micrometer^2 usually represents a bigger area in
reality due to the optics.

>     Do video applications have their own definition of how much size
>     each pixel should have?

No.
Video applications don't care about real world dimensions.
They just want to fill the screen.
They do care about the aspect ratio of the pixels, though.

>    Does the size of the pixel size change if it is RGB or YUV422?

No.
But in YUV422 there is only one chroma sample for two horizontal pixels.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
