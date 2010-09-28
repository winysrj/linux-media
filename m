Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o8S8IGAh023780
	for <video4linux-list@redhat.com>; Tue, 28 Sep 2010 04:18:16 -0400
Received: from mail-bw0-f46.google.com (mail-bw0-f46.google.com
	[209.85.214.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8S8I4Uc010831
	for <video4linux-list@redhat.com>; Tue, 28 Sep 2010 04:18:05 -0400
Received: by bwz11 with SMTP id 11so5498690bwz.33
	for <video4linux-list@redhat.com>; Tue, 28 Sep 2010 01:18:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimYj-W2QPK6BZdkzCaQkyoWVsGuC1EX8w3Oo9MV@mail.gmail.com>
References: <AANLkTim6+hHaZqZNJHsQigEsy6c-mB83CKB2Dz6FmwzK@mail.gmail.com>
	<AANLkTimYj-W2QPK6BZdkzCaQkyoWVsGuC1EX8w3Oo9MV@mail.gmail.com>
Date: Tue, 28 Sep 2010 17:18:03 +0900
Message-ID: <AANLkTinXEzRhO3Y_qzq4MOBCtuJeXBXwLZ=T9-QAqPga@mail.gmail.com>
Subject: Re: TV Tuner Japan
From: Pike <pikewb@gmail.com>
To: Archis Bhave <archis.bhave@gmail.com>, video4linux-list@redhat.com
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

Thank you Archis,

I'm not sure about the courtesy with a mailing list, so I included v4l in
this mail.

Thank you for the quick reply!
I picked up a monster TV HDP2 gold the other day at the pc shop, and then I
tried to compile a linux kernel 2.16.1.1 with a patch from bytesex.org .. it
failed (since I'm so new to linux) , but if what you're saying is right,
then I don't need a patched kernel anyway. Other incarnations of the HDP
have all been on the saa7115 chipset I think.

Regardless, the monster HDP2 is not showing up in my system at all... not
with a lspci, lsusb, dmesg or anything... it's like a phantom piece of
machinery. As far as I know, if the system can't find it, then the odds of
me being able to use it are about 0 right?

Thanks for the help anyway!
Pike

On Tue, Sep 28, 2010 at 2:46 PM, Archis Bhave <archis.bhave@gmail.com>wrote:

> Pike
>
> Though some more inputs would be required (USB TV-Tuner, or PCI etc.) you
> should be able to get a TV tuner like UTV330+ from Gadmei (USB TV Tuner)
> working out of the box on almost all Linux distributions. I have tested it
> on Fedora 12 and Ubuntu 10.0x.
>
> It is usually a question of V4L driver being available for the TV tuner.
> Almost any card based on EM2860 and SAA7115 should work properly.
> Hope this helps.
>
> Sincerely
>
>
> On Sun, Sep 26, 2010 at 12:17 PM, Pike <pikewb@gmail.com> wrote:
>
>> I don't really know how to search the archives, but I'm browsing them
>> currently. In the meantime, I thought I'd ask if anyone has set-up a home
>> theatre PC in Japan recently and knows what TV tuner cards are supported
>> by
>> MythTV?
>>
>> cheers
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com
>> ?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
>
>
> --
> Mr. Archis A. Bhave
> [Design Engineer]
> [IDG Product Development]
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
