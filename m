Return-path: <mchehab@pedra>
Received: from r02s01.colo.vollmar.net ([83.151.24.194]:36391 "EHLO
	holzeisen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab1FQORF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 10:17:05 -0400
Message-ID: <4DFB61DE.2090007@holzeisen.de>
Date: Fri, 17 Jun 2011 16:17:02 +0200
From: Thomas Holzeisen <thomas@holzeisen.de>
MIME-Version: 1.0
To: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>
CC: linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de> <4DFA7748.6000704@hoogenraad.net> <4DFB10BC.6000407@killerhippy.de>
In-Reply-To: <4DFB10BC.6000407@killerhippy.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi again,

i managed to merge the driver with a media_build snapshot by hand, and managed to get it loaded
without errors. But now where I looked more closely to the files, I noticed something.

The driver refered mentions RTL2832u and some following versions, but it _dont_ mention RTL2831u
at all. Also the card I got contains the tuners mxl5005, mt2060 and qt1010, while this driver
contains files for mxl5007 and mt2063.

Teach me wrong, but it looks like the RTL2381u had been forgotten when this driver got made ;-)

Greeting,
Thomas



Sascha Wüstemann wrote:
> Jan Hoogenraad wrote:
>> Sascha: Thanks for the links
>>
>> Would you know how to contact poma ?
>> http://www.spinics.net/lists/linux-media/msg24890.html
>>
>> I will be getting more info from Realtek soon.
>> I did not realize that they were putting out updated drivers.
>>
>> Once the status becomes more clear, I'll update
>> http://www.linuxtv.org/wiki/index.php/Realtek_RTL2831U
>>
> 
> 
> The mailinglist archive where poma had written is new to me, no sorry.
> Zdenek Stybla hosts the website he advised to me.
> 
> When I contacted Zdenek he made contact to a guy from realtek which in
> return sent us their (?) new drivers  -  you should contact Zdenek.
> 
> I don't work on the rtl2831 sources I'd like to use them :-)
> 
> I am looking forward to have current sources at v4l or at least updated
> information at the info page at linuxtv.org.
> 
> Greetings from Braunschweig, Germany.
> Sascha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

