Return-path: <linux-media-owner@vger.kernel.org>
Received: from pitbull.cosy.sbg.ac.at ([141.201.2.122]:47991 "EHLO
	pitbull.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab2CSIqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 04:46:37 -0400
Cc: Bob W <bob.news@non-elite.com>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Marek Ochaba <ochaba@maindata.sk>
Message-Id: <2FB3FA12-CAFE-4558-9935-1AF14D44DFA9@cosy.sbg.ac.at>
From: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
To: linux-media@vger.kernel.org
In-Reply-To: <A7A0A9AB-3D94-4152-B66D-DDBBF7AE5CAC@cosy.sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: DVB-S2 multistream support
Date: Mon, 19 Mar 2012 09:46:35 +0100
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org> <CAF0Ff2mf0tYs3UG3M6Cahep+_kMToVaGgPhTqR7zhRG0UXWuig@mail.gmail.com> <85A7A8FC-150C-4463-B09C-85EED6F851A8@cosy.sbg.ac.at> <CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com> <CAB0B130-3B08-41B4-920A-C54058C43AEE@cosy.sbg.ac.at> <CAF0Ff2kF3VCL4PomOo5zBBrZSPmPvGd9qSZ+XwSp7ALJmq3+kw@mail.gmail.com> <78E6697C-BD32-4062-BC2C-A5F7D0CBD79C@cosy.sbg.ac.at> <CAF0Ff2nCz114LEJFRXy+L7Yq-uD4+sJeHOzNSk=28V_qgbta7A@mail.gmail.com> <loom.20120307T170824-19@post.gmane.org> <CAF0Ff2n1wj5LTu935sR6jxYP8ncHHEA=f6urs8+QKcD2Zd04zg@mail.gmail.com> <4F5F6C2D.1080206@non-elite.com> <A7A0A9AB-3D94-4152-B66D-DDBBF7AE5CAC@cosy.sbg.ac.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I decided to post a patch against the TBS drivers for all those who  
want to experiment
with the very preliminary base-band demultiplexer until I have a  
repository to properly host
this stuff. Currently it only works for the
TBS 6925 card. The bb-dmx was created for Linux v3.3, so the patch  
also contains some
changes that made it into Linux since TBS driver release v111118. You  
can get the TBS source
code via this direct link (I know there's a newer version but the  
patch is against the old driver package):

http://www.tbsdtv.com/download/document/common/tbs-linux-drivers_v111118.zip

And then you can download the bb-dmx patch from here:

http://www.cosy.sbg.ac.at/~cpraehaus/download/tbs_v111118_bb-dmx_2012-03-19.patch.gz


Tuning and configuration of the card is as normal, notice however that  
the card is currently
put in base-band data mode irrespective of any configuration. This  
means that you probably wont
be able to receive DVB-S.

To test the bb-dmx support, there is a patch against dvbsnoop 1.4.5.  
You can get the source from the SF site:

http://dvbsnoop.sourceforge.net/

and the patch from here:

http://www.cosy.sbg.ac.at/~cpraehaus/download/dvbsnoop-1.4.50_bb-dmx_2012-03-19.patch

Usage:
dvbsnoop -s bb <ISI>	(receive bbframes from <ISI>)

dvbsnoop -s bb -tsraw	(receive everything)


Sorry, its still all very experimental and DVB-S2 specific, but I'd be  
happy to get feedback from those interested.
Thanks and kind regards,
Christian.


Am 15.03.2012 um 10:40 schrieb Christian Prähauser:

> Dear all,
>
> First, thanks for your interest in this functionality. I think the  
> modifications
> are in a shape where they begin to be useful for others. Currently
> I'm (still) trying to get some GIT repo where I can host the whole  
> stuff.
>
> Thank you all for your support, testing will indeed by important  
> after the first
> version is "in the wild" :-). I definitely want to keep this going  
> and be sure
> that I tell you as soon as the code can be accessed.
>
> Kind regards,
> Christian.
>
> Am 13.03.2012 um 16:47 schrieb Bob W:
>
>>
>>
>> Hi Konstantin,
>>
>>
>>> all work to support BBFrames in the Linux kernel is done by  
>>> Christian
>>> - in fact it's a long lost work from 5 years ago:
>>>
>>> http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022217.html
>>
>> yep, I have followed the history back...  and like Christian said,  
>> the
>> old repo is nolonger working.  :(
>>
>>>
>>> and i hope it won't be lost again. i just encouraged Christian that
>>> his work is important and there are people interested in it - you're
>>> one such example. so, i offered Christian to help him with i can. i
>>> guess more people appreciating what his doing and encourage him will
>>> give him better motivation to release the code to the public.  
>>> however,
>>> i guess the delay is more, because it's not easy and it requires  
>>> time
>>> to prepare the code for initial public release and that's why the
>>> delay. so, i don't have Christian's code and i'm eager as you're  
>>> to be
>>> able to try it out, but we need to be patient. i'm sure that after
>>> there is some public release and repository more people will be
>>> interested to contribute to that work.
>>>
>>> best regards,
>>> konstantin
>>
>>
>> Agreed, I understand the pressure of releasing publicly.  Once  
>> released,
>> the nit picking begins.. lol.   I will keep watch on the list.
>> Christian, if you want an extra tester to help yah, count me in.   
>> I'll
>> help also with what I can.
>>
>> Bob
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> ---
> Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>
>
> || //\\//\\ || Multimedia Communications Group,
> ||//  \/  \\|| Department of Computer Sciences, University of Salzburg
> http://www.cosy.sbg.ac.at/~cpraehaus/
> http://www.network-research.org/
> http://www.uni-salzburg.at/
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

---
Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>

|| //\\//\\ || Multimedia Communications Group,
||//  \/  \\|| Department of Computer Sciences, University of Salzburg
http://www.cosy.sbg.ac.at/~cpraehaus/
http://www.network-research.org/
http://www.uni-salzburg.at/
