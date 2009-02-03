Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57939 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZBCATY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 19:19:24 -0500
Date: Mon, 2 Feb 2009 18:31:17 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Alan Stern <stern@rowland.harvard.edu>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: Bug in gspca USB webcam driver
In-Reply-To: <200902022328.44386.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902021808350.872@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.0902021651460.13005-100000@iolanthe.rowland.org> <200902022328.44386.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 2 Feb 2009, Adam Baker wrote:

> On Monday 02 February 2009, Alan Stern wrote:
>> On Mon, 2 Feb 2009, Adam Baker wrote:
> <snip>
>>>> To summarize: Unplugging the camera while it is in use by a program
>>>> causes an oops (particularly on an SMP machine).
>>>>
>>>> The problem is that gspca_stream_off() calls destroy_urbs(), which in
>>>> turn calls usb_buffer_free() -- but this happens too late, after
>>>> gspca_disconnect() has returned.  By that time gspca_dev->dev is a
>>>> stale pointer, so it shouldn't be passed to usb_buffer_free().
>>>
>>> By my reading it should be OK for gspca_disconnect to have returned as
>>> long as video_unregister_device waits for the last close to complete
>>> before calling gspca_release. I know that there were some patches a while
>>> back that attempted to ensure that was the case so I suspect there is
>>> still a hole there.
>>
>> gspca_disconnect() should _not_ wait for the last close.  It should do
>> what it needs to do and return as quickly as possible.  This means
>> there must be two paths for releasing USB resources: release upon last
>> close and release upon disconnect.
>>
>
> I was being slightly imprecise in saying it waits, it uses the
> device_register / unregister mechanism so it does effectively set a flag that
> results in the release being called on last close. video_unregister_device
> does use a mutex while updating some internal flags but as far as I can tell
> the USB subsystem won't call gspca_disconnect in interrupt context so that
> should be OK.
>
> What I hadn't noticed before is that usb_buffer_free needs the usb device
> pointer and as you say that is no longer valid after gspca_disconnect returns
> even if gspca_release hasn't freed the rest of the gspca struct. If that is
> the problem then I presume the correct behaviour is for gspca_disconnect to
> ensure that all URBs are killed and freed before gspca_disconnect returns.
> This shouldn't be a problem for sq905 (which doesn't use these URBs) or
> isochronous cameras (which don't need to resubmit URBs) but the finepix
> driver (the other supported bulk device) will need some careful consideration
> to avoid a race between killing the URB and resubmitting it.
>
> Theodore, could you check if adding a call to destroy_urbs() in
> gspca_disconnect fixes the crash. (destroy_urbs only frees non NULL urb
> pointers so should be safe to call from both disconnect and stream_off,
> whichever occurs first).

Yes, this seems to help a great deal. I have tried it at this point on 
both machines. Now we have

void gspca_disconnect(struct usb_interface *intf)
{
         struct gspca_dev *gspca_dev = usb_get_intfdata(intf);

         gspca_dev->present = 0;
         destroy_urbs(gspca_dev);

         usb_set_intfdata(intf, NULL);

         /* release the device */
         /* (this will call gspca_release() immediatly or on last close) */
         video_unregister_device(&gspca_dev->vdev);

         PDEBUG(D_PROBE, "disconnect complete");
}

and the results are as follows:

The Pentium 4 Dual Core:
 	No visible problems, no error messages. I pulled the cord and then 
in a very leisurely way killed the window. New on this machine and the 
other one, too, is the very desirable side effect that svv can be killed 
by clicking the x on the window which used not to work! Then dmesg 
(with gspca_main in debug mode, too) has many times gspca:dqbuf (obvious: 
I had not yet closed the window). After that come, in the order that they 
are listed,

kill transfer
stream off OK
svv close
frame free
close done
device released

(all of these preceded by "gspca:")

So this all looks very nice.

The Athlon K8 dual core:

Not so excellent, but still not bad. The experiment has been simiilarly 
conducted, as before. The output of dmesg says pretty much the same thing. 
The difference is, lots of repetitions of an error message in the 
xterm which says

libv4l2: error dequeuing buf: Resource temporarily unavailable

This could of course result from libv4l2 and not from the modules. I feel 
pretty sure that I am not running the same version on both machines. The 
one on the Pentium 4 is quite likely to be newer than what is on the 
Athlon box.

It seems to me that with this we are much better on the way.

Theodore Kilgore
