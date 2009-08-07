Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:33015 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647AbZHGMUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 08:20:54 -0400
Received: by gxk9 with SMTP id 9so1989885gxk.13
        for <linux-media@vger.kernel.org>; Fri, 07 Aug 2009 05:20:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7C00DA.1030805@email.it>
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>
	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>
	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it>
	 <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>
	 <4A7B0333.1010901@email.it> <4A7C00DA.1030805@email.it>
Date: Fri, 7 Aug 2009 08:20:54 -0400
Message-ID: <829197380908070520y3b5ce05dw61e08fc40d09e4b8@mail.gmail.com>
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xwang1976@email.it
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 7, 2009 at 6:24 AM, <xwang1976@email.it> wrote:
> Just a little addendum.
> I remember that the audio of analog tv has started to work with Markus'
> drivers when he added the em28xx-audioep driver because, if I have correctly
> understood, my device has a  noy standard audio.
> Is it possible to import the necessary code in the main branch so that to
> have the device fully functional (today it is unusable to see analog tv
> because no audio is present).
> Thank you to all,
> Xwang

The dmesg output suggests your device has an EMP202 on the em28xx ac97
port, which is pretty standard and should be supported by the em28xx
current audio driver.  I would have to look closer to better
understand why your audio is not working.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
