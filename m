Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45426 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2AKJkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 04:40:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Using OMAP3 ISP live display and snapshot sample applications
Date: Wed, 11 Jan 2012 10:41:04 +0100
Cc: linux-media@vger.kernel.org
References: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com> <201201081230.42414.laurent.pinchart@ideasonboard.com> <CAOy7-nNEYxbH2gqfS=hRuBMJWeX+cbm4ReNvncdoJMsazdQaDQ@mail.gmail.com>
In-Reply-To: <CAOy7-nNEYxbH2gqfS=hRuBMJWeX+cbm4ReNvncdoJMsazdQaDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201111041.06017.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Wednesday 11 January 2012 05:24:35 James wrote:
> On Sun, Jan 8, 2012 at 7:30 PM, Laurent Pinchart wrote:
> > On Sunday 08 January 2012 02:14:55 James wrote:
> > 
> > [snip]
> > 
> >> BTW, can you send me the defconfig file you used for testing on overo as
> >> I couldn‘t compile your branch with mine.
> > 
> > Attached.
> > 
> >> I forgot to mentioned that I'm trying out the application with the
> >> MT9V032 camera first on both Tobi & Chestnut board. Not with the new
> >> monochrome sensor yet.
> > 
> > --
> > Regards,
> > 
> > Laurent Pinchart
> 
> Thanks for the defconfig.
> 
> I'll proceed to try to build a fresh kernel based on your branch
> "omap3isp-sensors-board".
> 
> I guess this is a better branch or should I try the YUV branch or others?

That's the right branch. The YUV branch is just work in progress.

> Test1 with MT9V032 and Test2 with monochrome sensor Y12.

-- 
Regards,

Laurent Pinchart
