Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:43602 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032Ab0G2Q4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:56:23 -0400
Date: Thu, 29 Jul 2010 18:57:10 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hasan SAHIN <hasan.sahin@gmx.com>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca_zc3xx module
Message-ID: <20100729185710.42979135@tele>
In-Reply-To: <4C517241.9050502@gmx.com>
References: <4C517241.9050502@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jul 2010 12:21:21 +0000
Hasan SAHIN <hasan.sahin@gmx.com> wrote:

>   Hello Jean-Francois,
> 
> I am using Gentoo linux stable x86 with kernel 2.6.34-r1.
> before the kernel update to 2.6.34-r1, I was using 2.6.32-r7 and
> there was no problem with webcam.
> The webcam was working as good with kernel 2.6.32-r7(old gentoo
> stable kernel)
> but right now it does not work with the kernel 2.6.34-r1 (new gentoo 
> stable kernel)
> 
> And also I have tried with ubuntu 10.04 (kernel 2.6.32-25) and
> working good. I could not understood what is the problem. (Problem
> is : there is no output, no stream)
	[snip]
> gspca: probing 0ac8:303b
> zc3xx: probe 2wr ov vga 0x0000
> zc3xx: probe 3wr vga 1 0xc001
> zc3xx: probe sensor -> 0013
> zc3xx: Find Sensor MI0360SOC. Chip revision c001
	[snip]

Hello Hasan,

In the kernel 2.6.34, the sensor mi0360soc sequences have been changed
to make the webcams 0ac8:301b work, but these sequences are wrong for
the webcams 0ac8:303b.

An other user is testing the fix which is in my test tarball (see my
home page below - current version 2.10.4). There is just one remaining
problem: the image is mirrored, and I have not found yet how to set it
normal...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
