Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44957 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1DCPhJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 11:37:09 -0400
Received: by wya21 with SMTP id 21so4084551wya.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 08:37:07 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mr Tux <tuxoholic@hotmail.de>
Subject: Re: dibusb device with lock problems
Date: Sun, 3 Apr 2011 17:37:00 +0200
Cc: linux-media@vger.kernel.org, grafgrimm77@gmx.de,
	castet.matthieu@free.fr
References: <BLU0-SMTP2588D5C8C024CC3D20EE63D8A10@phx.gbl>
In-Reply-To: <BLU0-SMTP2588D5C8C024CC3D20EE63D8A10@phx.gbl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104031737.00564.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mr Tux,

On Saturday 02 April 2011 15:45:22 Mr Tux wrote:
> Hi list, hello Patrick,
> 
> A locking problem with specific dib3000mb devices is still present in
> kernel 2.6.38.
> 
> Now people upgrading from lenny to squeeze are also affected - see: [1]
> 
> Please have a look at my previous post in [2] for a detailed description
> and links to this bug's history.
> 
> I'm sending a cc of this to the people who once where affected by this
> bug or involved with the code change that introduced it.
> 
> Anyone can confirm this is fixed/pending for his device and what
> dib3000mb device he is using out of the linuxtv wiki list of 14
> dib3000mb devices [3]?
> 
> I have 3 devices of the hama usb 1.1 series: [4], that's number 66 in the
> wiki listing - they all are affected by this bug with kernels > 2.6.31
> 
> Thanks for some feedback. Can we fix this for good for the pending
> devices?
> 
> 
> [1] http://www.vdr-portal.de/index.php?page=Thread&postID=991041

In the post on vdr-portal you're showing the kernel-output of 2.6.32 I 
guess, do you still have the kernel output of 2.6.26 (or any before 2.6.32)?

I think this line is not normal in your case:

 dibusb: This device has the Thomson Cable onboard. Which is default.

But to be sure I need you to test. TUning the device is not needed with the 
old kernel, just plugging it and checking that line should be enough.

--
Patrick.
