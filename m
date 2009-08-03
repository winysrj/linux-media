Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZHCR1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 13:27:04 -0400
Date: Mon, 3 Aug 2009 14:26:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
Message-ID: <20090803142614.45015b5a@pedra.chehab.org>
In-Reply-To: <alpine.LNX.2.00.0908031009250.19964@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr>
	<alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
	<20090802103350.19657a07@tele>
	<alpine.LNX.2.00.0908021302390.29819@banach.math.auburn.edu>
	<20090803103954.7150909e@tele>
	<alpine.LNX.2.00.0908031009250.19964@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 3 Aug 2009 11:01:56 -0500 (CDT)
Theodore Kilgore <kilgota@banach.math.auburn.edu> escreveu:

> On Mon, 3 Aug 2009, Jean-Francois Moine wrote:
> 
> > On Sun, 2 Aug 2009 14:12:28 -0500 (CDT)
> > Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
> >
> > 	[snip]
> >>> - as there is only one vend:prod, one line is enough in gspca.txt.
> >>
> >> This is a question about which I have been curious for quite some
> >> time, and I think that now is a good time to ask it.
> >>
> >> Just what policy do we have about this? The information which links
> >> brand and model to driver ought to be presented somewhere. If it does
> >> not go into gspca.txt then where exactly is the appropriate place to
> >> put said information?
> > 	[snip]
> >
> > Hi Theodore,
> >
> > gspca.txt has been defined only to know which subdriver has to be
> > generated for a webcam that a user already owns.
> >
> > The trade name of the webcams are often not clear enough (look at all
> > the Creative varieties). So, the user has just to plug her webcam and
> > with the vend:prod ID, she will know which driver she has to generate
> 
> So, from this the general advice to users is
> 
>  	1. Buy a camera
>  	2. Plug it in to see if it has a driver?
> 
> > (you may say that there are already tools which do the job, as easycam,
> > but I do not think they are often used).
> 
> The problem is, the USB ID (and hence the driver) are not publicized by 
> anyone connected to the manufacturer or the retailer. So the result is 
> that there is a lot of hardware out there which is is currently unusable 
> and nobody knows that, and also lots of hardware out there which is 
> perfectly usable because we already supported it, but again nobody knows 
> that. The corollary is that the "trade names" you refer to ought to be 
> listed _somewhere_ as completely, clearly, and precisely as possible. To 
> me, and obviously good place to start with that would be to list somewhere 
> in the kernel documentation the devices supported by a given driver or 
> module.
> 
> 
> >
> > The device list of the other drivers (CARDLIST.xx) are not sorted and
> > their format (numbered list) does not facilitate this job. So, I
> > prefered a list sorted by vend:prod.
> >
> > In gspca.txt, the 3rd column contains the webcam names. As you can see,
> > it is a comma separated list, so, you may put here all the names you may
> > know. But, is it useful?
> 
> I would certainly hope so. Otherwise, why bother to put any names in there 
> at all?
> 
> 
> I think that the webcam names should be only
> > in the file usb.ids which comes with the usbutils.
> 
> That file is hopelessly out of date, by definition, and occasionally 
> seems to me inaccurate in such details as ownership of USB ID X by 
> company Y, for which, for example, see the association of 0x2770 (S&Q 
> Technologies) to the Japanese camera and electronics packager and 
> retailer NHL.
> 
> More relevant to the present discussion, though, is that even if the 
> usb.ids file were completely up to date it serves an entirely different 
> purpose from what we are discussing here. My understanding is that the 
> usb.ids file is supposed to be nothing but an inventory of the devices 
> that we know about. It was never intended as a list of supported devices 
> and by its nature can not serve that purpose simultaneously. Also, a lot 
> of USB devices come under the category of "who cares what the Vendor and 
> Product number are?" such as standard mass storage pocket flash drives. So 
> I suspect that no one is conscientious about listing them.
> 
> >
> > To go further, there should be a general file which should contain all
> > the usb (and pci) devices and their associated drivers. This
> > information exists in /lib/modules/`uname -r`/modules.usbmap when all
> > drivers are generated. So, we just need a tool (and a guy!) to maintain
> > this general file...
> 
> Hmm. Yes. The "guy." Well, it is better to figure out a way to make 
> things like that happen automatically, and then one does not need to worry 
> so much about the "guy." I will mention how Gphoto handles this problem, 
> for comparison. It might not be so easy to carry out here, because what 
> finally comes is the command option gphoto2 --list-cameras. That command 
> will print out a (very long) list of all the currently nsupported cameras, 
> by name. At this point, the list has over 1000 entries. It is up to the 
> writer of the camera library to list the cameras which are supported by 
> that particular piece of software. So the entry instead of just looking 
> like this
> 
> /* Table of supported USB devices */
> static const __devinitdata struct usb_device_id device_table[] = {
>          {USB_DEVICE(0x2770, 0x905c)},
>          {USB_DEVICE(0x2770, 0x9050)},
>          {USB_DEVICE(0x2770, 0x913d)},
>          {}
> };
> 
> must contain two other additional fields, describing the name in 
> human-readable form (intended to identify the camera to the extent that 
> one can probably pick it out from others on the shelf) and the current 
> status of the support for the camera. Like this:
> 
> {"Sakar Micro Digital 2428x", GP_DRIVER_STATUS_EXPERIMENTAL, 0x2770, 0x905c},
> {"Jazz JDC9",           GP_DRIVER_STATUS_EXPERIMENTAL, 0x2770, 0x905c},
> {"Disney pix micro",    GP_DRIVER_STATUS_EXPERIMENTAL, 0x2770, 0x9050},
> {"Disney pix micro 2",  GP_DRIVER_STATUS_EXPERIMENTAL, 0x2770, 0x9052},
> {"Suprema Digital Keychain Camera", GP_DRIVER_STATUS_EXPERIMENTAL,
>                                                         0x2770, 0x913d}

The struct usb_device_id doesn't have any thing like that, and creating another
table repeating the USB ID is very ugly (yet, a few drivers do it). This also
means to add 4 extra bytes per camera, just to store a duplicated information.

The better way is to do something like:

enum {
	SAKAR_MICRO_DIGITAL_2428X,
	DISNEY_PIX_MICRO,
	DISNEY_PIX_MICRO2,
	SUPREMA_DIGITAL_KEYCHAIN_CAMERA,
};

static const __devinitdata struct usb_device_id device_table[] = {
        {USB_DEVICE(0x2770, 0x905c), .driver_info = SAKAR_MICRO_DIGITAL_2428X},
        {USB_DEVICE(0x2770, 0x9050), .driver_info = DISNEY_PIX_MICRO},
	{USB_DEVICE(0x2770, 0x9052), .driver_info = DISNEY_PIX_MICRO2},
        {USB_DEVICE(0x2770, 0x913d), .driver_info = SUPREMA_DIGITAL_KEYCHAIN_CAMERA},
         {}
};

struct camera_description {
	char *name;
	unsigned int flags;
};

static struct camera_description cameras[] = {
	[SAKAR_MICRO_DIGITAL_2428X] = {
		.name = "Sakar Micro Digital 2428x/Jazz JDC9",
		.flags = GP_DRIVER_STATUS_EXPERIMENTAL,
	},
	[DISNEY_PIX_MICRO] = {
		.name = "Disney pix micro",
		.flags = GP_DRIVER_STATUS_EXPERIMENTAL,
	},
	[DISNEY_PIX_MICRO2] = {
		.name = "Disney pix micro 2",
		.flags = GP_DRIVER_STATUS_EXPERIMENTAL,
	},
	[SUPREMA_DIGITAL_KEYCHAIN_CAMERA] = {
		.name = "Suprema Digital Keychain Camera",
		.flags = GP_DRIVER_STATUS_EXPERIMENTAL,
	},
};

The association between the two tables can easily be done at the .config ops:

/* this function is called at probe time */
static int sd_config(struct gspca_dev *gspca_dev,
                        const struct usb_device_id *id)
{

...
	int board_nr = id->driver_info;

	printf(KERN_WARN "Detected camera %s\n", cameras[board_nr]);

...
}

A small change at cx88.pl will be enough to auto-generate gspca.txt.

> 
> If something similar were done here, then perhaps it would be possible to 
> provide a tool which would print out two lists. One of them could be a 
> list of the known and supported devices by gspca, say. The second option 
> could provide a list of the devices which the local kernel supports.
> 
> The need to rely on "the guy" is greatly reduced if such procedures are 
> put into place. Then it is the responsibility of the person who writes the 
> module to produce the information in the first place, and it is one of the 
> items on the checklist at submission time. It is also very easy for 
> someone else to add to the iist later on, if the occasion arises.
> 
> Perhaps someone else can come up with a better idea?
> 
> Theodore Kilgore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
