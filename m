Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46894 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760810AbZBESPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 13:15:41 -0500
From: "Curran, Dominic" <dcurran@ti.com>
To: =?iso-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 5 Feb 2009 12:15:33 -0600
Subject: RE: [REVIEW][PATCH] LV8093: Add driver for LV8093 lens actuator.
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5012A70F2EF@dlee07.ent.ti.com>
In-Reply-To: <b0bb99640902042326w3a65be12l3bd53f2aee276dc9@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Juan Jesús García de Soria Lucena [mailto:skandalfo@gmail.com]
> Sent: Thursday, February 05, 2009 1:26 AM
> To: Curran, Dominic
> Cc: linux-media@vger.kernel.org
> Subject: Re: [REVIEW][PATCH] LV8093: Add driver for LV8093 lens actuator.
>
> Hi.
>
> 2009/2/4 Dominic Curran <dcurran@ti.com>:
> > The device has only one read register which contains a single BUSY bit.
> > For large relative lens movements the device can be busy for sometime and we
> need
> > to know when the lens has stopped moving.
> >
> > My question is what is the most appropriate mechanism to read the BUSY bit ?
> >
> > Currently the driver uses the VIDIOC_G_CTRL ioctl + V4L2_CID_FOCUS_RELATIVE
> ctrl
> > ID to return the BUSY bit.  Is this acceptable ?
>
> [...]
>
> > A 3rd solution is to read the BUSY bit everytime after a write and not
> return
> > until device is ready.  However this adds extra time to the operation
> > (particularly for small lens moves) and I would like the user to be in
> change of
> > when the reads of BUSY bit occur.
>
> And what about waiting for not BUSY at the *beginning* of the next
> lens adjustment if the previous one hasn't finished yet? This could be
> combined with either a polling interface or a sync style interface
> (wait for not BUSY function) for the case in which the user wants to
> actually be sure that the lens got up to its target state.


Yes, poll would be a good solution, but I'm can not workout how I can add a poll() method to a v4l slave driver ?

Are there an examples of such v4l slave drivers you can point me too ?

All the v4l drivers I can find that have .poll fops register using video_register_device(). My slave driver uses v4l2_int_device_register().

Any pointers appreciated.
Thanks
dom

