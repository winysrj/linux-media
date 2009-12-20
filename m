Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57794 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZLTQGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 11:06:11 -0500
Received: by ewy1 with SMTP id 1so5456549ewy.28
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 08:06:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260006310.3702.3.camel@desktop>
References: <1259695756.5239.2.camel@desktop> <loom.20091202T230047-299@post.gmane.org>
	<37219a840912021508s75535fa6v83006d3bad0c301@mail.gmail.com>
	<1259874920.2151.13.camel@desktop> <41ef408f0912031347j6b9a704flc6d9c302f4e0517@mail.gmail.com>
	<829197380912031403l6b828821q87f407fa95bc25f9@mail.gmail.com>
	<37219a840912041003o4d8ebe27wbe3f1c47f55ba7dc@mail.gmail.com>
	<1260006310.3702.3.camel@desktop>
From: Bert Massop <bert.massop@gmail.com>
Date: Sun, 20 Dec 2009 17:05:48 +0100
Message-ID: <41ef408f0912200805id69e15ao13936c62ff23417d@mail.gmail.com>
Subject: Re: af9015: tuner id:179 not supported, please report!
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Using some usb replay tools used for making the pvrusb2 work, I am
able to receive a working MPEG-TS stream, after snooping communication
in Windows. It's an ugly way to make things work, but now I'm able to
watch television in VLC. It's limited to 758MHz @ 8000KHz, thought,
because I only ran an usbsnoop for that specific frequency.

So right now I'm able to write the TS stream into a pipe / stdout /
file, but creating a (fixed frequency) driver for v4l is way too
complicated for me, at the moment. I don't really understand how the
v4l dvb drivers work, probably because I'm not really experienced in
doing so ;-) Currently, I'm trying to understand how frequency
selection works with this chip, and I'll be making a standalone
application to save the TS stream. Then, maybe someone else can write
a proper v4l driver for this chip.

Regards,
Bert

On Sat, Dec 5, 2009 at 10:45, Jan Sundman <jan.sundman@aland.net> wrote:
> Hi,
>
> Thanks for the info, I will have a look and see if it is worth the
> trouble.
>
> Br,
>
> // Jan
>
> On Fri, 2009-12-04 at 13:03 -0500, Michael Krufky wrote:
>> On Thu, Dec 3, 2009 at 5:03 PM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>> > On Thu, Dec 3, 2009 at 4:47 PM, Bert Massop <bert.massop@gmail.com> wrote:
>> >> Hi Jan,
>> >>
>> >> The datasheet for the TDA18218 can be obtained from NXP:
>> >> http://www.nxp.com/documents/data_sheet/TDA18218HN.pdf
>> >>
>> >> That's all the information I have at the moment, maybe Mike has some
>> >> other information (like the Application Note mentioned in the
>> >> datasheet, that claims to contain information on writing drivers, but
>> >> cannot be found anywhere).
>> >>
>> >> Best regards,
>> >>
>> >> Bert
>> >
>> > Took a quick look at that datasheet.  I would guess between that
>> > datasheet and a usbsnoop, there is probably enough there to write a
>> > driver that basically works for your particular hardware if you know
>> > what you are doing.  The register map is abbreviated, but probably
>> > good enough...
>> >
>> > Devin
>>
>> The datasheet is missing too much important information needed to
>> write a fully featured driver for the part, and I wouldn't recommend
>> using a usbsnoop for this type of tuner, but be my guest and prove me
>> wrong.
>>
>> You might be able to get it working, but you'll end up with tons of
>> binary blobs hardcoded for each frequency, unless you use a
>> programming guide.  Unfortunately, I don't have one that I can share
>> :-/
>>
>> I think you would be much better off purchasing supported hardware, instead.
>>
>> Good luck, though...
>>
>> -Mike
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
