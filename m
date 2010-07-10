Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6ABcJ5Y020868
	for <video4linux-list@redhat.com>; Sat, 10 Jul 2010 07:38:19 -0400
Received: from mail-fx0-f46.google.com (mail-fx0-f46.google.com
	[209.85.161.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6ABc81Z011547
	for <video4linux-list@redhat.com>; Sat, 10 Jul 2010 07:38:09 -0400
Received: by fxm14 with SMTP id 14so1698891fxm.33
	for <video4linux-list@redhat.com>; Sat, 10 Jul 2010 04:38:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278719339.6252.21.camel@pc07.localdom.local>
References: <AANLkTikDO_YDvP6Bot0WW3259dYDvwnJsiLz83erXDji@mail.gmail.com>
	<1278719339.6252.21.camel@pc07.localdom.local>
Date: Sat, 10 Jul 2010 13:38:07 +0200
Message-ID: <AANLkTil5VwPuhqXUrfYY2xpJOauMRDJnOLkltgRR7eoj@mail.gmail.com>
Subject: Re: saa7231 Help
From: Simon Appleby <v12diablo@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
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
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

>> Hi,
>>
>> First time posting on this list, I am hoping someone will be able to help.
>>
>> I have a compro S800F Hybrid tuner card which which has a saa7231,
>> which I would like to get working for my MythTV box. I have found the
>> drivers at http://www.jusst.de/hg/saa7231/ but they are incomplete.
>> After a few hours of hacking around I have managed to get the card
>> recognised by the Kernel (2.6.32), and have succesfully gotten
>> /dev/video0 showing up, as well as the I2C communication returning
>> sensible looking data.
>> I was wondering if anyone has any info or data on this device they
>> could share? My queries to NXP, Trident and Manu Abraham have so far
>> gone unanswered. Im sort of fumbling around in the dark with a lot of
>> the chips hardware.
>>
>> Regards
>>
>> Simon Appleby
>>
>
> it is really only Manu who can give an updated status report.
>
> Beside all previous conflicts about the v4l maintainer and how far he is
> allowed to care about regular syncing of the v4l and dvb trees in the
> past, greatly improved by trolls, the best support we can give to move
> things forward is to declare this won't happen again on the saa7231 I
> think.
>
> Last i had is, Manu is requiring more samples of such devices
> successfully. Hartmut also declared to help on the analog front with
> somehow limited means now and he was surprised how much support Manu has
> already. Manu also tries to get NDAs for not yet included
> demodulator/tuner combinations.
>
> IIRC, there are some remaining issues, concerning that GNU/Linux should
> not be treated like just another OEM.
>
> We should back up Manu here, means also to stop individual queries to
> NXP and Trident to assure this.
>
> If somebody is against this, please speak up.
>
> Cheers,
> Hermann


Hi Hermann,

Thanks for the reply. I will wait until Manu has something new to
share. In the meantime, if there is anything I can do to assist or
help then please let me know.

Best Regards

Simon Appleby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
