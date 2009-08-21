Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36519 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbZHUUR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 16:17:27 -0400
Received: by fxm17 with SMTP id 17so643631fxm.37
        for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 13:17:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54b126f90908211305j6911820es52c8ffc2be6b9667@mail.gmail.com>
References: <54b126f90908211227k78cfeebbqcee4da4958743a3b@mail.gmail.com>
	 <829197380908211238i58670a12p39537af14dbfc009@mail.gmail.com>
	 <54b126f90908211305j6911820es52c8ffc2be6b9667@mail.gmail.com>
Date: Fri, 21 Aug 2009 16:17:26 -0400
Message-ID: <829197380908211317k401b6b2etdb88a90e6e7e53fa@mail.gmail.com>
Subject: Re: detection of Empire Media Pen Dual TV
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Baggius <baggius@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 21, 2009 at 4:05 PM, Baggius<baggius@gmail.com> wrote:
> Hello Devin,
> I have an Empire Media Pen Dual TV and it has same layout as Kworld dvb-t 310u.
> while MSI Digivox A/D has "similar" layout and supports 1080i extra resolution,
> as http://www.msi.com/index.php?func=proddesc&maincat_no=132&prod_no=626
>
> If you want I can capture usb device startup log using Usbsnoop/SniffUSB  ...
> Giuseppe

Hmmm...  Let's hold off on a usb capture for now.  Now that I
understand that you have the Empire board, I am looking at the dmesg
trace again and am a bit confused.  Do you happen to have a "card=49"
parameter in your modprobe configuration?  However, the code does
appear to also recognize the board as the Empire board (see the "Board
detected as Empire dual TV").

I agree that something appears to be wrong.  I will have to take a
look at the code and see where the "Identified as" messages comes
from.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
