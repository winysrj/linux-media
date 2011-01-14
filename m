Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1ANT7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 14:59:38 -0500
Received: by iyj18 with SMTP id 18so2828161iyj.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 11:59:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ocOpZ+3hi+PTuR_cHVe7ixQdTGEHVeS84ZYry@mail.gmail.com>
References: <AANLkTi=ocOpZ+3hi+PTuR_cHVe7ixQdTGEHVeS84ZYry@mail.gmail.com>
Date: Fri, 14 Jan 2011 20:59:38 +0100
Message-ID: <AANLkTinVr8mRCROx9QKRZ2ua4q0SGECPj8RMr9vkzphi@mail.gmail.com>
Subject: Re: dvb_usb_dib0700 driver woes with Pinnacle 72e stick
From: Alfredo Braunstein <abraunst@lyx.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Alfredo Braunstein wrote:

> Hi & happy new year,
>
> I recently bought a Pinnacle 72e USB stick, (lsusb says: Bus 002
> Device 011: ID 2304:0236 Pinnacle Systems, Inc. [hex]. The stick says
> "pinnacle" on front
> and "72e" and  "1100" on the back) which seemed to be supported by the
> dvb_usb_dib0700 driver.

Some update.

Strangely enough, the problem seems to be related to a too *strong*
terrestrial signal. If I plug a small antenna instead of the one on the
rooftop, things get much better. Likewise, reception improves vastly
if I use the roof antenna with a longer coaxial cable.

Now, the Windows driver seems to be able to attenuate the signal
somehow, as after initializing under windows and before cold booting
the roof top antenna works like a charm (as stated on previous mail).
The small antenna stops working (signal probably too weak?).

Does this ring any bell? Is it possible to make the driver to attenuate the
signal (possibly via an option)? Some pointers on where to look?

Thanks again,

A/
