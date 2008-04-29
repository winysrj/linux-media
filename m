Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1Jqomu-0002Ek-Fx
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 14:18:25 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id E9A552FAA13
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 14:18:27 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id A59DA1300236
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 14:18:18 +0200 (CEST)
Message-ID: <48171207.8080602@anevia.com>
Date: Tue, 29 Apr 2008 14:18:15 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4816E5DA.7010204@anevia.com>
	<1209467866.3247.45.camel@pc10.localdom.local>
In-Reply-To: <1209467866.3247.45.camel@pc10.localdom.local>
Subject: Re: [linux-dvb] KNC TV Station DVR Tuner Sound Issue
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hermann pitton a =E9crit :
> Hi Frederic,
> =

> Am Dienstag, den 29.04.2008, 11:09 +0200 schrieb Frederic CAND:
>> Dear all,
>>
>> I recently had to change v4l drivers to support my WinTV HVR 1300.
>> I have issues making my HVR work but that's not the point here.
>> My problem is that since I updated kernel + drivers, I can't manage to =

>> make sound work when I'm using the tuner input. Sound jack input works =

>> when I'm using SVideo or Composite Video, but not when I'm using tuner.
>>
>> Here are the options I'm using
>> tuner : port2=3D0
>> saa7134: oss=3D1 disable_ir=3D1
>> saa7134-oss: rate=3D48000
> =

> the rate=3D48000 is only valid for external analog input and disables
> sound from tuner. Have a look at the saa7134-oss mixer under such
> conditions.
> =

> You must use default rate of 32000 for dma sound from tuner.
> =

> The saa7134-oss is also soon deprecated and replaced by saa7134-alsa.
> =

> If you are considering using recent v4l-dvb mercurial stuff, which
> should be best for the HVR1300 and reporting bugs on saa7134-empress,
> you might still have your old saa7134-oss module around and some others
> like the old video_buf now loaded, since not deleted on upgrade.
> =

> After make rmmod and rminstall with current v4l-dvb you should delete
> such remaining modules on older kernels too before make install.
> =

> Cheers,
> Hermann

hum I used to set rate to 48000 with my old 2005 july snapshot and it =

was working even with tuner ... but ok I'll try 32000
i've tried alsa and I had the same results, that is no sound with tuner =

but line in sound with composite and svideo
do I need some special stuffs compiled in my kernel except from config_snd ?
about old modules still loaded this can't be since I build my system =

from scratch each time i try a new kernel / driver into an ext2 file, =

which I put on a 32MB flash disk and boot on it ... so I'm sure I'm not =

using my old v4l snapshot, but the 2.6.22.19 v4l drivers

I'll let you know if I can make it work

-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
