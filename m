Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:39646 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZBCTxE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 14:53:04 -0500
Date: Tue, 3 Feb 2009 20:47:07 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: kilgota@banach.math.auburn.edu
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
Message-ID: <20090203204707.366a5b3a@free.fr>
In-Reply-To: <alpine.LNX.2.00.0902031343030.1944@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk>
	<200901272101.27451.linux@baker-net.org.uk>
	<alpine.LNX.2.00.0901271543560.21122@banach.math.auburn.edu>
	<200901272228.42610.linux@baker-net.org.uk>
	<20090128113540.25536301@free.fr>
	<alpine.LNX.2.00.0901281554500.22748@banach.math.auburn.edu>
	<20090131203650.36369153@free.fr>
	<alpine.LNX.2.00.0902022032230.1080@banach.math.auburn.edu>
	<20090203103925.25703074@free.fr>
	<alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
	<alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu>
	<20090203191311.2c1695b7@free.fr>
	<alpine.LNX.2.00.0902031302060.1882@banach.math.auburn.edu>
	<20090203202307.0ae074ec@free.fr>
	<alpine.LNX.2.00.0902031343030.1944@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009 13:54:15 -0600 (CST)
kilgota@banach.math.auburn.edu wrote:

> > Indeed, the problem is there! You must have only one process
> > reading the webcam! I do not see how this can work with these 2
> > processes...  
> 
> The problem, then, would seem to me to boil down to the question of 
> whether that is up to us. Apparently, a decision like that is not up
> to us, but rather it is up to the compiler and to the rest of the
> kernel to decide. Which, incidentally, appears to me to be a very
> logical way to arrange things. Presumably, a dual- or multi-core
> machine gives certain advantages, or it ought to, but it also
> requires certain accommodations.

Yes, a multiprocessor machine is a plus, but, you must run only one
process to handle streaming. If you have not seen it yet, this is done
changing the line 373 of sq905.c (if I have the same source as yours)
from:

	dev->work_thread = create_workqueue(MODULE_NAME);
to
	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
