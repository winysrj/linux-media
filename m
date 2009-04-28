Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50180 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbZD1Qmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 12:42:52 -0400
Received: by gxk10 with SMTP id 10so1331033gxk.13
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 09:42:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0904271903o6a66c48co87b8b1829be2f62f@mail.gmail.com>
References: <412bdbff0904271903o6a66c48co87b8b1829be2f62f@mail.gmail.com>
Date: Tue, 28 Apr 2009 12:42:51 -0400
Message-ID: <b24e53350904280942s1cb0df20wc5b5e4ba671fc008@mail.gmail.com>
Subject: Re: Panic in HVR-950q caused by changeset 11356
From: Robert Krakora <rob.krakora@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Janne Grunau <j@jannau.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Watzman <jwatzman@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 27, 2009 at 10:03 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> Hello Janne,
>
> Ok, so now I need to better understand the nature of changeset 11356.
> It turns up I spent the entire afternoon debugging a kernel panic on
> usb disconnect, which ended up being due to this patch:
>
> au0828: use usb_interface.dev for v4l2_device_register
> http://linuxtv.org/hg/v4l-dvb/rev/33810c734a0d
>
> The change to pass the interface->dev to v4l2_device_register()
> effectively overwrote the interface data, so while I thought
> usb_set_intfdata() was storing the au0828_dev *, in fact it was
> holding a v4l2_device *.  When au0828_usb_disconnect() eventually gets
> called, the call to usb_get_intfdata() returned the v4l2_device, and
> presto - instant panic.
>
> So, either I can roll back this change, or I can make the call to
> usb_set_intfdata() *after* the call to v4l2_device_register().
> However, I don't know what else that might screw up (I haven't traced
> out everything in v4l2-device that might expect a v4l2_device * to be
> stored there).
>
> Suggestions?
>
> Perhaps if you could provide some additional background as to what
> prompted this change, it will help me better understand the correct
> course of action at this point.
>
> Devin
>
> cc: Robert Krakora and Josh Watzman since they both independently
> reported what I believe to be the exact same issue (the stack is
> slightly different because in their case as it crashed in the
> dvb_unregister portion of the usb_disconnect routine).
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

Devin:

I vote to roll it back until the ramifications of the changeset are
better understood.  ;-)

Best Regards,

-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
