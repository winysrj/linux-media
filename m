Return-path: <linux-media-owner@vger.kernel.org>
Received: from h-66-166-198-124.nycmny83.covad.net ([66.166.198.124]:49744
	"EHLO tupari.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZAVVZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 16:25:26 -0500
Received: from tupari.net (tupari.net [192.168.1.2])
	by tupari.net (8.14.2/8.14.1) with ESMTP id n0MKja5o007993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 15:45:37 -0500
Date: Thu, 22 Jan 2009 15:45:36 -0500 (EST)
From: Joseph Shraibman <linuxtv.org@jks.tupari.net>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
In-Reply-To: <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901221542190.7960@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu> <alpine.LFD.2.00.0901221434040.7609@tupari.net> <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 22 Jan 2009, Devin Heitmueller wrote:

> Are you sure you have zero signal strength, or just really low signal
> strength?  I am pretty sure on the s5h1411, the signal strength field
> is populated with the the SNR, which could be construed as very low
> signal strength if you were expecting a percentage scaled from 0 to
> 65535.
>
> Have you run femon to confirm that the strength field really is zero?
>

FE: Oren OR51132 VSB/QAM Frontend (ATSC)
status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |

I find it more than a little suspicious that femon reports the same thing 
over and over.
