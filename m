Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63004 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2GPUrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 16:47:41 -0400
Received: by bkwj10 with SMTP id j10so5118239bkw.19
        for <linux-media@vger.kernel.org>; Mon, 16 Jul 2012 13:47:39 -0700 (PDT)
Message-ID: <CC51B6485B6A454DA3BBE12BBD3636CD@work>
From: "Meftah Tayeb" <tayeb.dotnet@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>
References: <006E41BB892E488D96CC35D62816B7CC@work> <5004787E.4020706@iki.fi>
Subject: Re: Device supported ?
Date: Mon, 16 Jul 2012 22:00:07 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i didn't knew that's a propritary driver
thank you, i allready get it up
----- Original Message ----- 
From: "Antti Palosaari" <crope@iki.fi>
To: "Meftah Tayeb" <tayeb.dotnet@gmail.com>
Cc: <linux-media@vger.kernel.org>
Sent: Monday, July 16, 2012 11:24 PM
Subject: Re: Device supported ?


> On 07/14/2012 07:50 PM, Meftah Tayeb wrote:
>> Hello
>> i installed the latest Linux V4L-DVB (mediabuild) in my debian X64
>> having those DVBS2 cards:
>> http://paste.debian.net/179068/
>> dmesg output:
>> http://paste.debian.net/179072/
>> Uname -a: Linux debian 3.2.0-3-amd64 #1 SMP Thu Jun 28 09:07:26 UTC 2012
>> x86_64 GNU/Linux
>> Debian release: wheezy/sid
>> anyone ?
>
> From those pastes:
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI 
> Video and Audio Decoder (rev 04)
> CORE cx23885[0]: subsystem: 6981:8888, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
>
> ID 6981:8888 seems to belong for TurboSight TBS 6981. Unfortunately they 
> use their own binary drivers. This mailing list is for drivers that are 
> included to the Kernel. You have to look help from the device vendor 
> support page.
>
> regards
> Antti
>
> -- 
> http://palosaari.fi/
>
>
>
>
> __________ Information from ESET NOD32 Antivirus, version of virus 
> signature database 7303 (20120716) __________
>
> The message was checked by ESET NOD32 Antivirus.
>
> http://www.eset.com
>
>
> 


__________ Information from ESET NOD32 Antivirus, version of virus signature database 7303 (20120716) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com



