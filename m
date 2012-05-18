Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da05.mx.aol.com ([205.188.105.147]:63979 "EHLO
	imr-da05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413Ab2EROSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 10:18:11 -0400
Received: from mtaout-db06.r1000.mx.aol.com (mtaout-db06.r1000.mx.aol.com [172.29.51.198])
	by imr-da05.mx.aol.com (8.14.1/8.14.1) with ESMTP id q4IEI6xX016011
	for <linux-media@vger.kernel.org>; Fri, 18 May 2012 10:18:06 -0400
Received: from [192.168.1.35] (unknown [190.50.55.118])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-db06.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 9DA8AE0000E3
	for <linux-media@vger.kernel.org>; Fri, 18 May 2012 10:18:05 -0400 (EDT)
Message-ID: <4FB65975.3000806@netscape.net>
Date: Fri, 18 May 2012 11:15:17 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: How I must report that a driver has been broken?
References: <4FADE682.3090005@netscape.net>	<4FAE1CA1.1010203@redhat.com>	<4FAEB948.7080800@netscape.net>	<4FAF4BBA.9090904@redhat.com> <CAGoCfiyumZmX8PkPU_UQee4kpd82OBKF=1awLAmuL1WOcE=buQ@mail.gmail.com>
In-Reply-To: <CAGoCfiyumZmX8PkPU_UQee4kpd82OBKF=1awLAmuL1WOcE=buQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Thank you all for your responses.

Devin, I appreciate the time and labor you do to revise the code.

My previous letters maybe I can help you see where the problem and the 
date you began.
I thought of a patch of this type:

if (card != mycard) {

"bad code for my card"}

but unfortunately not so easy for me.


I will be patient.

Thank you.


Alfredo


El 14/05/12 01:51, Devin Heitmueller escribió:
> On Sun, May 13, 2012 at 1:50 AM, Hans de Goede<hdegoede@redhat.com>  wrote:
>> Hi,
>>
>>
>> On 05/12/2012 09:26 PM, Alfredo Jesús Delaiti wrote:
>>> Hi
>>>
>>> Thanks for your response Hans and Patrick
>>>
>>> Maybe I doing wrong this, because it reports twice:
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg45199.html
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44846.html
>>
>> In your last message you indicate that you've found the patch causing it,
>> and that you were looking into figuring which bit of the patch actually
>> breaks things, so I guess people reading the thread were / are
>> waiting for you to follow up on it with the results of your attempts
>> to further isolate the cause.
>>
>> What I were do if I were you is send a mail directly to the author
>> of the patch causing the problems, with what you've discovered
>> about the problem sofar in there, and put the list in the CC.
>>
>> Regards,
>>
>> Hans
> Steven loaned me his HVR-1850 board last week, and I'm hoping to debug
> the regression this week (I have an HVR-1800 that is also effected).
> I suspect the problem is related to a codepath for the cx23888's
> onboard DIF being executed for 885 based boards.  Steven did a whole
> series of patches to make the cx23888 work properly and I think a
> regression snuck in there.  Simply backing out the change isn't the
> correct fix.
>
> I've got all the boards and the datasheets - I just need to find a bit
> of time to get the current tree installed onto a machine and plug in
> the various boards...
>
> In short, it's in my queue so please be patient.
>
> Devin
>


-- 
Dona tu voz
http://www.voxforge.org/es

