Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38814 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0CFAQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Mar 2010 19:16:37 -0500
Date: Fri, 5 Mar 2010 18:39:37 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: linux-media@vger.kernel.org
cc: Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
In-Reply-To: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>
Message-ID: <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 4 Mar 2010, Theodore Kilgore wrote:

>
> Hi,
>
> I just upgraded to the stock 2.6.33 kernel in Slackware-current. Also after 
> having the troubles described below I cloned a completely new copy of the 
> gspca tree from http://linuxtv.org/hg/~hgoede/gspca, intending to get some 
> work done on a project recently started.
>
> I did make menuconfig (preceded on the first occasion by make distclean, of 
> course) and chose my options. Then I did make and make install. When I 
> plugged in a camera, nothing. So I tried modprobe gspca_main and here is what 
> happens
>
> root@khayyam:/home/kilgota/linux/gspca/gspca_hans_new3/gspca# modprobe 
> gspca_main
> WARNING: Error inserting v4l1_compat 
> (/lib/modules/2.6.33-smp/kernel/drivers/media/video/v4l1-compat.ko): Invalid 
> module format
> WARNING: Error inserting videodev 
> (/lib/modules/2.6.33-smp/kernel/drivers/media/video/videodev.ko): Invalid 
> module format
> FATAL: Error inserting gspca_main 
> (/lib/modules/2.6.33-smp/kernel/drivers/media/video/gspca/gspca_main.ko): 
> Invalid module format
> root@khayyam:/home/kilgota/linux/gspca/gspca_hans_new3/gspca#
>
> Any suggestions?
>
> Theodore Kilgore

I posted about this problem on this list because I have been reading that 
there are recent problems with Mercurial trees, also supposing that one 
possible cause of the problem could lie in the compatibility layer which 
directs one to the right kernel, also in the reasonable suspicion that the 
problem could originate from the new kernel 2.6.33.

This is to report the good news that none of the above suspicions have 
panned out. I still do not know the exact cause of the problem, but a 
local compile and install of the 2.6.33 kernel did solve the problem. 
Hence, it does seem that the most likely origin of the problem is 
somewhere in the Slackware-current tree and the solution does not 
otherwise concern anyone on this list and does not need to be pursued 
here.

Theodore Kilgore
