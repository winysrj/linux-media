Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53980 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2DUMSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 08:18:30 -0400
Received: by wejx9 with SMTP id x9so6573841wej.19
        for <linux-media@vger.kernel.org>; Sat, 21 Apr 2012 05:18:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ_iqtbVzU9zg_ERvhrbVr1vdgXXhyxJYdAmT0F1h_2ixP-==Q@mail.gmail.com>
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
	<4F6DDB10.8000503@redhat.com>
	<CAL9G6WUNp1gHibG74L8VXyJ0KPDYY+amKy3JZ7MBkjB8DBwERA@mail.gmail.com>
	<CALF0-+Uf=1tMKMtOJKEOLiHQ=brkW6JL67A5qtWSJ8uOM3ZfsA@mail.gmail.com>
	<4F8F13D8.5080407@redhat.com>
	<CAL9G6WVK=YKGOsB3VV_0B8RRvX0LnTNps1d=zTyV9mdfkirQ8g@mail.gmail.com>
	<CAJ_iqtbVzU9zg_ERvhrbVr1vdgXXhyxJYdAmT0F1h_2ixP-==Q@mail.gmail.com>
Date: Sat, 21 Apr 2012 14:18:29 +0200
Message-ID: <CAL9G6WVeXD99FOVNLJ+CVjPEiKrH9dNijM6Rb-G2uz8v_v_j-Q@mail.gmail.com>
Subject: Re: dvb lock patch
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Torfinn Ingolfsen <tingox@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/4/20 Torfinn Ingolfsen <tingox@gmail.com>:
> 2012/4/18 Josu Lazkano <josu.lazkano@gmail.com>:
>> El día 18 de abril de 2012 21:19, Mauro Carvalho Chehab
>> <mchehab@redhat.com> escribió:
>>> Em 18-04-2012 15:58, Ezequiel García escreveu:
>>>> Josu,
>>>>
>>>> On Tue, Apr 17, 2012 at 10:30 AM, Josu Lazkano <josu.lazkano@gmail.com> wrote:
>>>>> 2012/3/24 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>>> [snip]
>>>>>>
>>>>>> That doesn't sound right to me, and can actually cause race issues.
>>>>>>
>>>>>> Regards,
>>>>>> Mauro.
>>>>>
>>>>> Thanks for the patch Mauro.
>>>>>
>>>>
>>>> I think Mauro is *not* giving you a patch, rather the opposite:
>>>> pointing out that the patch can
>>>> cause problems!
>>>
>>> Yes. The driver will be unreliable with a patch like that, due to
>>> race conditions.
>>>
>>>> Regards,
>>>> Ezequiel.
>>>
>>> Regards,
>>> Mauro.
>>
>> Thanks anyway.
>>
>> I am looking for a solution to use virtual adapters on MythTV to use
>> my satellite provider card on two machines.
>> With 2.6.32 kernel is working great, but there is no way to work with
>> 3.x kernel.
>>
>> Is anyone using sasc-ng with latest kernel?
>>
>
> Would kernel 3.0.0.15 do?
> If so, descriptions on how I did it here:
> http://sites.google.com/site/tingox/digitaltv_sascng
> http://sites.google.com/site/tingox/asrock_e350m1_xubuntu
>
> Note: these are my work notes, not a how-to!
>
> As you can see, I'm using this patch:
> http://kipdola.be/subdomain/linux-2.6.38-dvb-mutex.patch
>
> It seems to work for me (had it running with Kaffeine on encrypted
> channesl for two weeks in a row)
>
> HTH
> --
> Regards,
> Torfinn Ingolfsen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Torfinn!

I get it working with modules compilation, that great!

apt-get install linux-source-3.2
cd /usr/src/
tar -xjvf linux-source-3.2.tar.bz2
cd linux-source-3.2/
wget http://kipdola.be/subdomain/linux-2.6.38-dvb-mutex.patch
patch -p1 linux-2.6.38-dvb-mutex.patch (I must do it manually, maybe
for the kernel version)
cp /boot/config-3.2.0-2-686-pae .config
cp ../linux-headers-3.2.0-2-686-pae/Module.symvers .
make oldconfig
make prepare
make scripts
make modules SUBDIRS=drivers/media/dvb/
cp drivers/media/dvb/dvb-core/dvb-core.ko
/lib/modules/3.2.0-2-686-pae/kernel/drivers/media/dvb/dvb-core/
(reboot)

I am not software developer and I have no idea what means "race
conditions", is this sasc-ng or linux driver "problem"?

It will be great to fix it and not patch the driver anymore, but I am
happy with this solution (module compilation).

Thanks and best regards.

-- 
Josu Lazkano
