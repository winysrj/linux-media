Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:58984 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0AXB3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 20:29:14 -0500
Date: Sat, 23 Jan 2010 19:44:06 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] sq905c: remove unused variable
In-Reply-To: <68cac7521001231550i40f4b28fy3d073c043e4027e2@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1001231909070.12296@banach.math.auburn.edu>
References: <68cac7521001231550i40f4b28fy3d073c043e4027e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sat, 23 Jan 2010, Douglas Schilling Landgraf wrote:

> Removed unused variable.
>
> Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
>
> Thanks,
> Douglas
>

Douglas,

Thanks for your sharp eyes.

However, I _think_ that this particular problem may have already been 
fixed, recently if not some time before. In particular, recent changes 
have been done in the version of sq905c.c which lives in the gspca tree of 
Hans de Goede. I am working off his tree these days because we have been 
doing a number of things together, and thus the changes there to sq905c.c 
have been done by a patch from here.

These changes were done in order to add a couple of new cameras and to 
change the way to decide whether the camera is a VGA or a CIF camera. The 
determination of this by USB Product number does not always work, and one 
needs to read an ID string from the camera in order to learn it better. 
Who bought the camera which has the "wrong" resolution setting associated 
with its USB Product number? Hans de Goede.

It appears to me that this patch is not relevant to that most recent 
version of sq905c.c. At least, it does not fit here, which is where it 
appears it is supposed to fit:

/* This function is called at probe time just before sd_init */
static int sd_config(struct gspca_dev *gspca_dev,
 		const struct usb_device_id *id)
{
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev = (struct sd *) gspca_dev;
 	int ret;

 	PDEBUG(D_PROBE,
 		"SQ9050 camera detected"


If everyone else is agreeable, I would propose that the recent changes to 
sq905c.c should simply be pulled, and that is the best solution to the 
problem.

Hans, can you confirm all of this?


Theodore Kilgore
