Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:35998 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZHDF3v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 01:29:51 -0400
Date: Tue, 4 Aug 2009 00:45:27 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
In-Reply-To: <alpine.LRH.2.00.0908031835500.25203@pedra.chehab.org>
Message-ID: <alpine.LNX.2.00.0908040004460.20530@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr> <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu> <20090802103350.19657a07@tele> <alpine.LNX.2.00.0908021302390.29819@banach.math.auburn.edu> <20090803103954.7150909e@tele>
 <alpine.LNX.2.00.0908031009250.19964@banach.math.auburn.edu> <20090803142614.45015b5a@pedra.chehab.org> <alpine.LNX.2.00.0908031316560.20129@banach.math.auburn.edu> <alpine.LRH.2.00.0908031835500.25203@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 3 Aug 2009, Mauro Carvalho Chehab wrote:

> On Mon, 3 Aug 2009, Theodore Kilgore wrote:

<snip>

>>>  static const __devinitdata struct usb_device_id device_table[] = {
>>>         {USB_DEVICE(0x2770, 0x905c), .driver_info =
>>>         SAKAR_MICRO_DIGITAL_2428X},
>>>         {USB_DEVICE(0x2770, 0x9050), .driver_info = DISNEY_PIX_MICRO},
>>>   {USB_DEVICE(0x2770, 0x9052), .driver_info = DISNEY_PIX_MICRO2},
>>>         {USB_DEVICE(0x2770, 0x913d), .driver_info =
>>>         SUPREMA_DIGITAL_KEYCHAIN_CAMERA},
>>>          {}
>>>  };

Incidentally, the above was only a small snippet from the list given in 
libgphoto2/camlibs/digigr8/library.c. The entire list is quite a bit 
longer. As I mentioned in a post yesterday, there are seventeen entries in 
all. That seventeen is a sample of the numbers that one often has to deal 
with. The reason I say that the entire list ought to be available and 
publicized somehow is that people simply would not know that these 
seventeen cameras are all supported in webcam mode (and by the same driver 
module, too!) unless someone informs them.


OK, so here was your first suggestion:

>>>
>>>  struct camera_description {
>>>   char *name;
>>>   unsigned int flags;
>>>  };
>>>
>>>  static struct camera_description cameras[] = {
>>>   [SAKAR_MICRO_DIGITAL_2428X] = {
>>>    .name = "Sakar Micro Digital 2428x/Jazz JDC9",
>>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>>   },
>>>   [DISNEY_PIX_MICRO] = {
>>>    .name = "Disney pix micro",
>>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>>   },
>>>   [DISNEY_PIX_MICRO2] = {
>>>    .name = "Disney pix micro 2",
>>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>>   },
>>>   [SUPREMA_DIGITAL_KEYCHAIN_CAMERA] = {
>>>    .name = "Suprema Digital Keychain Camera",
>>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>>  	},
>>>  };
>>>
>>>  The association between the two tables can easily be done at the .config
>>>  ops:
>>>
>>>  /* this function is called at probe time */
>>>  static int sd_config(struct gspca_dev *gspca_dev,
>>>                         const struct usb_device_id *id)
>>>  {
>>>
>>>  ...
>>>   int board_nr = id->driver_info;
>>>
>>>   printf(KERN_WARN "Detected camera %s\n", cameras[board_nr]);

Incidentally, if two cameras have the same USB ID _and_ are otherwise 
functionally identical (these are not necessarily the same thing) then I 
think the physical camera will not always be the same as the detected 
camera. So, while it is always nice to have debug messages, that is not 
otherwise solving very much.

>>>
>>>  ...
>>>  }
>>>
>>>  A small change at cx88.pl will be enough to auto-generate gspca.txt.
>> 
>> Mauro, this is impressive. First, you point out that Gphoto could have done 
>> the job more efficiently, and it seems to me that you are right. Then you 
>> point out that to make such a change would break compatibility with the 
>> Linux kernel's struct usb_device_id so it cannot be done that way. Then you 
>> provide a workaround. It is very clever.
>
> This kind of trick is used already on several other drivers: cx88, bttv, 
> em28xx, usbvision, saa7134, ...
>
>> However, another side of me says that all of this workaround would have to 
>> get compiled into the code for every gspca driver, making the code for each 
>> driver, and the resulting binary output, too, in turn longer and more 
>> complicated.
>
> Longer: yes. It will generate a longer data segment with the names of all 
> supported webcams.


Could it be that some people who are writing code for RTS systems and 
small single-purpose systems might scream about unnecessary bloat?

>
> However, This won't increase the complextiy of the driver. As I showed, you 
> can know what device you have by just looking at id.driver_info. Also, as 
> this standard on other drivers, you aren't adding any uncommon weird 
> behavior.
>
> Yet, this change would be a big patch, since several drivers already use 
> device_info for something else. The patch would be trivial though, since we 
> just need to move the current driver_info information to something inside the 
> webcam struct.

This looks to me like an excellent opportunity to get everyone tied in 
knots at the same time. Gee. That sounds like fun. Perhaps we could get 
"the guy" to do it :) ?

>
>> Therefore, the excursion ends up convincing me that in the first place the 
>> documentation about which devices are supported, listed by trade name as 
>> well as USB ID, really ought to be in some kind of place like gspca.txt. It 
>> is after all much easier to edit a text file than it is to write code, and 
>> the contents of the text file do not contribute to the growth of size of 
>> the resulting binary. And it would be at least as easy, at least from this 
>> point forward, to place the responsibility on the author/maintainer of a 
>> gspca_* module to provide such a list as part of the procedure for 
>> submitting code and patches. Then a perl script could, for example, parse 
>> that one file and put the entries into alphabetical order, or any other 
>> reasonable and desired order.
>
> This will only work fine if there are some sanity check script to validate if 
> all USB ID's are present at gspca.txt. Otherwise, we'll always have the risk 
> of not having it properly updated.

The solution for that is simple. From this day on, anybody who adds a new 
device to any gspca driver provides the entry for gspca.txt or else the 
patch is not accepted without suitable revision. Just, first, it has to be 
decided what kind of thing goes in that file. What is missing is a policy 
and a clear-cut guideline.

>
> There is another alternative: add a comment before each new board at gspca's 
> USB ID's entries. Something like:
>
> static const __devinitdata struct usb_device_id device_table[] = {
> 	/* Webcam: Sakar Micro Digital 2428x / Jazz JDC9 */
> 	{USB_DEVICE(0x2770, 0x905c)},
> 	/* Webcam: Disney pix micro */
> 	{USB_DEVICE(0x2770, 0x9050)},
> 	/* Webcam: Suprema Digital Keychain Camera */
> 	{USB_DEVICE(0x2770, 0x913d)},
> 	{}
> };
>
> This could be easily parseable by a script that would generate the gspca.txt.

Yes. Existing documentation tools certainly can do something like that, 
and in fact already do, on fairly routine basis.

I don't know about you, but I like this much better. It is simpler, 
does not screw with the code, and is in plain text.

But, alas, it still does not resolve the question of exactly what should 
go into gspca.txt, and what format that ought to have.

> Also, the patch for it can be generated by some script.

What I said already. A clear-cut policy and a clear-cut procedure and a 
clear-cut format for the information to go into gspca.txt (or somewhere 
else, if that is more appropriate) are what is missing. The job has to get 
done. Very nice if it is done by a script, too, but that seems to me to be 
quite secondary. Also, to rely totally on a script might make upset anyone 
who has been a "good citizen" and has already listed his/her device in 
gspca.txt in a manner which is acceptable, but now gets asked to put the 
information in a comment in the source file instead.


Theodore Kilgore
