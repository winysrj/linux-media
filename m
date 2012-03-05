Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:48278 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab2CEJyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 04:54:12 -0500
Date: Mon, 5 Mar 2012 10:55:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Skippy le Grand Gourou <lecotegougdelaforce@free.fr>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [bug?] ov519 fails to handle Hercules Deluxe webcam
Message-ID: <20120305105541.2fef6b0d@tele>
In-Reply-To: <20120305093430.GA14386@burratino>
References: <20120304223239.22117.54556.reportbug@deepthought>
	<20120305003801.GB27427@burratino>
	<20120305102101.652b46e7@tele>
	<20120305093430.GA14386@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Mar 2012 03:34:30 -0600
Jonathan Nieder <jrnieder@gmail.com> wrote:

> > To be sure, try the gspca test version from my web site.  
> 
> Skippy, assuming that works (and I expect it would), could you try the
> attached patch against 2.6.32.y?  It works like this:
> 
>  0. Prerequisites:
> 	apt-get install git build-essential
> 
>  1. Get the kernel, if you don't already have it:
> 	git clone \
> 	 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
	[snip]

This asks for a lot of job. With the gspca tarball (423Kb), you just
need the linux-headers. And it permits further debugging...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
