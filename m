Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54265 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbcBCWkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2016 17:40:08 -0500
Date: Wed, 3 Feb 2016 20:39:57 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	linux-media <linux-media@vger.kernel.org>,
	Junghak Sung <jh1009.sung@samsung.com>
Subject: Re: [PATCH for v4.5] vb2: fix nasty vb2_thread regression
Message-ID: <20160203203957.2c592fa8@recife.lan>
In-Reply-To: <56A9364D.5010806@xs4all.nl>
References: <56A8B34A.7010606@xs4all.nl>
	<56A92F1C.9080005@gentoo.org>
	<56A9364D.5010806@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Jan 2016 22:27:41 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 01/27/2016 09:57 PM, Matthias Schwarzott wrote:
> > Am 27.01.2016 um 13:08 schrieb Hans Verkuil:  
> >> The vb2_thread implementation was made generic and was moved from
> >> videobuf2-v4l2.c to videobuf2-core.c in commit af3bac1a. Unfortunately
> >> that clearly was never tested since it broke read() causing NULL address
> >> references.
> >>
> >> The root cause was confused handling of vb2_buffer vs v4l2_buffer (the pb
> >> pointer in various core functions).
> >>
> >> The v4l2_buffer no longer exists after moving the code into the core and
> >> it is no longer needed. However, the vb2_thread code passed a pointer to
> >> a vb2_buffer to the core functions were a v4l2_buffer pointer was expected
> >> and vb2_thread expected that the vb2_buffer fields would be filled in
> >> correctly.
> >>
> >> This is obviously wrong since v4l2_buffer != vb2_buffer. Note that the
> >> pb pointer is a void pointer, so no type-checking took place.
> >>
> >> This patch fixes this problem:
> >>
> >> 1) allow pb to be NULL for vb2_core_(d)qbuf. The vb2_thread code will use
> >>    a NULL pointer here since they don't care about v4l2_buffer anyway.
> >> 2) let vb2_core_dqbuf pass back the index of the received buffer. This is
> >>    all vb2_thread needs: this index is the index into the q->bufs array
> >>    and vb2_thread just gets the vb2_buffer from there.
> >> 3) the fileio->b pointer (that originally contained a v4l2_buffer) is
> >>    removed altogether since it is no longer needed.
> >>
> >> Tested with vivid and the cobalt driver.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Reported-by: Matthias Schwarzott <zzam@gentoo.org>  
> > 
> > Hi Hans!
> > 
> > Thank you for this patch.
> > I gave this patch a try on the latest sources from
> > git://linuxtv.org/media_tree.git
> > 
> > Compiled for kernel 4.2.8 with media_build.
> > 
> > Now it no longer oopses.  
> 
> Good.
> 
> > It tunes fine (according to femon), but I still do not get a
> > picture/dvbtraffic reports nothing.  
> 
> I will try to do a DVB test tomorrow. I can't spend too much time on it so
> if I can't reproduce it I'll probably ask Mauro to take a look. After tomorrow
> it will take at least a week before I have another chance of testing this due
> to traveling.

There is one other unrelated bug, fixed on this patch:
	https://patchwork.linuxtv.org/patch/32814/

I added both patches on my experimental tree, together with a fix
for tda10046 demod, at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=vb2-dvb-fixup

Please test. At least here, it is working fine:

$ LANG=C ~/v4l-utils/utils/dvb/dvbv5-scan -Ichannel ~/dvbt-teste -F
Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable (yet).
Scanning frequency #1 562000000
Lock   (0x1f) Signal= 70.20% C/N= 92.16% UCB= 60395 postBER= 8
Service D8, provider NTN: digital television
Service BFM TV, provider NTN: digital television
Service i>TELE, provider NTN: digital television
Service D17, provider NTN: digital television
Service Gulli, provider NTN: digital television
Service France 4, provider NTN: digital television


$ LANG=C ~/v4l-utils/utils/dvb/dvbv5-zap -Ichannel -c ~/dvbt-teste -m 562000000

 PID          FREQ         SPEED       TOTAL
0000      9.70 p/s     14.2 Kbps       12 KB
0010      2.14 p/s      3.1 Kbps        2 KB
0012     82.04 p/s    120.5 Kbps      105 KB
0015      1.85 p/s      2.7 Kbps        2 KB
006e      9.84 p/s     14.5 Kbps       12 KB
0078   2170.21 p/s   3187.5 Kbps     2792 KB
0082    130.26 p/s    191.3 Kbps      167 KB
0083    130.26 p/s    191.3 Kbps      167 KB
008c      2.43 p/s      3.6 Kbps        3 KB
008d      2.43 p/s      3.6 Kbps        3 KB
00aa      2.00 p/s      2.9 Kbps        2 KB
0136      9.84 p/s     14.5 Kbps       12 KB
0140   2864.03 p/s   4206.5 Kbps     3685 KB
014a    130.26 p/s    191.3 Kbps      167 KB
0154      2.57 p/s      3.8 Kbps        3 KB
019a      9.84 p/s     14.5 Kbps       12 KB
01a4   2316.16 p/s   3401.9 Kbps     2980 KB
01ae    130.12 p/s    191.1 Kbps      167 KB
01b8      2.43 p/s      3.6 Kbps        3 KB
01d6      2.00 p/s      2.9 Kbps        2 KB
01fe      9.84 p/s     14.5 Kbps       12 KB
0208   2276.22 p/s   3343.2 Kbps     2929 KB
0212    130.40 p/s    191.5 Kbps      167 KB
0213    130.40 p/s    191.5 Kbps      167 KB
021c      7.42 p/s     10.9 Kbps        9 KB
021d      2.57 p/s      3.8 Kbps        3 KB
0221     24.68 p/s     36.3 Kbps       31 KB
023a      2.00 p/s      2.9 Kbps        2 KB
0262      9.84 p/s     14.5 Kbps       12 KB
026c   2209.16 p/s   3244.7 Kbps     2842 KB
0276    130.26 p/s    191.3 Kbps      167 KB
0277    130.26 p/s    191.3 Kbps      167 KB
0280      2.43 p/s      3.6 Kbps        3 KB
0281      2.43 p/s      3.6 Kbps        3 KB
02c6      9.84 p/s     14.5 Kbps       12 KB
02d0   2187.76 p/s   3213.3 Kbps     2815 KB
02da    130.40 p/s    191.5 Kbps      167 KB
02db    130.40 p/s    191.5 Kbps      167 KB
02e4      2.57 p/s      3.8 Kbps        3 KB
02e5      2.57 p/s      3.8 Kbps        3 KB
0302      2.00 p/s      2.9 Kbps        2 KB
0303    177.20 p/s    260.3 Kbps      228 KB
1fff   5060.78 p/s   7433.0 Kbps     6512 KB
TOT   20782.42 p/s  30524.2 Kbps    26743 KB


Lock   (0x1f) Signal= 70.20% C/N= 100.00% UCB= 65535 postBER= 24

Please test. I should be applying both patches tomorrow, in order
to send them as quick as possible to 4.5-rc.

Regards,
Mauro




