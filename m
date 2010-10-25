Return-path: <mchehab@pedra>
Received: from gateway14.websitewelcome.com ([70.85.130.16]:34625 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752873Ab0JYH2J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 03:28:09 -0400
Received: from [74.125.83.46] (port=55969 helo=mail-gw0-f46.google.com)
	by gator1121.hostgator.com with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.69)
	(envelope-from <demiurg@femtolinux.com>)
	id 1PAHK8-0001Kn-Lj
	for linux-media@vger.kernel.org; Mon, 25 Oct 2010 02:18:33 -0500
Received: by gwj21 with SMTP id 21so2262589gwj.19
        for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 00:18:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <130335.5569.qm@web25404.mail.ukl.yahoo.com>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
	<201010242055.30799.albin.kauffmann@gmail.com>
	<AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com>
	<AANLkTinVas23b2ZMuBxzdY6PUP-4JEMchNup9nSpxsf3@mail.gmail.com>
	<130335.5569.qm@web25404.mail.ukl.yahoo.com>
Date: Mon, 25 Oct 2010 09:18:28 +0200
Message-ID: <AANLkTi=na1Rs6GmKzVUPZ9FrqVt8F-H-gi=JO0+7WW6K@mail.gmail.com>
Subject: Re: Wintv-HVR-1120 woes
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: fabio tirapelle <ftirapelle@yahoo.it>
Cc: Albin Kauffmann <albin.kauffmann@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 25, 2010 at 8:16 AM, fabio tirapelle <ftirapelle@yahoo.it> wrote:
> My WinTV-HVR-1120 works if I delete dvb-fe-tda10048-1.0.fw and
> rename dvb-fe-tda10046.fw in dvb-fe-tda10048-1.0.fw
> (see cf "Hauppauge  WinTV-HVR-1120 on Unbuntu 10.04" thread).
> After reboot my WinTV-HVR-1120 works. Ubuntu recognizes that the firmware isn't
> correct and doesn't load the firmware.

How come it works without the firmware !? Is it possible that you
booted into Windows before that and there is a correct firmware
already running in the card ?

> But I know that isn't a good practice.
>
>
> ----- Messaggio originale -----
>> Da: Sasha Sirotkin <demiurg@femtolinux.com>
>> A: Albin Kauffmann <albin.kauffmann@gmail.com>
>> Cc: linux-media@vger.kernel.org
>> Inviato: Dom 24 ottobre 2010, 23:45:55
>> Oggetto: Re: Wintv-HVR-1120 woes
>>
>> On Sun, Oct 24, 2010 at 10:22 PM, Sasha Sirotkin <demiurg@femtolinux.com>
>>wrote:
>> > On Sun, Oct 24, 2010 at 8:55 PM, Albin Kauffmann
>> > <albin.kauffmann@gmail.com>  wrote:
>> >> On Thursday 21 October 2010 23:25:29 Sasha Sirotkin  wrote:
>> >>> I'm having all sorts of troubles with Wintv-HVR-1120 on  Ubuntu 10.10
>> >>> (kernel 2.6.35-22). Judging from what I've seen on  the net, including
>> >>> this mailing list, I'm not the only one not  being able to use this
>> >>> card and no solution seem to  exist.
>> >>>
>> >>> Problems:
>> >>> 1. The driver  yells various cryptic error messages
>> >>> ("tda18271_write_regs:  [1-0060|M] ERROR: idx = 0x5, len = 1,
>> >>> i2c_transfer returned:  -5", "tda18271_set_analog_params: [1-0060|M]
>> >>> error -5 on line  1045", etc)
>> >>
>> >> yes, indeed :(
>> >> (cf "Hauppauge  WinTV-HVR-1120 on Unbuntu 10.04" thread)
>> >>
>> >>> 2. DVB-T  scan (using w_scan) produces no results
>> >>
>> >> Is this  happening after each reboot? As far as I'm concerned, I've never
>>had
>> >>  problems with DVB-T scans.
>> >>
>> >
>> > Almost always. I think I  had a lucky reboot or two, but most of the
>> > time DVB-T scan produces  nothing.
>> >
>> >>> 3. Analog seems to work, but with very poor  quality
>> >>
>> >> I just tried to use Analog TV in order to  confirm the problem but I cannot
>>get
>> >> any picture. Maybe I just don't  know how to use it. I'm using commands
> like
>> >> (I'm located in  France):
>> >>
>> >> mplayer tv:// -tv  driver=v4l2:norm=SECAM:chanlist=france -tvscan autostart
>> >>
>> >>  ... and just get some "snow" on scanned channels.
>> >> As I might have a  problem with my antenna (an interior one), I am going to
>> >> test it  under Windows and report back my experience.
>> >
>> > I'm using  tvtime-scanner
>> >>
>> >> Cheers,
>> >>
>> >>  --
>> >> Albin Kauffmann
>> >>
>> >
>> >
>> > I'm trying to  downgrade the kernel now to see if it helps
>> >
>>
>> I went back as far as  2.6.30 and I still have this problem. 2.6.29
>> does not recognize this card at  all.
>> --
>> To unsubscribe from this list: send the line "unsubscribe  linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More  majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
