Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:59508 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbZHVVrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 17:47:46 -0400
Received: by fg-out-1718.google.com with SMTP id e12so342944fga.17
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 14:47:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dd7c97280908221309h404b9003i22226329e6fc856a@mail.gmail.com>
References: <dd7c97280908221309h404b9003i22226329e6fc856a@mail.gmail.com>
Date: Sat, 22 Aug 2009 17:47:46 -0400
Message-ID: <829197380908221447x1c738c52m98793c6a552db1d6@mail.gmail.com>
Subject: Re: [linux-dvb] (no subject)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 22, 2009 at 4:09 PM, Atlanta Geek<atlantageek@gmail.com> wrote:
> Using the linuxtv-dvb-apps
> I find scan generates a file with only six parameters per digital
> channel when generating  the channels.conf file.
> However czap requires 8 parameters.
> This is for a cable network.
> Does anyone have any suggestions.
>
> --
> http://www.atlantageek.com

Well, given your name and resume, I'm assuming that "atlantageek"
means "Atlanta, Georgia".  In which case, for digital tuning you use
azap (azap is used for both over-the-air ATSC as well as cable QAM).
When doing a scan for cable, you will typically use the scan file
us-Cable-Standard-center-frequencies-QAM256.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
