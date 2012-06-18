Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37123 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2FRKlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 06:41:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Dreimann <philipp@dreimann.net>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo issue with kernel 3.5-rc2 and 3
Date: Mon, 18 Jun 2012 12:41:59 +0200
Message-ID: <4704338.LhTThHjxGK@avalon>
In-Reply-To: <CADYPuQ4eoX-eZNPQE6S2DYQFA-z2UuBNdpUNz4UCVi6GJWHruw@mail.gmail.com>
References: <CADYPuQ4eoX-eZNPQE6S2DYQFA-z2UuBNdpUNz4UCVi6GJWHruw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Sunday 17 June 2012 13:35:07 Philipp Dreimann wrote:
> Hello,
> 
> my external webcam from Logitech (I guess it's a c910) stopped working
> using kernel 3.5-rc3.( 3.4 worked fine.)
> 
> uvcvideo: Found UVC 1.00 device <unnamed> (046d:0821)
> input: UVC Camera (046d:0821) as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input14
> usbcore: registered new interface driver uvcvideo
> USB Video Class driver (1.1.1)
> uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to query (GET_DEF) UVC control 3 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to query (GET_DEF) UVC control 7 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to query (GET_DEF) UVC control 11 on unit 2: -71 (exp. 1).
> uvcvideo: Failed to query (GET_DEF) UVC control 4 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to query (GET_DEF) UVC control 5 on unit 2: -71 (exp. 1).
> uvcvideo: Failed to query (GET_CUR) UVC control 11 on unit 2: -71 (exp. 1).
> uvcvideo: Failed to query (GET_DEF) UVC control 8 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to query (GET_DEF) UVC control 1 on unit 2: -71 (exp. 2).
> uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
> uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
> uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
> uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
> (the last line is being repeated...)

This might be cause by a bug in the USB core or in the UVC driver. Would you 
be able to bisect the regression ? Or, alternatively, test the v3.4 uvcvideo 
driver on v3.5-rc3 ? Or the other way around, test the latest v4l tree on v3.4 
(instructions regarding how to compile the v4l tree with a different kernel 
are available at 
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-
DVB_Device_Drivers).

> I used cheese to test the webcam. My other webcam is working fine:
> uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
> input: Integrated Camera as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input13

-- 
Regards,

Laurent Pinchart

