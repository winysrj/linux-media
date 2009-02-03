Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:33473 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZBCSKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 13:10:03 -0500
Date: Tue, 3 Feb 2009 12:21:55 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
Message-ID: <alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <200901272101.27451.linux@baker-net.org.uk> <alpine.LNX.2.00.0901271543560.21122@banach.math.auburn.edu> <200901272228.42610.linux@baker-net.org.uk> <20090128113540.25536301@free.fr>
 <alpine.LNX.2.00.0901281554500.22748@banach.math.auburn.edu> <20090131203650.36369153@free.fr> <alpine.LNX.2.00.0902022032230.1080@banach.math.auburn.edu> <20090203103925.25703074@free.fr> <alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Feb 2009, kilgota@banach.math.auburn.edu wrote:

>
>
> On Tue, 3 Feb 2009, Jean-Francois Moine wrote:
>
>> On Mon, 2 Feb 2009 20:36:31 -0600 (CST)
>> kilgota@banach.math.auburn.edu wrote:
>>> Just now when I logged in, a fortune came up which says:
>>> 
>>> "A little experience often upsets a lot of theory."
>>> 
>>> It struck me funny after our recent experiences, so I thought I would
>>> share it with both of you.
>> 
>> Hello,
>> 
>> May be this message made me to look again at the gspca code. Well, it's
>> my fault: I did not check the previous patch. Sorry for all trouble.
>> 
>> The patch is simply:
>> 
>> diff -r 3f4a7bc53d8e linux/drivers/media/video/gspca/gspca.c
>> --- a/linux/drivers/media/video/gspca/gspca.c	Mon Feb 02 20:25:38 2009 
>> +0100
>> +++ b/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 10:37:51 2009 
>> +0100
>> @@ -435,7 +435,7 @@
>> 			break;
>>
>> 		gspca_dev->urb[i] = NULL;
>> -		if (!gspca_dev->present)
>> +		if (gspca_dev->present)
>> 			usb_kill_urb(urb);
>> 		if (urb->transfer_buffer != NULL)
>> 			usb_buffer_free(gspca_dev->dev,
>> 
>
> Well, OK. But this will solve the problem which comes from disconnect while 
> streaming? Sure, I will try this and see if it does the job or not. But 
> whatever the outcome of that might be, I do not follow the logic.
>
> Theodore Kilgore

I should add to the above that now I have tested, and indeed this change 
does not solve the problem of kernel oops after disconnect while 
streaming. It does make one change. The xterm does not go wild with error 
messages. But it is still not possible to close the svv window. Moreover, 
ps ax reveals that [svv] is running as an unkillable process, with 
[sq905/0] and [sq905/1], equally unkillable, in supporting roles. And 
dmesg reveals an oops. The problem is after all notorious by now, so I do 
not see much need for yet another log of debug output unless specifically 
asked for such.

Perhaps we also need to do what Adam suggested yesterday, and add a call 
to destroy_urbs() in gspca_disconnect()? That really did appear to cure 
the problem. But the way I did it is

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

and it would appear that with your changes above it would work better to 
do here first

         destroy_urbs(gspca_dev);

and then only after that

         gspca_dev->present = 0;

Or?

Theodore Kilgore
