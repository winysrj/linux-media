Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7LHFxHP023681
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 13:15:59 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7LHFnqg002046
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 13:15:49 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
In-Reply-To: <48AD72D5.4050408@hhs.nl>
References: <48A8698E.3090004@hhs.nl> <1219304978.1762.25.camel@localhost>
	<48AD72D5.4050408@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 21 Aug 2008 18:58:57 +0200
Message-Id: <1219337937.1726.39.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: PATCH: gspca-spc200nc-upside-down-v2
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

On Thu, 2008-08-21 at 15:51 +0200, Hans de Goede wrote:
> Jean-Francois Moine wrote:
	[snip]
> > Well, I looked at various messages in various mail-lists talking about
> > upside down. Sometimes, a webcam may be normal or upside down, or even
> > just mirrored. Two times only (Vimicro 0325 and 0326), they say that the
> > webcam is always upside down. So, is it useful to make a generic code
> > for this specific case?
> 
> Yes, as that will make these webcam work out of the box for end users. Please 
> stop thinking as a developer for a moment and start thinking as a simple end 
> user plugging such a cam into his asus eee pc, which is his first and only 
> linux machine. What do you think he will like better, the upside down picture 
> or the hey cool I plug in in this cam and it just works (tm) ?

It is possible if some system application (hal?) does the job.

> > For the general case (the webcam may have H or V flip, or both - upside
> > down). The user will see it. If she may use the HFLIP and VFLIP
> > controls, she will get a correct image.
> 
> Currently the 4 major (as in more then just a gimmick) end user v4l wewbcam 
> programs I'm aware of are:
> ekiga
> cheese
> flash plugin
> skype
> 
> And AFAIK (didn't check skype) non of these offer a simple GUI option for the 
> user to change vflip / hflip controls. Telling a user to go the cmdline is not 
> *userfriendly* and in this scenario is not necessary!

You did not try v4l2ucp?

	[snip]
> The reason why I'm spending tons of time on all this webcam stuff, is so that 
> end users can just plugin their cam and have it work. If that requires a 
> special flag for just these 2 cams so be it and I strongly believe we will 
> encounter other cams like this in the future.
	[snip]

Sorry, but I am not happy the way it is done. Here is an other proposal.

In the V4L2 spec, VIDIOC_QUERYCTRL returns the controls accepted (or
rejected) by the driver, and also information about these ones. As the
Vimicro/Z-star has no way to change H and V flips, the driver may give
these controls as READ_ONLY and set the control values according to the
device type.

Now, when accessing the device, the V4L library will get the flags and
values of the H and V flip. If HFLIP and VFLIP are settable, the driver
does all the job. If not (HFLIP and VFLIP are READ_ONLY or INVAL), the
library memorizes the control values of the driver (INVAL implies 0) and
also the values asked by the application. Frame decoding is then H
and/or H flipped according to (<driver value> ^ <user value>).

And now, for something completely different! I could not find a MS-win
snoop of these 'upside down' devices (0471:0325 and 0471:0326). I want
to check the initialization sequences and also the format of the frames.
May anybody send one to me? Thank you.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
