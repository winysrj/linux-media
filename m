Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44735 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab2JJOXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:23:19 -0400
Message-ID: <507584BD.20908@iki.fi>
Date: Wed, 10 Oct 2012 17:22:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Aapo Tahkola <aet@rasterburn.org>,
	CityK <cityk@rogers.com>
Subject: Re: [PATCH 0/5] v4l-utils: add some scripts from the wiki.
References: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2012 04:39 PM, Antonio Ospite wrote:
> Hi,
>
> I recently used some scripts I found on the linuxtv.org wiki to extract
> a firmware for a m920x device from USB dumps made with UsbSniff2.0 on
> WIndows XP.
>
> I thought these scripts may be collected in v4l-utils where it is easier
> to change them.
>
> The first two patches add the scripts as they are now on the wiki, I am
> sending them on behalf of the original author even if I was not able to
> contact him, I hope this is OK.

I am almost 100% it is not OK to sign those to Kernel behalf of Aapo. 
Maybe it is possible to keep Aapo as a author, but sign with yourself.


>
> The subsequent changes are little fixes to make m920x_parse.pl work for me.
>
> Regards,
>     Antonio
>
>
> Aapo Tahkola (2):
>    contrib: add some scripts to extract m920x firmwares from USB dumps
>    contrib: add a script to convert usbmon captures to usbsnoop
>
> Antonio Ospite (3):
>    m920x_parse.pl: use string comparison operators
>    m920x_parse.pl: fix strict and warnings checks
>    m920x_parse.pl: add support for consuming the output of
>      parse-sniffusb2.pl
>
>   contrib/m920x/m920x_parse.pl       |  295 ++++++++++++++++++++++++++++++++++++
>   contrib/m920x/m920x_sp_firmware.pl |  115 ++++++++++++++
>   contrib/usbmon2usbsnoop.pl         |   53 +++++++
>   3 files changed, 463 insertions(+)
>   create mode 100755 contrib/m920x/m920x_parse.pl
>   create mode 100755 contrib/m920x/m920x_sp_firmware.pl
>   create mode 100755 contrib/usbmon2usbsnoop.pl
>

regards
Antti

-- 
http://palosaari.fi/
