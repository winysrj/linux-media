Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZHCWA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 18:00:56 -0400
Date: Mon, 3 Aug 2009 18:59:55 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
In-Reply-To: <alpine.LNX.2.00.0908031316560.20129@banach.math.auburn.edu>
Message-ID: <alpine.LRH.2.00.0908031835500.25203@pedra.chehab.org>
References: <20090418183124.1c9160e3@free.fr> <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu> <20090802103350.19657a07@tele> <alpine.LNX.2.00.0908021302390.29819@banach.math.auburn.edu> <20090803103954.7150909e@tele>
 <alpine.LNX.2.00.0908031009250.19964@banach.math.auburn.edu> <20090803142614.45015b5a@pedra.chehab.org> <alpine.LNX.2.00.0908031316560.20129@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 Aug 2009, Theodore Kilgore wrote:

>>
>>  enum {
>>   SAKAR_MICRO_DIGITAL_2428X,
>>   DISNEY_PIX_MICRO,
>>   DISNEY_PIX_MICRO2,
>>   SUPREMA_DIGITAL_KEYCHAIN_CAMERA,
>>  };
>>
>>  static const __devinitdata struct usb_device_id device_table[] = {
>>         {USB_DEVICE(0x2770, 0x905c), .driver_info =
>>         SAKAR_MICRO_DIGITAL_2428X},
>>         {USB_DEVICE(0x2770, 0x9050), .driver_info = DISNEY_PIX_MICRO},
>>   {USB_DEVICE(0x2770, 0x9052), .driver_info = DISNEY_PIX_MICRO2},
>>         {USB_DEVICE(0x2770, 0x913d), .driver_info =
>>         SUPREMA_DIGITAL_KEYCHAIN_CAMERA},
>>          {}
>>  };
>>
>>  struct camera_description {
>>   char *name;
>>   unsigned int flags;
>>  };
>>
>>  static struct camera_description cameras[] = {
>>   [SAKAR_MICRO_DIGITAL_2428X] = {
>>    .name = "Sakar Micro Digital 2428x/Jazz JDC9",
>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>   },
>>   [DISNEY_PIX_MICRO] = {
>>    .name = "Disney pix micro",
>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>   },
>>   [DISNEY_PIX_MICRO2] = {
>>    .name = "Disney pix micro 2",
>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>   },
>>   [SUPREMA_DIGITAL_KEYCHAIN_CAMERA] = {
>>    .name = "Suprema Digital Keychain Camera",
>>    .flags = GP_DRIVER_STATUS_EXPERIMENTAL,
>>  	},
>>  };
>>
>>  The association between the two tables can easily be done at the .config
>>  ops:
>>
>>  /* this function is called at probe time */
>>  static int sd_config(struct gspca_dev *gspca_dev,
>>                         const struct usb_device_id *id)
>>  {
>>
>>  ...
>>   int board_nr = id->driver_info;
>>
>>   printf(KERN_WARN "Detected camera %s\n", cameras[board_nr]);
>>
>>  ...
>>  }
>>
>>  A small change at cx88.pl will be enough to auto-generate gspca.txt.
>
> Mauro, this is impressive. First, you point out that Gphoto could have done 
> the job more efficiently, and it seems to me that you are right. Then you 
> point out that to make such a change would break compatibility with the Linux 
> kernel's struct usb_device_id so it cannot be done that way. Then you provide 
> a workaround. It is very clever.

This kind of trick is used already on several other drivers: cx88, bttv, 
em28xx, usbvision, saa7134, ...

> However, another side of me says that all of this workaround would have to 
> get compiled into the code for every gspca driver, making the code for each 
> driver, and the resulting binary output, too, in turn longer and more 
> complicated.

Longer: yes. It will generate a longer data segment with the names of all 
supported webcams.

However, This won't increase the complextiy of the driver. As I showed, 
you can know what device you have by just looking at id.driver_info. Also, 
as this standard on other drivers, you aren't adding any uncommon weird 
behavior.

Yet, this change would be a big patch, since several drivers already use 
device_info for something else. The patch would be trivial though, since 
we just need to move the current driver_info information to something 
inside the webcam struct.

> Therefore, the excursion ends up convincing me that in the first 
> place the documentation about which devices are supported, listed by trade 
> name as well as USB ID, really ought to be in some kind of place like 
> gspca.txt. It is after all much easier to edit a text file than it is to 
> write code, and the contents of the text file do not contribute to the growth 
> of size of the resulting binary. And it would be at least as easy, at least 
> from this point forward, to place the responsibility on the author/maintainer 
> of a gspca_* module to provide such a list as part of the procedure for 
> submitting code and patches. Then a perl script could, for example, parse 
> that one file and put the entries into alphabetical order, or any other 
> reasonable and desired order.

This will only work fine if there are some sanity check script to validate 
if all USB ID's are present at gspca.txt. Otherwise, we'll always have the 
risk of not having it properly updated.

There is another alternative: add a comment before each new board at 
gspca's USB ID's entries. Something like:

static const __devinitdata struct usb_device_id device_table[] = {
 	/* Webcam: Sakar Micro Digital 2428x / Jazz JDC9 */
 	{USB_DEVICE(0x2770, 0x905c)},
 	/* Webcam: Disney pix micro */
 	{USB_DEVICE(0x2770, 0x9050)},
 	/* Webcam: Suprema Digital Keychain Camera */
 	{USB_DEVICE(0x2770, 0x913d)},
 	{}
};

This could be easily parseable by a script that would generate the 
gspca.txt. Also, the patch for it can be generated by some script.

> As I said already:
>
>> > 
>> >  The need to rely on "the guy" is greatly reduced if such procedures are
>> >  put into place. Then it is the responsibility of the person who writes 
>> >  the
>> >  module to produce the information in the first place, and it is one of 
>> >  the
>> >  items on the checklist at submission time. It is also very easy for
>> >  someone else to add to the iist later on, if the occasion arises.
>
> So this is my suggestion. I think the proper place for the information is a 
> text file, and one already exists which is along those lines but is 
> incomplete. The way to make sure the information gets into the file is then 
> to make that step to be part of the patch procedure for adding drivers.
>
> Theodore Kilgore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
