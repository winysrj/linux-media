Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:55956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0IEIxQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 04:53:16 -0400
Message-ID: <4C835BC7.5000209@redhat.com>
Date: Sun, 05 Sep 2010 10:58:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Jonathan Isom <jeisom@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patryk Biela <patryk.biela@gmail.com>
Subject: Re: ibmcam (xrilink_cit) and konica webcam driver porting to gspca
 update
References: <4C3070A4.6040702@redhat.com>	<AANLkTinXb=TeSGO_6Mr6jhzaUOUZ3yZL5+oAP2GP0GG5@mail.gmail.com>	<4C792BE1.6090001@redhat.com> <AANLkTik8jg1K_54dJ5nsnCydJzpwRNt-BzctwA1Spgq8@mail.gmail.com>
In-Reply-To: <AANLkTik8jg1K_54dJ5nsnCydJzpwRNt-BzctwA1Spgq8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi,

On 08/31/2010 11:43 PM, David Ellingsworth wrote:
> Hans,
>
> I haven't had any success with this driver as of yet. My camera is
> shown here: http://www.amazon.com/IBM-Net-Camera-Pro-camera/dp/B0009MH25U
> The part number listed on the bottom is 22P5086. It's also labeled as
> being an IBM Net Camera Pro.

Ah ok, so you have the same one as I have, that model was never supported
by the old ibmcam driver, so I take it you never had it working with the
old ibmcam driver ?

 > When I plug the camera in, it is detected
> by the driver but it does not seem to function in this mode. Every
> attempt to obtain video from it using qv4l2 results in a black or
> green image.
>
> If I use the ibm_netcam_pro module option

Given that is the same camera as I have using the ibm_netcam_pro module
option is definitely the right thing to do.

I noticed in your lsusb -v output that you're doing this from within vmware?

I think that is the cause of things not working. This camera will not
even work when connected through a real hub, let alone through a
virtual one. The only way this camera works for me is when it is
connected to a usb port directly on the motherboard, running Linux
directly on the hardware, can you please try that ?

Regards,

Hans
