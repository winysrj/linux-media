Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:58147 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2CGPas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 10:30:48 -0500
Date: Wed, 7 Mar 2012 16:32:24 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Xavion <xavion.0@gmail.com>, Hans de Goede <hdegoede@redhat.com>
Cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux
 anymore
Message-ID: <20120307163224.412b4d2f@tele>
In-Reply-To: <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
	<CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
	<4F51CCC1.8020308@redhat.com>
	<CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
	<20120304082531.1307a9ed@tele>
	<CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
	<20120305182736.563df8b4@tele>
	<CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
	<4F55DB8B.8050907@redhat.com>
	<CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 7 Mar 2012 09:59:28 +1100
Xavion <xavion.0@gmail.com> wrote:

> >>     root@Desktop /etc/motion # tail /var/log/kernel.log
> >>     Mar  6 08:34:17 Desktop kernel: [ 7240.125167] gspca_main: ISOC
> >> data error: [0] len=0, status=-18
> >>    ...  
> >
> > Hmm, error -18 is EXDEV, which according to
> > Documentation/usb/error-codes.txt is:
> >
> > -EXDEV                  ISO transfer only partially completed
> >                        (only set in iso_frame_desc[n].status, not
> > urb->status)
> >
> > I've seen those before, and I think we should simply ignore them rather then
> > log an error for them. Jean-Francois, what do you think?  
> 
> I'll let you guys decide what to do about this, but remember that I'm
> here to help if you need more testing done.  If you want my opinion,
> I'd be leaning towards trying to prevent any errors that appear
> regularly.

Hi,

It seems that the webcams handled by the driver sn9c20x work the same
as the ones handled by sonixj. In this last driver, I adjust the JPEG
compression to avoid the errors "USB FIFO full", and I think that these
errors also raise the URB error -18 with the sn9c20x. I will need some
time to put a same code into the sn9c20x, then I'd be glad to have it
tested.

There was an other problem in the driver sonixj: the end of frame
marker was not always at the right place. Xavion, as you have
ms-windows, may you do some USB traces with this system? I need a
capture sequence of about 15 seconds (not more) with big luminosity
changes.

> This isn't even the proper SXGA resolution, which is supposed to be
> 1280x1024.  The Sonix website claims that their SN9C201 webcam can
> provide up to a 1.3 MP (SXGA) video size!  Do you happen to know of
> any inexpensive webcams that are capable of true SXGA in Linux?
> 
>     `--> lsusb | grep Cam
>     Bus 001 Device 006: ID 0c45:627b Microdia PC Camera (SN9C201 + OV7660)

The sensor ov7660 can do VGA only (640x480).

Otherwise, I uploaded a new gspca test version (2.15.3) with the JPEG compression control (default 80%). May you try it?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
