Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46599 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0AZSLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 13:11:34 -0500
Received: by yxe17 with SMTP id 17so3875656yxe.33
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2010 10:11:34 -0800 (PST)
Date: Tue, 26 Jan 2010 16:11:29 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Setting up the exposure time of a webcam
Message-ID: <20100126181129.GA3375@pathfinder.pcs.usp.br>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br> <alpine.LNX.2.00.1001261207540.15431@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1001261207540.15431@banach.math.auburn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the reply, I'll look out for those possible correction
commands... But the adjustment when I cover the lens already happens
in the Linux driver, so I guess it's just something internal, right?

I went back to the original driver to see if I could make the camera
usable again, and I succeeded by turning off the automatic white
balance, and changing the values of the balance by hand. There are
three values for R G and B that can be set from 0 to 127. Can gspca
support something like that? v4lctl doesn't offer anything like that
out of the box, and I couldn't find possible functions in the
code. Does that array in the setwhitebalance function (t613.c) set
these values that the win driver offers the user to set?

thanks,
 
   ++nicolau


On Tue, Jan 26, 2010 at 12:18:01PM -0600, Theodore Kilgore wrote:
>
>
> On Tue, 26 Jan 2010, Nicolau Werneck wrote:
>
>> Hello. I have this very cheap webcam that I sent a patch to support on
>> gspca the other day. The specific driver is the t613.
>>
>> I changed the lens of this camera, and now my images are all too
>> bright, what I believe is due to the much larger aperture of this new
>> lens. So I would like to try setting up a smaller exposure time on the
>> camera (I would like to do that for other reasons too).
>>
>> The problem is there's no "exposure" option to be set when I call
>> programs such as v4lctl. Does that mean there is definitely no way for
>> me to control the exposure time? The hardware itself was not designed
>> to allow me do that? Or is there still a chance I can create some C
>> program that might do it, for example?
>>
>> It looks like the camera has some kind of automatic exposure control. If
>> I cover the lens, and then uncover it quickly, the image is all white
>> at first, and then it gradually becomes darker. Should that give me
>> some hope of being able to control the exposure, or is it common for
>> cheaper cameras to have just an automatic exposure control that cannot
>> be overrun?
>
> Nicolau,
>
> Having had some experience with cheap cameras, I would say that they come 
> with all kinds of variations. Thus, this particular camera (with which I  
> am _not_ experienced) could either have a built-in automatic exposure  
> control, or it could require monitoring from software with periodic  
> correction of various settings. It just depends.
>
> Thus, one thing to do is to look carefully at some usbsnoop logs and try  
> to see if there are occasional correction sequences in between big hunks  
> of data. If there are, then the next thing is to figure out what those  
> correction sequences are doing. Then build those correction sequences 
> into the driver. An example of this kind of thing going on can be seen  
> in lots of the camera drivers in gspca, but not in all of them.
>
> Second thing, try to look for sensor setup commands which give initial  
> settings. If there are such, then one or more of them might control  
> exposure settings.
>
> Third, if there are no occurences of either of the previous items at all, 
> then either the camera does not self-adjust and can not be adjusted (i. 
> e. really, really cheap), or the adjustment mechanism is completely 
> built-in. In that case, I would say that you are probably up a tree about 
> getting the exposure reset.
>
> Hope this helps you.
>
> Theodore Kilgore

-- 
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716

