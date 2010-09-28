Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o8S8v8s7023887
	for <video4linux-list@redhat.com>; Tue, 28 Sep 2010 04:57:08 -0400
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.214.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8S8uvtC022193
	for <video4linux-list@redhat.com>; Tue, 28 Sep 2010 04:56:57 -0400
Received: by iwn5 with SMTP id 5so7277329iwn.33
	for <video4linux-list@redhat.com>; Tue, 28 Sep 2010 01:56:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinXEzRhO3Y_qzq4MOBCtuJeXBXwLZ=T9-QAqPga@mail.gmail.com>
References: <AANLkTim6+hHaZqZNJHsQigEsy6c-mB83CKB2Dz6FmwzK@mail.gmail.com>
	<AANLkTimYj-W2QPK6BZdkzCaQkyoWVsGuC1EX8w3Oo9MV@mail.gmail.com>
	<AANLkTinXEzRhO3Y_qzq4MOBCtuJeXBXwLZ=T9-QAqPga@mail.gmail.com>
Date: Tue, 28 Sep 2010 14:26:56 +0530
Message-ID: <AANLkTimzZkhr4Jyab-QaXHzgd2_MRHgdKGFYUNEiYOkw@mail.gmail.com>
Subject: Re: TV Tuner Japan
From: Archis Bhave <archis.bhave@gmail.com>
To: Pike <pikewb@gmail.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Pike


 Which Linux are you using? Debian? Trying out older kernels (2.16 is really
old, the current running tree is 2.6.xx) is usually a bad idea for media
devices like TV-cards. Of course I am no Linux Guru, but it has been my
experience, that there is more chance of media devices working with newer
kernel releases.

And if you have no grudges against Ubuntu or problems regarding its use,
switching to Ubuntu would also be a nice idea from point of view of ease of
use. Personally I'm using Fedora 12 with Gadmei UTV330+ on USB at home and a
cheap PCI card with similar chipsets at office.

Archis

On Tue, Sep 28, 2010 at 1:48 PM, Pike <pikewb@gmail.com> wrote:

> Thank you Archis,
>
> I'm not sure about the courtesy with a mailing list, so I included v4l in
> this mail.
>
> Thank you for the quick reply!
> I picked up a monster TV HDP2 gold the other day at the pc shop, and then I
> tried to compile a linux kernel 2.16.1.1 with a patch from bytesex.org ..
> it failed (since I'm so new to linux) , but if what you're saying is right,
> then I don't need a patched kernel anyway. Other incarnations of the HDP
> have all been on the saa7115 chipset I think.
>
> Regardless, the monster HDP2 is not showing up in my system at all... not
> with a lspci, lsusb, dmesg or anything... it's like a phantom piece of
> machinery. As far as I know, if the system can't find it, then the odds of
> me being able to use it are about 0 right?
>
> Thanks for the help anyway!
> Pike
>
>
> On Tue, Sep 28, 2010 at 2:46 PM, Archis Bhave <archis.bhave@gmail.com>wrote:
>
>> Pike
>>
>> Though some more inputs would be required (USB TV-Tuner, or PCI etc.) you
>> should be able to get a TV tuner like UTV330+ from Gadmei (USB TV Tuner)
>> working out of the box on almost all Linux distributions. I have tested it
>> on Fedora 12 and Ubuntu 10.0x.
>>
>> It is usually a question of V4L driver being available for the TV tuner.
>> Almost any card based on EM2860 and SAA7115 should work properly.
>> Hope this helps.
>>
>> Sincerely
>>
>>
>> On Sun, Sep 26, 2010 at 12:17 PM, Pike <pikewb@gmail.com> wrote:
>>
>>> I don't really know how to search the archives, but I'm browsing them
>>> currently. In the meantime, I thought I'd ask if anyone has set-up a home
>>> theatre PC in Japan recently and knows what TV tuner cards are supported
>>> by
>>> MythTV?
>>>
>>> cheers
>>> --
>>> video4linux-list mailing list
>>> Unsubscribe mailto:video4linux-list-request@redhat.com
>>> ?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>
>>
>>
>> --
>> Mr. Archis A. Bhave
>> [Design Engineer]
>> [IDG Product Development]
>>
>
>


-- 
Mr. Archis A. Bhave
[Design Engineer]
[IDG Product Development]
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
