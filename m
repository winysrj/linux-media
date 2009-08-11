Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46783 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZHKUeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 16:34:44 -0400
Received: by gxk9 with SMTP id 9so5468169gxk.13
        for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 13:34:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A81D38A.2050201@email.it>
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>
	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>
	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it>
	 <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>
	 <4A7B0333.1010901@email.it> <4A81D38A.2050201@email.it>
Date: Tue, 11 Aug 2009 16:34:44 -0400
Message-ID: <829197380908111334xf9a89b4gf2da1e4cc765b27b@mail.gmail.com>
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 11, 2009 at 4:24 PM, <xwang1976@email.it> wrote:
> Hi to all!
> I don't know why, but today my device has changed its EEPROM hash to the
> following value 0x396a0441
> as you can see from the attached dmesg.
> So it is not recognized anymore.
> Is there something that can cause such a change?
> I suspect it is not the first time that the eprom hash of this device
> change.
> Can you help me?
> Xwang
>
> PS Meantime I will change the hash and test if the device work again.

Comparing the two eeprom dumps (the one from your previous email
versus the one you just sent), it would appear that something resulted
in the value 0xFF written to offset 0xF0.  What were you doing
immediately prior to the failure?  I'm not sure how we could have
gotten into this state.

Douglas, in a few minutes I am leaving town for the next five days.
Can you help Xwang out to restore his eeprom content using your tool?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
