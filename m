Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54886 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab1JEXMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 19:12:45 -0400
Received: by wwf22 with SMTP id 22so3309212wwf.1
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 16:12:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
Date: Thu, 6 Oct 2011 01:12:44 +0200
Message-ID: <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/10/6 Jason Hecker <jwhecker@gmail.com>:
>> http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015.fw
>
> 5.1?  OK, I might eventually try that one too.
>
>> This morning I get a little pixeled playback, less than a second.
>
> OK, mine was fine for a few days then the pixellation started up in earnest.
>
> At the moment my symptoms were always:
>
> TunerA: Tuned - picture good
> TunerB: Idle
>
> Tuner B gets tuned, Tuner A starts to pixellate badly.
>
> I am sure this is the case too:
>
> TunerA: Idle
> TunerB: Tuned - picture good
>
> Tuner A gets tuned and has a bad recording.  *Never* has Tuner B
> suffered from the pixellation in spite of whatever Tuner A is doing!
>
> Anyway, Malcolm has suggested there is a bug lurking in MythTV too
> causing problems with dual tuners so it's a bit hard to isolate the
> issue.
>

Hello again, I am having more pixeled playback, I don't know how to
explain so I record a video:
http://dl.dropbox.com/u/1541853/VID_20111006_004447.3gp

I get this I2C messages:

# tail -f /var/log/messages
Oct  5 20:16:44 htpc kernel: [  534.168957] af9013: I2C read failed reg:d330
Oct  5 20:16:49 htpc kernel: [  538.626152] af9013: I2C read failed reg:d330
Oct  5 21:22:15 htpc kernel: [ 4464.930734] af9013: I2C write failed
reg:d2e2 len:1
Oct  5 21:40:46 htpc kernel: [ 5576.241897] af9013: I2C read failed reg:d2e6
Oct  5 23:07:33 htpc kernel: [10782.852522] af9013: I2C read failed reg:d2e6
Oct  5 23:20:11 htpc kernel: [11540.824515] af9013: I2C read failed reg:d07c
Oct  6 00:11:41 htpc kernel: [14631.122384] af9013: I2C read failed reg:d2e6
Oct  6 00:26:13 htpc kernel: [15502.900549] af9013: I2C read failed reg:d2e6
Oct  6 00:39:58 htpc kernel: [16328.273015] af9013: I2C read failed reg:d330

My signal is this:

(idle)
$ femon -H -a 4
FE: Afatech AF9013 DVB-T (DVBT)
status S     | signal  75% | snr   0% | ber 0 | unc 0 |
status S     | signal  75% | snr   0% | ber 0 | unc 0 |
status S     | signal  75% | snr   0% | ber 0 | unc 0 |
status S     | signal  75% | snr   0% | ber 0 | unc 0 |
status S     | signal  74% | snr   0% | ber 0 | unc 0 |
status S     | signal  74% | snr   0% | ber 0 | unc 0 |

(watching)
$ femon -H -a 5
FE: Afatech AF9013 DVB-T (DVBT)
status SCVYL | signal  74% | snr   0% | ber 142 | unc 319408 | FE_HAS_LOCK
status SCVYL | signal  74% | snr   0% | ber 142 | unc 319408 | FE_HAS_LOCK
status SCVYL | signal  74% | snr   0% | ber 31 | unc 319430 | FE_HAS_LOCK
status SCVYL | signal  74% | snr   0% | ber 31 | unc 319430 | FE_HAS_LOCK
status SCVYL | signal  74% | snr   0% | ber 56 | unc 319519 | FE_HAS_LOCK
status SCVYL | signal  74% | snr   0% | ber 0 | unc 319519 | FE_HAS_LOCK
status SCVYL | signal  74% | snr   0% | ber 0 | unc 319519 | FE_HAS_LOCK

There are lots of ber and unc bits, I have connected the TV to the
same wire and there is a good signal.

Thanks for your help.

Regards.

-- 
Josu Lazkano
