Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:37415 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab1K2Rw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 12:52:57 -0500
Date: Tue, 29 Nov 2011 18:53:36 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: <luca.risolia@studio.unibo.it>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] JPEG encoders control class
Message-ID: <20111129185336.31543872@tele>
In-Reply-To: <4ED3D77C.2020109@studio.unibo.it>
References: <4EBECD11.8090709@gmail.com>
	<201111281320.30522.hverkuil@xs4all.nl>
	<4ED3D77C.2020109@studio.unibo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 28 Nov 2011 19:48:28 +0100
Luca Risolia <luca.risolia@studio.unibo.it> wrote:

> > Note that et61x251 and sn9c102 are going to be deprecated and removed at some
> > time in the future (gspca will support these devices).  
> 
> Has this been discussed yet? Also, last time I tried the gspca driver 
> with a number of V4L2-compliant applications, it did not support at all 
> or work well for all the sn9c1xx-based devices I have here, which are 
> both controllers and sensors the manufacturer sent to me when developing 
> the driver with their collaboration. I also don't understand why the 
> gspca driver has been accepted in the mainline kernel in the first 
> place, despite the fact the sn9c1xx has been present in the kernel since 
> long time and already supported many devices at the time the gspca was 
> submitted. Maybe it's better to remove the duplicate code form the gspca 
> driver and add the different parts (if any) to the sn9c1xx.

Hi Luca,

Removing the sn9c102 is on the way for a long time. I think we were just
waiting for a message from you!

Why is gspca in the kernel? Because of its design: all the system / v4l2
interface are in the main driver, while the subdrivers only deal with
the specific device exchanges. This simplifies development and
maintenance.

At the beginning, the gspca did not handle the sn9c102 webcams (but
some Sonix based webcams were already handled only by gspca). From time
to time, there were users saying that their webcams did not work
correctly with the sn9c102, and that they worked better with gspca. So,
we moved their IDs to gspca.

Now, the sonixjb and sonixj subdrivers handle many more sensors than
the sn9c102 with less problems. Indeed, there are still problems, but,
as I have only 3 webcams (none with Sonix chips), I must wait for user
reports and fix them.

As you have some Sonix based webcams, and as you had contact with the
manufacturers, you should easily find if there are wrong sequences in
the gspca subdrivers and/or what could be done for a better support.
This would help...

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
