Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50148 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZHYVu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 17:50:28 -0400
Message-ID: <4A945CA4.6010402@iki.fi>
Date: Wed, 26 Aug 2009 00:50:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Cyril Hansen <cyril.hansen@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
 mythbuntu 9.04
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com> <200908041312.52878.jareguero@telefonica.net> <8527bc070908041423p439f2d35y2e31014a10433c80@mail.gmail.com> <200908042348.58148.jareguero@telefonica.net>
In-Reply-To: <200908042348.58148.jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2009 12:48 AM, Jose Alberto Reguero wrote:
>>> I have problems with some hardware, and the buffersize when the
>>> buffersize is not multiple of TS_PACKET_SIZE.

USB2.0 BULK stream .buffersize is currently 512 and your patch increases 
it to the 65424. I don't know how this value should be determined. I 
have set it as small as it is working and usually it is 512 used almost 
every driver. 511 will not work (if not USB1.1 configured to the endpoints).

****

Could someone point out how correct BULK buffersize should be 
determined? I have thought that many many times...

****

Also one other question; if demod is powered off and some IOCTL is 
coming - like FE_GET_FRONTEND - how that should be handled? v4l-dvb 
-framework does not look whether or not demod is sleeping and forwards 
that query to the demod which cannot answer it.

regards
Antti


-- 
http://palosaari.fi/
