Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56387 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZAXQ76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 11:59:58 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "Shah, Hardik" <hardik.shah@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Sat, 24 Jan 2009 22:29:27 +0530
Subject: RE: [RFC] Adding new ioctl for transparency color keying
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EB82@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Shah, Hardik
> Sent: Thursday, January 22, 2009 10:27 AM
> To: 'linux-media@vger.kernel.org'; video4linux-list@redhat.com
> Subject: [RFC] Adding new ioctl for transparency color keying
> 
> Hi,
> OMAP class of device supports transparency color keying.  Color keying can be
> source color keying or destination color keying.
> 
> OMAP3 has three pipelines one graphics plane and two video planes.  Any of
> these pipelines can go to either the TV or LCD.
> 
> The destination transparency color key value defines the encoded pixels in the
> graphics layer to become transparent and display the underlying video pixels.
> While the source transparency key value defines the encoded pixels in the
> video layer to become transparent and display the underlying graphics pixels.
> This color keying works only if the video and graphics planes are on the same
> output like TV or LCD and images of both the pipelines overlapped.
> 
> I propose to have the one ioctl to set the encoded pixel value and type of
> color keying source and destination.  Also we should have the CID to
> enable/disable the color keying functionality.
> 
> Please let us know your opinions/comments.
> 
>
[Shah, Hardik] Hi Any comments on above IOCTLs,  
Hans/Mauro,
Shall I send patch to add these new ioctls.

Regards,
Hardik Shah
 
> 
> Thanks and Regards,
> Hardik Shah
> 

