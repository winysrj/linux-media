Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:19011 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbZJPOwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 10:52:43 -0400
Received: by fg-out-1718.google.com with SMTP id d23so344253fga.1
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 07:50:55 -0700 (PDT)
Date: Fri, 16 Oct 2009 17:51:07 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Donald Bailey <donnie@apple2pl.us>, linux-media@vger.kernel.org
Subject: Re: Status of CX25821 PCI-E capture driver
Message-ID: <20091016145107.GA20509@moon>
References: <4AD86B3A.8010704@apple2pl.us> <83bcf6340910160725g579d5d4fm72efd7f599556273@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83bcf6340910160725g579d5d4fm72efd7f599556273@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 16, 2009 at 10:25:53AM -0400, Steven Toth wrote:
> On Fri, Oct 16, 2009 at 8:46 AM, Donald Bailey <donnie@apple2pl.us> wrote:
> > I recently picked up a 16 port DVR card from China which uses two CX25821
> > chips.  I compiled the staging driver for it and was able to load it
> > successfully with kernel 2.6.32-rc2.  But I can't find any /dev devices to
> > get at the inputs.  I created a character device with a major/minor of 81/0
> > but am unable to open it.
> 
> We're planning to do some work inside KernelLabs on that particular
> driver. We have access to hardware and are looking to stabilize and
> improve the overall quality of the driver to a commercial production
> grade. I don't have any timescales as this is currently and unfunded
> project but you're not alone, the driver does need some major
> improvements.

Mmm, any links to a reasonably priced CX25821 capture cards?
