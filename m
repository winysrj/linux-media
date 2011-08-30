Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51699 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1H3L6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 07:58:13 -0400
Received: by bke11 with SMTP id 11so4975883bke.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 04:58:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j3iies$svi$1@dough.gmane.org>
References: <j3iies$svi$1@dough.gmane.org>
Date: Tue, 30 Aug 2011 07:58:12 -0400
Message-ID: <CAGoCfiyeFdgTk_r1taOP9XOjpnC2y4Pir8CaDdkkT-A9PqRixQ@mail.gmail.com>
Subject: Re: AVerTV Hybrid Volar MAX (H826) wiki entry
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 7:44 AM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> Hi,
>
> I was looking at the wiki for the supported status of the AVerMedia
> AVerTV Hybrid Volar MAX (H826).  The wiki says it's not supported.  But
> the wiki also says it's a PCIe card, which it's clearly not:
> http://www.avermedia-usa.com/AVerTV/Product/ProductDetail.aspx?Id=431
>
> Additionally in the AP & Driver tab of that page
> (http://www.avermedia-usa.com/AVerTV/Product/ProductDetail.aspx?Id=431&tab=APDriver)
> there is a Linux driver which appears to have (granted, non-GPL) source
> included with it.  But surely given source to a working driver, a
> cleanroom GPL driver could be developed and supported, yes?  Maybe that
> source is just "supporting" source for a binary blob.  I didn't look
> that closely.
>
> In any case, I am just wondering what the real supported status of that
> device is given that the wiki is incorrect about at least some details
> of the device.
>
> Even if it's not supported, somebody with more understanding of this
> device than I (I've just read a product page) ought to fix the wiki.  In
> fixing it, I think it's only fair to point to the vendor supplied
> driver, even if it's not open source and/or not a compatible open source
> license.

They've got a history of violating the GPL by shipping closed source
binary drivers which link against GPL'd DVB drivers (thereby
leveraging the hard work of the developers who GPL'd drivers, while
not giving any of their stuff back).

I cannot speak for the other developers but I wont' go near this crap
with a ten foot pole.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
