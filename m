Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:54389 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZBELrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2009 06:47:45 -0500
Date: Thu, 5 Feb 2009 12:39:47 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Adam Baker <linux@baker-net.org.uk>
Cc: kilgota@banach.math.auburn.edu,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during
 disconnect
Message-ID: <20090205123947.0ba06e44@free.fr>
In-Reply-To: <200902042207.44867.linux@baker-net.org.uk>
References: <200902032313.17538.linux@baker-net.org.uk>
	<20090204174008.31846f22@free.fr>
	<200902042207.44867.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Feb 2009 22:07:44 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> Thank You - If it wasn't for your work on gspca I'd still be using a
> buggy old driver that had no chance of making it to main line.

OK. It seems everything works fine with your webcam(s) (and the other
ones).

I added some more checks of the device presence and fixed a bit the API.

Are you ready to send me a patch for the driver?

I have just a remark: in sd_init (probe/resume), you do

	dev->work_thread = NULL;
	INIT_WORK(&dev->work_struct, sq905_dostream);

The first line is not needed, and the second should be done in
sd_config (probe only - on resume, the work will remain the same).

Also, the BUG_ON in sd_start is not needed.

About finepix, indeed, it asks for fixes, but also, it would be
simplified with a workqueue...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
