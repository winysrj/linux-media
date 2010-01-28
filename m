Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:56880 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0A1OA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 09:00:27 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: moinejf@free.fr
Subject: Re: Problem with gspca and zc3xx
Date: Thu, 28 Jan 2010 14:35:18 +0100
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
MIME-Version: 1.0
Message-Id: <201001281435.18314.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 12 Jan 2010 00:35:28 -0800 Jean-Francois Moine wrote:

> Hi Jose Alberto and Hans,
> 
> Hans, I modified a bit your patch to handle the 2 resolutions (also, the
> problem with pas202b does not exist anymore). May you sign or ack it?
> 
> Jose Alberto, the attached patch is to be applied to the last version
> of the gspca in my test repository at LinuxTv.org
>         http://linuxtv.org/hg/~jfrancois/gspca
> May you try it?
> 
> Regards.

Hi  Jean-Francois,
I applied your patch and it works, the 8 black lines at the bottom are 
disappeared.

Without the patch I was getting tons of 

 libv4lconvert: Error decompressing JPEG: unknown huffman code: 0000ffff

error messages while now I get only once as soon as I launch svv. I'm 
wondering what is causing now this minor problem.

Thanks,
Fabio
