Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54383 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZFCGSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 02:18:32 -0400
Received: by bwz22 with SMTP id 22so8446405bwz.37
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2009 23:18:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090603141350.04cde59b.erik@bcode.com>
References: <20090603141350.04cde59b.erik@bcode.com>
Date: Wed, 3 Jun 2009 08:18:33 +0200
Message-ID: <62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com>
Subject: Re: Creating a V4L driver for a USB camera
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Erik de Castro Lopo <erik@bcode.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2009/6/3 Erik de Castro Lopo <erik@bcode.com>:
> Hi all,
>
> I'm a senior software engineer [0] with a small startup. Our product
> is Linux based and makes use of a 3M pixel camera. Unfortunately, the
> camera we have been using for the last 3 years is no longer being
> produced.
>
> We have found two candidate replacement cameras, one with a binary
> only driver and user space library and one with a windows driver
> but no Linux driver.
>
> My questions:
>
>  - How difficult is it to create a GPL V4L driver for a USB camera
>   by snooping the USB traffic of the device when connected to
>   a windows machine? The intention is to merge this work into
>   the V4L mainline and ultimately the kernel.

Do you have any datasheet available on what usb bridge / sensor that is used?
If the chipsets are undocumented and some proprietary image
compression technique is used, the time to reverse-engineer them can
be quite lengthy.

Best regards,
Erik
