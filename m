Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab2EVJJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 05:09:27 -0400
Message-ID: <4FBB57C4.4040601@iki.fi>
Date: Tue, 22 May 2012 12:09:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: SNR status for demods
References: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com>
In-Reply-To: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just ping up old thread since I updated that list.

On 18.03.2009 04:45, Devin Heitmueller wrote:
> Hello all,
>
> I have updated my compiled list of the various demods and how they
> currently report SNR info (including feedback from people in the last
> round).
>
> http://www.devinheitmueller.com/snr.txt

I updated that list up to that day:
http://palosaari.fi/linux/v4l-dvb/snr_2012-05-21.txt

> Here's how you can help out:
>
> If you are a maintainer for a device in this list, please let me know
> so I can update the document.  If you are the maintainer and somebody
> else's name is listed by the device, please do not take offense to
> this (it's probably just an error on my part [please email and correct
> me]).
>
> If you have specs for a device in this list where the format is
> currently "unknown", please let me know as this will be helpful in
> identifying which demods we can get accurate information for.
>
> If you know something about how SNR is currently reported by the
> driver, and it is not reflected in this list, please let me know and I
> will update the document.
>
> All of the above information will be helpful once a format has been
> decided on, so we can pull together and finally get a consistent
> interface.
>
> Thank you for your time,
>
> Devin
>

Basically, but not every case, there seems to be 3 different way:
1) return raw register value without any calculation
2) 0.1 dB
3) scaled to 0-0xffff using some formula

Very many drivers seems to do some dB handling even finally scaling it 
to some value.

regards
Antti
-- 
http://palosaari.fi/
