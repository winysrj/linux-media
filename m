Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58B7Cvb007280
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 07:07:12 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58B71hL030704
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 07:07:01 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1362521fga.7
	for <video4linux-list@redhat.com>; Sun, 08 Jun 2008 04:07:01 -0700 (PDT)
Message-ID: <a5eaedfa0806080407p461e30di1a861a9aa7d240f8@mail.gmail.com>
Date: Sun, 8 Jun 2008 16:37:00 +0530
From: "Veda N" <veda74@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080607142923.GA588@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <a5eaedfa0806070650x5daabac2ia12cdee022aa9f9f@mail.gmail.com>
	<20080607142923.GA588@daniel.bse>
Content-Transfer-Encoding: 8bit
Cc: aniel-gl@gmx.net
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

thank you for quick response.

On Sat, Jun 7, 2008 at 7:59 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Sat, Jun 07, 2008 at 07:20:36PM +0530, Veda N wrote:
>>      Are the sizes of each pixels same for all the sensor?
>
> No
>
>>      Does each sensor
>>      have its own size description for each pixel.
>
> Yes
> You can find the size of a pixel in the datasheet.
>
>>      I guess each LCDs/Display Units have their own pixel sizes.
>>      In which case how the captured pixels are displayed on the LCD?
>
> Depends on the user. Either 1:1 pixelwise or scaled to fit/fill the screen.
>
>>      Should the definitions of pixels (sizes & format) of sensor and
>>      display unit match?
>


Do you mean to say, scaling means just fill up the screen with
whatever pixels you have
it does not matter what thier size are?.

In which case, If the camera sensor pixel sizes is 4 bytes/pixel and
LCD supports only 2 bytes per pixel, Then i can fill up only half the
pixels i have got.

Should this be done line by line or the entire frame wise?


Am i right?


Regards,
vedan


> No.
> Some cameras capture anamorph images to have less data.
> And a pixel that is a few micrometer^2 usually represents a bigger area in
> reality due to the optics.
>
>>     Do video applications have their own definition of how much size
>>     each pixel should have?
>
> No.
> Video applications don't care about real world dimensions.
> They just want to fill the screen.
> They do care about the aspect ratio of the pixels, though.
>
>>    Does the size of the pixel size change if it is RGB or YUV422?
>
> No.
> But in YUV422 there is only one chroma sample for two horizontal pixels.
>
>  Daniel
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
