Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0DAMBAI000755
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 05:22:11 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0DALtwR001331
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 05:21:55 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 13 Jan 2009 11:21:48 +0100
References: <96DA7A230D3B2F42BA3EF203A7A1B3B5011DA52650@dlee07.ent.ti.com>
In-Reply-To: <96DA7A230D3B2F42BA3EF203A7A1B3B5011DA52650@dlee07.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131121.49067.laurent.pinchart@skynet.be>
Cc: "Curran, Dominic" <dcurran@ti.com>
Subject: Re: Questions about V4L2_CID_FOCUS_RELATIVE ?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Dominic,

On Tuesday 13 January 2009, Curran, Dominic wrote:
> hi
> As I understand there are basically two types of lens driver.
>
> To get/set the lens position they use either:
> V4L2_CID_FOCUS_ABSOLUTE
> Or
> V4L2_CID_FOCUS_RELATIVE
>
> Does anyone have an example of a lens driver that uses
> V4L2_CID_FOCUS_RELATIVE ?

I'm not aware of any such device.

> I am having difficulty understanding how this ioctl ID is used...
>
> - I assume that the VIDIO_G_CTRL ioctl does not make sense for an
> id=V4L2_CID_FOCUS_RELATIVE. Correct ?

That's correct.

> - When using VIDIO_S_CTRL ioctl with id= V4L2_CID_FOCUS_RELATIVE.
>   I assume that the 'value' field passed down in struct v4l2_control is
> used to determine the direction the lens should move: i.e. +ve value = move
> 'value' steps in infinity direction
>      -ve value = move 'value' steps in macro direction
>   Does this seem correct ?

Quoting the V4L2 specification,

"This control moves the focal point of the camera by the specified amount. The 
unit is undefined. Positive values move the focus closer to the camera, 
negative values towards infinity."

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
