Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:26265 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbZJPO1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 10:27:01 -0400
Received: by ey-out-2122.google.com with SMTP id d26so138722eyd.5
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 07:25:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD86B3A.8010704@apple2pl.us>
References: <4AD86B3A.8010704@apple2pl.us>
Date: Fri, 16 Oct 2009 10:25:53 -0400
Message-ID: <83bcf6340910160725g579d5d4fm72efd7f599556273@mail.gmail.com>
Subject: Re: Status of CX25821 PCI-E capture driver
From: Steven Toth <stoth@kernellabs.com>
To: Donald Bailey <donnie@apple2pl.us>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 16, 2009 at 8:46 AM, Donald Bailey <donnie@apple2pl.us> wrote:
> I recently picked up a 16 port DVR card from China which uses two CX25821
> chips.  I compiled the staging driver for it and was able to load it
> successfully with kernel 2.6.32-rc2.  But I can't find any /dev devices to
> get at the inputs.  I created a character device with a major/minor of 81/0
> but am unable to open it.

We're planning to do some work inside KernelLabs on that particular
driver. We have access to hardware and are looking to stabilize and
improve the overall quality of the driver to a commercial production
grade. I don't have any timescales as this is currently and unfunded
project but you're not alone, the driver does need some major
improvements.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
