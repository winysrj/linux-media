Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0CSW3h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 18:29:37 -0400
Message-ID: <4BA3FABD.5070604@redhat.com>
Date: Fri, 19 Mar 2010 19:29:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: add support for one more remote control for
 Avermedia M135A
References: <201003191455.46559.herton@mandriva.com.br> <4BA3F329.3010702@redhat.com> <201003191925.38256.herton@mandriva.com.br>
In-Reply-To: <201003191925.38256.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Sex 19 Mar 2010, às 18:56:57, Mauro Carvalho Chehab escreveu:
>> Hi Herton,
>>
>> Herton Ronaldo Krzesinski wrote:
>>> This change adds support for one more remote control type for Avermedia
>>> M135A. The new remote control reports slightly different codes, and was
>>> necessary to extend the mask_keycode to differentiate between original
>>> remote control. One of the remote controls I had matched the original
>>> binding, but some keys reported duplicated codes, probably because the
>>> previous mask_keycode missing valid bits, so this should fix also
>>> original remote control support ("The keys bellow aren't ok" comment).
>> It would be a way better to extend it to use the full address+command scancode
>> (16 bits, being 13 or 14 used). This would allow using this board with
>> universal IR's and other third party ones.
>>
>> That's said, I have one of such board here, with one IR control (mine has the
>> small control labaled RM-JX).
>>
>> As I have some things to do with IR core support, I'll do some tests in order
>> to extend the IR support on saa7134 in order to get the full IR code and remap
>> this IR.
> 
> Ok, when you have done it feel free to ask me to test any patches you have
> etc., my control is labeled RM-K6, supplied by Avermedia I suppose to Positivo
> (this controler comes with Positivo "PC-TV" machine with Avermedia card) , and
> the original IR control unfortunately I don't have anymore here to test. I
> suppose there would be more control types as well which Avermedia ships...

I had once one of those "Positivo" IR's from Avermedia. Yes, for sure there are more
IR's. By doing it right, replacing the IR map will be just a matter of calling
ir-keycode application, from v4l-utils (assuming the latest V4L/DVB drivers with the
proper /sys/class/irrcv nodes).

-- 

Cheers,
Mauro
