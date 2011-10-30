Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45470 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934146Ab1J3Pm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 11:42:29 -0400
Message-ID: <4EAD7061.3020007@iki.fi>
Date: Sun, 30 Oct 2011 17:42:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon patch for dB
References: <4EAB342F.2020008@lockie.ca>
In-Reply-To: <4EAB342F.2020008@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/2011 02:01 AM, James wrote:
> I added a switch to femon so it displays signal and snr in dB.
>
> The cx23885 driver for my Hauppauge WinTV-HVR1250 reports signal and snr
> in dB.
>
> http://lockie.ca/test/femon.patch.bz2

from patch:
human readable output: (signal: 0-65335, snr: 1/256 increments)\n"
human readable output: (signal and snr in .1 dB increments)\n"

You should take look to demod drivers and check what those are 
returning. I have strong feeling that most drivers returns SNR as 10xdB. 
And SS as 0-0xffff. I think there is good consensus of SNR unit, but for 
SS it is not so clear. For my drivers I have used SNR 10xdB and SS 
0-0xffff. That's why, giving only those two alternatives is not 
suitable. Maybe it is better to set own param for SNR and SS?

Devin did some research about SNR long time back:
http://www.devinheitmueller.com/snr.txt

regards
Antti
-- 
http://palosaari.fi/
