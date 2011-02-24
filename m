Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1BXOnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:43:16 -0500
Received: by wwb39 with SMTP id 39so821513wwb.1
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 06:43:15 -0800 (PST)
From: Vivek Periaraj <vivek.periaraj@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Hauppauge WinTV USB 2
Date: Thu, 24 Feb 2011 20:13:25 +0530
References: <201102240116.18770.Vivek.Periaraj@gmail.com> <201102240255.00946.Vivek.Periaraj@gmail.com> <AANLkTikNiEKZNVs1DGDvuLR0r+XTWLgi03nbk=272fqj@mail.gmail.com>
In-Reply-To: <AANLkTikNiEKZNVs1DGDvuLR0r+XTWLgi03nbk=272fqj@mail.gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102242013.25473.Vivek.Periaraj@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 24 February 2011 02:56:54 you wrote:
> Questions like this should be directed to the mailing list and not me
> personally, where any number of people can help you out with basic
> build problems.

Hi All,

I am getting the below errors. I found there are patches available for this 
but couldn't find out. Can you let me know how to fix these errors?

Thanks,
Vivek.

/mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c: In function 
'tm6000_uninit_isoc':
/mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:522: error: implicit 
declaration of function 'usb_free_coherent'
/mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c: In function 
'tm6000_prepare_isoc':
/mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:612: error: implicit 
declaration of function 'usb_alloc_coherent'
/mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:613: warning: 
assignment makes pointer from integer without a cast
