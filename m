Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52649 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZESH4U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 03:56:20 -0400
Message-ID: <4A12663B.5000001@redhat.com>
Date: Tue, 19 May 2009 09:56:43 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: Preliminary results with an SN9C2028 camera
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <200904160014.32558.elyk03@gmail.com> <alpine.LNX.2.00.0905151715210.12530@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0905151715210.12530@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/16/2009 12:31 AM, Theodore Kilgore wrote:
>
> I decided recently to work on support for the SN9C2028 dual-mode
> cameras, which are supported as still cameras in
> libgphoto2/camlibs/sonix. Today, I succeeded in getting three frames out
> of one of them, using svv -gr, and I was able to convert two of the
> three frames to nice images using the same decompression algorithm which
> is used for the cameras in stillcam mode.
>
> There is a lot of work to do yet: support for all appropriate resolution
> settings (which are what? I do not yet know), support for all known
> cameras for which I can chase down an owner, and incorporation of the
> decompression code in libv4l.
>
> However, I thought you might like to know that some success has been
> achieved.
>

Cool!

I recently got a vivitar mini digital camera, usb id 093a 010e,
CD302N according to gphoto, which also is a dual mode camera. It would
be nice to get the webcam mode on this one supported too. Do you know
if there has already been some base work done on that ?

Regards,

Hans
