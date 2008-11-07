Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7DknEO002563
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 08:46:49 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7DkO6e008453
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 08:46:24 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1000795fga.7
	for <video4linux-list@redhat.com>; Fri, 07 Nov 2008 05:46:23 -0800 (PST)
Message-ID: <c41ce8440811070546v77ec6a5dn748991ecd9062f@mail.gmail.com>
Date: Fri, 7 Nov 2008 14:46:23 +0100
From: picciuX <matteo@picciux.it>
To: video4linux-list@redhat.com
In-Reply-To: <1226016428.19661.24.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c41ce8440810310231gdb614bcred3f4386de883abb@mail.gmail.com>
	<1225586521.2642.7.camel@pc10.localdom.local>
	<c41ce8440811040609v591ae268y80d6669dccf55862@mail.gmail.com>
	<1225930171.3338.8.camel@pc10.localdom.local>
	<1225932395.13472.19.camel@frolic>
	<1225936613.3602.24.camel@pc10.localdom.local>
	<1226016428.19661.24.camel@pc10.localdom.local>
Subject: Re: Pinnacle PCTV 310i Remote: i2c 'ERROR: NO_DEVICE'
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I don't actually know how to test if mine is really different from any
previous PCTV310i Board with same IDs, because I have only this.
What makes me think about that is, as said, that I found (don't
remember where) a report af a user who buyed two cards at different
times (six month one after the other) and the first worked, while the
second didn't. Moreover, now the board is named "PCTV Hybrid Pro PCI",
but has same PCI IDs of PCTV310i. But, again, I have no way of
discovering differences, because I own only this board.
Anyway, I will do whichever test you want, if I'm able to. Just don't
ask me to test the remote on Windows...

And, for Ricardo, I have only ONE board in the system, and ir-kbd-i2c reports

ir-kbd-i2c: probe 0x7a @ saa7133[0]: no
ir-kbd-i2c: probe 0x47 @ saa7133[0]: yes

but the problem is still there.

Could be same of Asus? How can I test something more?

thank you very much.

matteo


2008/11/7 hermann pitton <hermann-pitton@arcor.de>:
> Hi,
>
> Am Donnerstag, den 06.11.2008, 02:56 +0100 schrieb hermann pitton:
>> Hi Ricardo,
>>
>> Am Donnerstag, den 06.11.2008, 00:46 +0000 schrieb Ricardo Cerqueira:
>> > Hi all;
>> >
>> > On Thu, 2008-11-06 at 01:09 +0100, hermann pitton wrote:
>> > > Hi Matteo,
>> > >
>> > > Am Dienstag, den 04.11.2008, 15:09 +0100 schrieb picciuX:
>> > > > 2008/11/2 hermann pitton <hermann-pitton@arcor.de>:
>> > > >
>> > > > > don't have that remote, but also enable ir-kbd-i2c debug=1.
>> > > > >
>> > > > > ir-kbd-i2c: probe 0x7a @ saa7133[0]: no
>> > > > > ir-kbd-i2c: probe 0x47 @ saa7133[0]: no
>> > > > > ir-kbd-i2c: probe 0x71 @ saa7133[0]: no
>> > > > > ir-kbd-i2c: probe 0x2d @ saa7133[0]: no
>> > > > > ir-kbd-i2c: probe 0x7a @ saa7133[1]: no
>> > > > > ir-kbd-i2c: probe 0x47 @ saa7133[1]: no
>> > > > > ir-kbd-i2c: probe 0x71 @ saa7133[1]: no
>> > > > > ir-kbd-i2c: probe 0x2d @ saa7133[1]: no
>> > > > >
>> >
>> >
>> > Sorry, I missed the rest of the thread;
>> >
>> > In any case, from the above paste, it looks as if you have 2 saa713x
>> > boards in the system, right?
>>
>> sorry, that was me to illustrate how the difference should look like.
>> Must be taken from the quadro md8800 machine.
>>
>> I'm playing around with some other requests concerning remote behaviors,
>> but have to admit that getting some old PCs running on recent again is
>> not that much fun and I'm slow.
>>
>> We have a case, where Asus stuff is not reliable on PCI subsystem IDs.
>> We can detect the different cards by a difference in the eeprom readout,
>> but this needs running i2c on saa7134 init2.
>>
>> However, since input_init is on saa7134 init1, we fail here being too
>> late. Maybe we should have input init on saa7134 init2 in saa7134-core.
>> Roman with such a card mailed to me about that. At least I should be
>> close to be able to test it, but no i2c remote stuff is here.
>
> sorry, it is a little OT and only this P7131 Analog card is affected,
> which needs to be eeprom detected to work around a duplicate PCI
> subsystem for physically different cards.
>
> The wrongly detected card has an USB remote by the way, so in case of
> auto detection it will come up without working Asus PC-39 IRQ remote.
> If the card number is forced, the remote will work too.
>
> Roman seems to suggest a patch, which basically boils down to this.
>
> diff -r b45ffc93fb82 linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Wed Nov 05 00:59:37 2008 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Mon Nov 03 16:52:17 2008 +0100
> @@ -6307,6 +6307,7 @@ int saa7134_board_init2(struct saa7134_d
>                       printk(KERN_INFO "%s: P7131 analog only, using "
>                                                       "entry of %s\n",
>                       dev->name, saa7134_boards[dev->board].name);
> +                      dev->has_remote = SAA7134_REMOTE_GPIO;
>               }
>               break;
>        case SAA7134_BOARD_HAUPPAUGE_HVR1110:
> diff -r b45ffc93fb82 linux/drivers/media/video/saa7134/saa7134-core.c
> --- a/linux/drivers/media/video/saa7134/saa7134-core.c  Wed Nov 05 00:59:37 2008 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-core.c  Mon Nov 03 16:44:54 2008 +0100
> @@ -729,7 +729,6 @@ static int saa7134_hwinit1(struct saa713
>        saa7134_vbi_init1(dev);
>        if (card_has_mpeg(dev))
>                saa7134_ts_init1(dev);
> -       saa7134_input_init1(dev);
>
>        saa7134_hw_enable1(dev);
>
> @@ -775,6 +774,7 @@ static int saa7134_hwinit2(struct saa713
>
>        dprintk("hwinit2\n");
>
> +       saa7134_input_init1(dev);
>        saa7134_video_init2(dev);
>        saa7134_tvaudio_init2(dev);
>
> This seems to work for him and also no trouble on a normal gpio remote,
> but I can't test on saa7134 i2c remotes.
>
> Since this is only for that one card for now and the trouble seems to be
> caused by the manufacturer, maybe to print use card=number to get also
> the remote up would be sufficient, but I post it here just in case we'll
> get more of this in the future.
>
> Cheers,
> Hermann
>
>> > I suspect the bug is somehow related to that (ir-kbd-i2c is getting the
>> > events, but sending them to the wrong board). Have you tried removing
>> > one of them?
>>
>> Maybe the card is even flaky in the PCI slot, that's why a second
>> confirmation would be nice.
>>
>> Thanks,
>> Hermann
>>
>> > --
>> > RC
>> > > > > You should have the device found at 0x47.
>> > > > >
>> > > >
>> > > > In fact i see:
>> > > >
>> > > > ir-kbd-i2c: probe 0x47 @ saa7133[0]: yes
>> > > >
>> > > > So everything seemed to go well. But, same story for the rest: ERROR:
>> > > > NO_DEVICE when i press buttons on the remote.
>> > > > What seems strange to me is the fact that the driver *reacts* to
>> > > > remote key presses, but reacts with an error.
>> > > >
>> > > > Cheers
>> > > > Matteo
>> > > >
>> > >
>> > > since you reported the trouble was already visible for you on earlier
>> > > kernels, we might try to get a second confirmation at first.
>> > >
>> > > Anyone out there? I'm sending a copy to Ricardo too, who added the
>> > > support, not sure if he currently has time to read the list.
>> > >
>> > > Cheers,
>> > > Hermann
>> > >
>>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
