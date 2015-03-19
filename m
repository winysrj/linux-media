Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48624 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbCSSUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 14:20:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Lehmann <lehmann@ans-netz.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: capture high resolution images from webcam
Date: Thu, 19 Mar 2015 20:20:55 +0200
Message-ID: <2563432.Vgf8Q4ieBN@avalon>
In-Reply-To: <20150319191748.Horde.Nf_-EYD7TaplssAKvpAwPw6@avocado.salatschuessel.net>
References: <20150317223529.Horde.S4cQ0yA7NJaIix7vWKABGA9@avocado.salatschuessel.net> <2540710.k9cj0VyRUW@avalon> <20150319191748.Horde.Nf_-EYD7TaplssAKvpAwPw6@avocado.salatschuessel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Thursday 19 March 2015 19:17:48 Oliver Lehmann wrote:
> Hi Laurent,
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > Could you please post the output of "lsusb -v" for your camera (running as
> > root if possible) ?
> 
> No lsusb on FreeBSD but usbconfig - I hope the results are similar or are at
> least close to what you are seeking for.
> 
> http://pastebin.com/s3ndu63h

The information is there, but in a raw form, when lsusb can decode it. I'll 
let you do the homework then, two options:

1. Compile lsusb for freebsd
2. Get a copy of the UVC spec 
(http://www.usb.org/developers/docs/devclass_docs/USB_Video_Class_1_1_090711.zip) 
and decode the descriptors

Pick your poison :-)

-- 
Regards,

Laurent Pinchart

