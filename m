Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb05fl.versatel.de ([89.246.255.248]:35029 "EHLO
	mxweblb05fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0BGUgj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 15:36:39 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb05fl.versatel.de (8.13.1/8.13.1) with ESMTP id o17Kabqk032114
	for <linux-media@vger.kernel.org>; Sun, 7 Feb 2010 21:36:37 +0100
Received: from cinnamon-sage.de (i577A53FE.versanet.de [87.122.83.254])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o17KabEj023436
	for <linux-media@vger.kernel.org>; Sun, 7 Feb 2010 21:36:37 +0100
Received: from 192.168.23.2:49634 by cinnamon-sage.de for <hverkuil@xs4all.nl>,<awalls@radix.net>,<linux-media@vger.kernel.org> ; 07.02.2010 21:36:37
Message-ID: <4B6F2455.4040001@cinnamon-sage.de>
Date: Sun, 07 Feb 2010 21:36:37 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: ivtv-utils/test/ps-analyzer.cpp: error in extracting SCR?
References: <4B6A123F.5080500@cinnamon-sage.de> <1265253363.3122.106.camel@palomino.walls.org> <201002040825.32062.hverkuil@xs4all.nl>
In-Reply-To: <201002040825.32062.hverkuil@xs4all.nl>
Content-Type: multipart/mixed;
 boundary="------------080700040607010207000504"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080700040607010207000504
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

  Just for completeness, attached is the patch against the subversion 
repository at ivtvdriver.org.

Regards,
Lars.

Am 04.02.2010 08:25, schrieb Hans Verkuil:
> On Thursday 04 February 2010 04:16:03 Andy Walls wrote:
>> On Thu, 2010-02-04 at 01:18 +0100, Lars Hanisch wrote:
>>> Hi,
>>>
>>>    I'm writing some code repacking the program stream that ivtv delivers
>>> into a transport stream (BTW: is there existing code for this?).
>>
>> Buy a CX23418 based board.  That chip's firmware can produce a TS.
>>
>> I think Compro and LeadTek cards are available in Europe and are
>> supported by the cx18 driver.
>>
>>>   Since
>>> many players needs the PCR I would like to use the SCR of the PS and
>>> place it in the adaption field of the TS (if wikipedia [1] and my
>>> interpretation of it is correct it should be the same).
>>>
>>>    I stumbled upon the ps-analyzer.cpp in the test-directory of the
>>> ivtv-utils (1.4.0). From line 190 to 198 the SCR and SCR extension are
>>> extracted from the PS-header. But referring to [2] the SCR extension has
>>> 9 bits, the highest 2 bits in the fifth byte after the sync bytes and
>>> the lower 7 bits in the sixth byte. The last bit is a marker bit (always 1).
>>>
>>>    So instead of
>>>
>>> scr_ext = (hdr[4]&  0x1)<<  8;
>>> scr_ext |= hdr[5];
>>>
>>>    I think it should be
>>>
>>> scr_ext = (unsigned)(hdr[4]&  0x3)<<  7;
>>> scr_ext |= (hdr[5]&  0xfe)>>  1;
>>
>>
>> Given the non-authoritative MPEG-2 documents I have, yes, you appear to
>> be correct on this.
>>
>> Please keep in mind that ps-analyzer.cpp is simply a debug tool from an
>> ivtv developer perspective.  You base prodcution software off of it at
>> your own risk. :)
>>
>>>    And the bitrate is coded in the next 22 bits, so it should be
>>>
>>> mux_rate = (unsigned)(hdr[6])<<  14;
>>> mux_rate |= (unsigned)(hdr[7])<<  6;
>>> mux_rate |= (unsigned)(hdr[8]&  0xfc)>>  2;
>>>
>>>    Am I correct?
>
> Yes, you are correct. I miscounted the bits when I wrote this originally.
> Thanks for reporting this!
>
> Regards,
>
> 	Hans
>
>>
>> I did not check this one, but I would not be surprised if ps-analyzer
>> had this wrong too.
>>
>> Regards,
>> Andy
>>
>>> Regards,
>>> Lars.
>>>
>>> [1] http://en.wikipedia.org/wiki/Presentation_time_stamp
>>> [2] http://en.wikipedia.org/wiki/MPEG_program_stream
>>> --
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>


--------------080700040607010207000504
Content-Type: text/plain;
 name="ps-analyzer-corrected_scr_muxrate.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ps-analyzer-corrected_scr_muxrate.diff"

SW5kZXg6IHRlc3QvcHMtYW5hbHl6ZXIuY3BwDQo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gdGVzdC9w
cy1hbmFseXplci5jcHAJKFJldmlzaW9uIDQxNTIpDQorKysgdGVzdC9wcy1hbmFseXplci5j
cHAJKEFyYmVpdHNrb3BpZSkNCkBAIC0xOTQsMTEgKzE5NCwxMSBAQA0KIAlzY3IgfD0gKHU2
NCkoaGRyWzJdICYgMykgPDwgMTM7CiAJc2NyIHw9ICh1NjQpaGRyWzNdIDw8IDU7CiAJc2Ny
IHw9ICh1NjQpKGhkcls0XSAmIDB4ZjgpID4+IDM7Ci0Jc2NyX2V4dCA9IChoZHJbNF0gJiAw
eDEpIDw8IDg7Ci0Jc2NyX2V4dCB8PSBoZHJbNV07Ci0JbXV4X3JhdGUgPSAoaGRyWzZdICYg
MHg3ZikgPDwgMTU7Ci0JbXV4X3JhdGUgfD0gaGRyWzddIDw8IDc7Ci0JbXV4X3JhdGUgfD0g
KGhkcls4XSAmIDB4ZmUpID4+IDE7CisJc2NyX2V4dCA9ICh1bnNpZ25lZCkoaGRyWzRdICYg
MHgzKSA8PCA3OworCXNjcl9leHQgfD0gKGhkcls1XSAmIDB4ZmUpID4+IDE7CisJbXV4X3Jh
dGUgPSAodW5zaWduZWQpKGhkcls2XSkgPDwgMTQ7CisJbXV4X3JhdGUgfD0gKHVuc2lnbmVk
KShoZHJbN10pIDw8IDY7CisJbXV4X3JhdGUgfD0gKHVuc2lnbmVkKShoZHJbOF0gJiAweGZj
KSA+PiAyOwogCWlmIChnX3ZlcmJvc2UpCiAJCXByaW50ZigiJWxsZDogcGFjayBzY3I9JWxs
ZCBzY3JfZXh0PSUzdSBzY3I9JWxsZCBucyBtdXhfcmF0ZT0ldVxuIiwgcG9zLCBzY3IsIHNj
cl9leHQsIHNjcjJucyhzY3IsIHNjcl9leHQpLCBtdXhfcmF0ZSk7CiAK
--------------080700040607010207000504--
