Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:46389 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZAURZm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 12:25:42 -0500
Date: Wed, 21 Jan 2009 18:20:33 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Adam Baker <linux@baker-net.org.uk>, kilgota@banach.math.auburn.edu
Cc: linux-media@vger.kernel.org,
	Driver Development <sqcam-devel@lists.sourceforge.net>,
	Gerard Klaver <gerard@gkall.hobby.nl>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
Message-ID: <20090121182033.278f213d@free.fr>
In-Reply-To: <200901192322.33362.linux@baker-net.org.uk>
References: <200901192322.33362.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009 23:22:33 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> Add initial support for cameras based on the SQ Technologies SQ-905
> chipset (USB ID 2770:9120) to V4L2 using the gspca infrastructure.
	[snip]
> ---
> Following all the comments when I posted this for review Theodore and
> I have produced 2 new versions. The most critical comment last time
> was that we were using the system work queue inappropriately so this
> version creates its own work queue. The alternative version that I
> will post shortly avoids a work queue altogether by using
> asynchronous USB commands but in order to do so has increased the
> code size.
> 
> I'll leave it to the assembled list expertise to say which option is
> preferable.
	[snip]

Hello Adam and Theodore,

I looked at your two versions, and I think the first one (work queue)
is the simplest. So, I am ready to put your driver in my repository for
inclusion in a next linux kernel.

I have just a few remarks and a request.

- There are still small CodingStyle errors.

- Why do you need the function name in the debug messages?

- In sd_init, you should better convert the 4 bytes to u32 and do a
  switch.

- On disconnection, the function sd_stopN is not called, so the
  workqueue may be still running.

- At streamon time (sd_start), you allocate the buffer and send a
  command. This may be done in the workqueue function. This function may
  also do the buffer free and send the stop command on exit.

Re-thinking the streaming part gives:
. streamon (sd_start)
	. init_completion()
	. start the workqueue
	  (dev->streaming is not useful)
. workqueue function
	. allocate the transfer buffer (pointer in the stack)
	. send 'start capture'
	. read loop - don't forget:
		- to test gspca_dev->streaming: it may be streamoff,
			close or disconnect
		- to protect to usb_control_msg by the
			gspca_dev->usb_lock mutex: this will permit
			to handle future webcam controls.
	. on streamoff or USB error
		. free the transfer buffer
		. complete()
. streamoff
	. sd_stopN: non useful
	. sd_stop0:
		. wait_for_completion
		. dev->work_thread = NULL

Now, the request: some guys asked for support of their webcams based on
sq930x chips. A SANE backend driver exists, written by Gerard Klaver
(http://gkall.hobby.nl/sq930x.html).
May you have a look and say if handling these chips may be done in your
driver?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
