Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38533 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbbFFRnS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 13:43:18 -0400
Message-ID: <55733133.6050502@iki.fi>
Date: Sat, 06 Jun 2015 20:43:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Unembossed Name <severe.siberian.man@mail.ru>,
	linux-media@vger.kernel.org
Subject: Re: Si2168 B40 frimware.
References: <0448C37B97FE43E6A8CD61968C10E73F@unknown>
In-Reply-To: <0448C37B97FE43E6A8CD61968C10E73F@unknown>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 06:28 AM, Unembossed Name wrote:
> Hi,
>
> Yesterday I extracted a new firmware for Si2168 B40 rev. from Windows
> driver.
> It's designed for ROM version 4.0.2 and has a version build 4.0.19
> Here is a name of
> file:dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw.tar.gz
> And a link for download: http://beholder.ru/bb/download/file.php?id=854
> Anybody want to test it? Unfortunately, I can not do it myself, because
> I do not own hardware with B40 revision.

That does not even download. It looks like 17 byte chunk format, but it 
does not divide by 17. Probably there is some bytes missing or too many 
at the end of file.

That is how first 16 bytes of those firmwares looks:
4.0.4:  05 00 aa 4d 56 40 00 00  0c 6a 7e aa ef 51 da 89
4.0.11: 08 05 00 8d fc 56 40 00  00 00 00 00 00 00 00 00
4.0.19: 08 05 00 f0 9a 56 40 00  00 00 00 00 00 00 00 00

4.0.4 is 8 byte chunks, 4.0.11 is 17 byte.

regards
Antti

-- 
http://palosaari.fi/
