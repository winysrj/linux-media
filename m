Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp38.i.mail.ru ([94.100.177.98]:56099 "EHLO smtp38.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbFHWPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 18:15:05 -0400
Received: from [171.33.253.160] (port=22300 helo=unknown)
	by smtp38.i.mail.ru with esmtpa (envelope-from <severe.siberian.man@mail.ru>)
	id 1Z25Ju-00023R-7n
	for linux-media@vger.kernel.org; Tue, 09 Jun 2015 01:15:02 +0300
Message-ID: <143B25D372A842478792E29914320459@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>
References: <A9A450C95D0047DA969F1F370ED24FE4@unknown> <5575B32D.8050809@iki.fi>
Subject: Re: About Si2168 Part, Revision and ROM detection.
Date: Tue, 9 Jun 2015 05:14:58 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Antti Palosaari"
To: "Unembossed Name" <severe.siberian.man@mail.ru>; <linux-media@vger.kernel.org>
Sent: Monday, June 08, 2015 10:22 PM
Subject: Re: About Si2168 Part, Revision and ROM detection.


>> Also, I would like to suggest a following naming method for files
>> containing firmware patches. It's self explaining:
>> dvb-demod-si2168-a30-rom3_0_2-patch-build3_0_20.fw
>> dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw.tar.gz
>> dvb-demod-si2168-b40-rom4_0_2-startup-without-patch-stub.fw
> 
> There is very little idea to add firmware version number to name as then 
> you cannot update firmware without driver update. Also, it is not 
> possible to change names as it is regression after kernel update.

I'm sure, that demodulator will accept firmware patch only if that patch will be
matched with ROM version it's designed for. In all other cases patch will be
rejected by IC. This is because this patches is not a completely new ROM code
containing firmware update. Probably, for Si2168 such kind of updates has never
existed and never will be.

One user has reported, that with his A30 revision of demodulator, he was unable
to upload firmware patch, wich was taken from
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-A30/3f2bc2c63285ef9323cce8689ef8a6cb/dvb-demod-si2168-a30-01.fw
And at the same time, he was able to successfully upload firmware patch, that
designed for A30 ROM 3.0.2 and makes version 3.0.2 => 3.0.20 after patching
completes. Here it is: http://beholder.ru/bb/download/file.php?id=732

What can be cause of that? Probably it's either broken or corrupted firmware
(I doubt in it), or possibly it's designed for A30 revision, but with another ROM
version?
Looking inside their HEX I cannot say, for what ROM version it is designed.
Or wich version it will make after patching completes. Thats why i suggested to
specify all this in a file name.

And, having all info about IC in one hand and necessary info about available fw
patches in /lib/firmware/ in the other, we can fully automate IC patching process.
Or left the driver code untouched, and it will be depend from an end user,  how
to choose right fw patch and properly rename it.
And in case of automated way, user also always be able to choose wich patches
are unneccesary. Just by deleting unwanted files with patches from /lib/firmware/
 
> Current driver selects firmware by reading chip revision (A, B) and 
> PMAJOR/PMINOR, which means A20, A30 and B40 are detected.
> 
> PBUILD is 2 and ROMID is 1 for me Si2168-B40 chip, without firmware 
> upgrade it boots up with fw version 4.0.2. Those numbers are just same 
> than PMAJOR.PMINOR.PBUILD, but are those?
>
> It is not clear at all what the hell is role of ROMID.

Agreed. And hardware vendor also didn't mention anything special about ROMID.
I think it can be ignored if we can't use it.
 
> I know that there is many firmware updates available and all are not 
> compatible with chip revisions. But I expect it is only waste of some 
> time when upload always biggest firmware to chip.
>
> Lets say there is old B40 having 4.0.2 on ROM. Then there is newer B40 
> having 4.0.10 on ROM. Then there is firmware upgrade to 4.0.11, one for 
> 4.0.2 and another for 4.0.10. 4.0.2 is significant bigger and as 4.0.10 
> very close to 4.0.11 it is significantly smaller. However, you could 
> download that 4.0.2 => 4.0.11 upgrade to both chips and it leads same, 
> but chip with 4.0.2 fw on ROM will not work if you upload 4.0.10 => 
> 4.0.11 upgrade. I haven't tested that theory, but currently driver does 
> that as there is no any other detection than A20/A30/B40 and it seems to 
> work pretty well. Downside is just that large fw update done always.

I have understood that you are explaining.
But, are you sure, that download patch 4.0.2 => 4.0.11 to a chip with ROM 4.0.10 will be successful?
Most likely, it will be rejected, because of ROM difference. Because it is a patch. It is not a whole new firmware.
AFAIK, it is will be designed to make changes to 4.0.2 ROM only.

Here is more info, that i forgot to enclose last time. This is a verification constants:

#define Si2168A_ROM2_2_0_3_PART      68
#define Si2168A_ROM2_2_0_3_ROM      2
#define Si2168A_ROM2_2_0_3_PMAJOR   '2'
#define Si2168A_ROM2_2_0_3_PMINOR   '0'
#define Si2168A_ROM2_2_0_3_PBUILD   3

#define Si2168A_ROM3_3_0_2_PART      68
#define Si2168A_ROM3_3_0_2_ROM      3
#define Si2168A_ROM3_3_0_2_PMAJOR   '3'
#define Si2168A_ROM3_3_0_2_PMINOR   '0'
#define Si2168A_ROM3_3_0_2_PBUILD   2

#define Si2168B_ROM1_4_0_2_PART      68
#define Si2168B_ROM1_4_0_2_ROM      1
#define Si2168B_ROM1_4_0_2_PMAJOR   '4'
#define Si2168B_ROM1_4_0_2_PMINOR   '0'
#define Si2168B_ROM1_4_0_2_PBUILD   2

Here we can see here, that ROM from a chip vendor can come as:
PMAJOR   '2'
PMINOR   '0'
PBUILD   3
And not only 2.0.2, 3.0.2, 4.0.2 and so on.

Best regards.

