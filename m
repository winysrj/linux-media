Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaDIJGB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 05:06:01 -0400
Message-ID: <53450D76.2010405@redhat.com>
Date: Wed, 09 Apr 2014 11:05:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: alexander@xxor.de, linux-media@vger.kernel.org
Subject: Re: gspca second isoc endpoint / kinect depth
References: <53443C5D.9000607@xxor.de>
In-Reply-To: <53443C5D.9000607@xxor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/08/2014 08:13 PM, Alexander Sosna wrote:
> Hi,
> 
> I took drivers/media/usb/gspca/kinect.c as skeleton to build a depth
> driver for the kinect camera.
> 
> I needed to implement this feature because libfreenect performs so badly
> on the raspberry pi that you can't get a single frame.
> 
> The kinecet has two isoc endpoints but gspca only uses the first.
> To get it running I made a dirty hack to drivers/media/usb/gspca/gspca.c
> I changed usb_host_endpoint *alt_xfer(...) so that it always returns the
> second endpoint, which is not really good for everyone.
> 
> 
> My driver is not ready for upstream now, it can not coexist with the
> current gspca_kinect so you have to decide if you want to load the video
> or the depth driver. Would be better to have one driver to do it all.
> 
> But in the meantime I would like to ask for ideas about a more clean
> solution to get other isoc endpoints.
> 
> There was already a little discussion about this when kinect.c was
> written by Antonio Ospite:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/26194
> 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/26213
> 
> Has something changed?

No.

> Is there a point against making multiple endpoints available?

No.

> Better solution?

Not that I know of.

Regards,

Hans
