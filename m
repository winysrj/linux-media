Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33245
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751839AbcLHIVU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 03:21:20 -0500
Date: Thu, 8 Dec 2016 06:21:13 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Regression: tvp5150 refactoring breaks all em28xx devices
Message-ID: <20161208062113.336b5932@vento.lan>
In-Reply-To: <4766252.UD1QfvftzS@avalon>
References: <CAGoCfiz28eu9dT5qXr-qyh6V_-Xm91MkjzE88wtUJsQfLMNCwA@mail.gmail.com>
        <4766252.UD1QfvftzS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Devin,

Em Thu, 08 Dec 2016 00:59:17 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Devin,
> 
> On Wednesday 07 Dec 2016 12:47:01 Devin Heitmueller wrote:
> > Hello Javier, Mauro, Laurent,
> > 
> > I hope all is well with you.  Mauro, Laurent:  you guys going to
> > ELC/Portland in February?  
> 
> I haven't decided for sure yet, but I will likely go.

I haven't decided yet, but probably I won't.

> > Looks like the refactoring done to tvp5150 in January 2016 for
> > s_stream() to support some embedded platform caused breakage in the
> > 30+ em28xx products that also use the chip.  

When I wrote my patch on the top of Laurent's one, I tested it, with both
analog TV and composite input, and didn't notice any issue. I used a
WinTV USB2 and HVR-950.

I didn't test with progressive video input though, as I'm using a PVR-350
TV out to generate signals, with, AFIKT, generates only interlaced video.

Unfortunately, analog TV signal broadcast ended last month, and I don't
have any analog TV RF generator. I might still have an old VCR with a
RF output, but need to check if it is on my garage.

> 
> I assume you're talking about
> 
> commit 460b6c0831cb52ef349156cfa27e889606b4cb75
> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date:   Thu Jan 7 10:46:45 2016 -0200
> 
>     [media] tvp5150: Add s_stream subdev operation support
> 
> followed by
> 
> commit 47de9bf8931e6bf9c92fdba9867925d1ce482ab1
> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:   Mon Jan 25 14:39:34 2016 -0200
> 
>     [media] tvp5150: Fix breakage for serial usage
> 
> both introduced in v4.6. I further assume that "serial" means BT.656 here, 
> which is still parallel.
> 
> > Problem confirmed on both the Startech SVIDUSB2 board Steve Preston
> > was nice enough to ship me (after adding a board profile), as well as
> > on my original HVR-950 which has worked fine since 2008.
> > 
> > The implementation tramples the TVP5150_MISC_CTL register, blowing
> > into it a hard-coded value based on one of two scenarios, neither of
> > which matches what is expected by em28xx devices.  At least in the
> > case of NTSC, this results in chroma cycling.  This was also reported
> > by Alexandre-Xavier Labonté-Lamoureux back in August, although in the
> > video below he's also having some other issue related to progressive
> > video because he's using an old gaming console as the source (i.e. pay
> > attention to the chroma effects in the top half of the video rather
> > than the fact that only the first field is being rendered).
> > 
> > https://youtu.be/WLlqJ7T3y4g
> > 
> > The s_stream implementation writes 0x09 or 0x0d into TVP5150_MISC_CTL
> > (overriding whatever was written by tvp5150_init_default and
> > tvp5150_selmux().  In fact, just as a test I was able to start up
> > video, see the corruption, and write the correct value back into the
> > register via v4l2-dbg in order to get it working again:
> > 
> > sudo v4l2-dbg --chip=subdev0 --set-register=0x03 0x6f
> > 
> > There's no easy fix for this without extending the driver to support
> > proper configuration of the output pin muxing, which it isn't clear to
> > me what the right approach is and I don't have the embedded hardware
> > platform that prompted the refactoring in order to do regression
> > testing anyway.
> > 
> > Feel free to take it upon yourselves to fix the regression you introduced.  
> 
> I've had a quick look at the code from the point of view opposite from yours, 
> with my knowledge of the embedded side but without any experience with em28xx. 
> I don't think that adding proper configuration of pinmuxing would be that 
> hard, if it wasn't for the tvp5150_reset() function. The function is called 
> directly in the get and set format handlers, and through subdev core 
> operations.
> 
> The way we expose and use the reset operation is a very surprising (to stay 
> politically correct) idea, but in the context of em28xx shouldn't be too much 
> of a problem as the operation is only invoked at stream on time, before 
> s_stream(1). However, calling it from the get and set format handlers can only 
> lead me to conclude that the kernel is missing an ENOBRAIN error code. I'll 
> blame it on history.
> 
> As a prerequisite to implement proper output mixing configuration, the 
> tvp5150_reset() call needs to be removed from tvp5150_fill_fmt(). 

That shouldn't affect anything. The .set_fmt() callback is only called by
drivers/media/v4l2-core/v4l2-subdev.c. As those devices don't use
subdevs, removing tvp5150_reset() from tvp5150_fill_fmt() shouldn't
affect anything.

> I can't test 
> that with the em28xx driver as I don't have access to any such device. Devin, 
> would you be able to assist with testing on em28xx by removing the function 
> call from a working kernel (v4.5 would be ideal) and check if the device still 
> operates correctly ? I believe it would, given that the reset operation is 
> called at stream on time as well as explained above, and that call would still 
> be there.
> 
> The tvp5150_reset() call in tvp5150_fill_fmt() was added by
> 
> commit ec2c4f3f93cb9ae2b09b8e942dd75ad3bdf23c9d
> Author: Javier Martin <javier.martin@vista-silicon.com>
> Date:   Thu Jan 5 10:57:39 2012 -0300
> 
>     [media] media: tvp5150: Add mbus_fmt callbacks
>     
>     These callbacks allow a host video driver
>     to poll video formats supported by tvp5150.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> I assume the call was originally intended to put the device in a known state 
> for a following call to tvp5150_read_std() in the same function. Given that 
> that code got removed in the meantime, I don't see any need to reset the chip 
> there. 
> 
> I'm not sure who added the code, as the commit is authored by Javier by only 
> signed by Mauro. Could any (or both) of you shed some light on that ?

Such patch is authored by Javier. He probably forgot to sign it.

Javier should explain it more, but I guess it is meant to switch between
NTSC and PAL.

> 
> Mauro, as you've already attempted (unfortunately unsuccessfully) to fix this 
> problem in 47de9bf8931e6bf9c92fdba9867925d1ce482ab1, do you plan to give it 
> another try ? Now that I've performed an initial analysis and set the 
> direction, this should be easy, right ? :-)

The way it is, it worked on my past test scenarios. As I explained before, 
testing right now is more complex, as I lack progressive video output and
analog TV RF output.

I could try to setup an environment to test it, but it could take some
time to find the needed gadgets.
 
Thanks,
Mauro
