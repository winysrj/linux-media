Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54508 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZJMSdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 14:33:46 -0400
Received: by fxm27 with SMTP id 27so10544339fxm.17
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 11:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD4C684.5070908@email.it>
References: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
	 <4AD3AE34.6020305@iki.fi>
	 <829197380910121604w6a9c5b22i26a892ff79aaf691@mail.gmail.com>
	 <4AD4C684.5070908@email.it>
Date: Tue, 13 Oct 2009 14:33:09 -0400
Message-ID: <829197380910131133k37873fedl1d7038d9e175b089@mail.gmail.com>
Subject: Re: em28xx mode switching
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 13, 2009 at 2:27 PM,  <xwang1976@email.it> wrote:
> Hi Devin,
> let me know if you need a tester for the EMPIRE_DUAL_TV.
> In case I will install the latest v4l driver on my old notebook which has a
> clean kubuntu 9.04 distro. On the newer notebook I'm using my new Dikom
> DK-300 device which does not work with the latest v4l drivers and which I
> can use using a patched version of the main v4l driver (thanks to Dainius
> Ridzevicius). If you have some spare time for this device too...
> Xwang

Hi xwang,

Well, I'm hoping to setup a tree sometime this week (and test it with
my devices).  Assuming it works, I will put out a call for testers
such as yourself.

Regarding your DK-300, if you send the diff between the main v4l
driver and the patched version, we can take a look at what would be
required to merge it upstream.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
