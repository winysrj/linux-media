Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1K0YZw-0007pe-4v
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 11:01:17 +0200
Message-ID: <483A7C3B.7070101@anevia.com>
Date: Mon, 26 May 2008 11:00:43 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>, linux-dvb@linuxtv.org
References: <4836DD93.50805@anevia.com>
	<1211561434.2791.12.camel@pc10.localdom.local>
In-Reply-To: <1211561434.2791.12.camel@pc10.localdom.local>
Subject: Re: [linux-dvb] [HVR1300] issue with VLC
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

> Am Freitag, den 23.05.2008, 17:06 +0200 schrieb Frederic CAND:
>> I post again cause I did not get any reply at my late mail : anybody =

>> encountering picture / sound issues with VLC after some time running =

>> (let's say half an hour) reading the MPEG PS output ?
>> I tried many different v4l-dvb tarballs, including latest repository, =

>> but I could not make it work more that 30 minutes (or 20, it depends).
>> Stopping VLC and restarting it "solves" this issue but I'm looking for =

>> someone who could confirm this behaviour, and then maybe fix this.
>> My VLC works fine , btw , with other MPEG PS or TS live streaming.
>>
>> Cheers.
> =

> can't tell much on it, but it might be related to this recently heard
> from Dean and Mauro.
> =


Hermann,
I've read your answer and quote, but my issue is happening when reading =

the PS from /dev/video1 with VLC. VLC does not send any ioctl to =

/dev/video0 (my HVR 1300). I do it myself.
Let me copy/paste my code, maybe I'm missing something (which would make =

VLC go crazy after 30 minutes ... !?!)

/* open devices */
fd1 =3D open("/dev/video0", 0_RDWR);
fd2 =3D open("/dev/video1", 0_RDWR);

/* prepare input/format */
int i =3D 1;
int j =3D V4L2_STD_SECAM;
ioctl(fd1, VIDIOC_S_INPUT, &i);
ioctl(fd1, VIDIOC_S_STD, &j);
struct v4l2_ext_controls mc;
struct v4l2_ext_control ctrls[32];

/* mpeg settings */
mc.ctrl_class =3D V4L2_CTRL_CLASS_MPEG;
mc.controls =3D ctrls;
i =3D 0;
mc.ctrl_class =3D V4L2_CTRL_CLASS_MPEG;
ctrls[i].id =3D V4L2_CID_MPEG_VIDEO_BITRATE_MODE;
ctrls[i++].value =3D V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
ctrls[i].id =3D V4L2_CID_MPEG_AUDIO_ENCODING;
ctrls[i++].value =3D V4L2_MPEG_AUDIO_ENCODING_LAYER_2;
ctrls[i].id =3D V4L2_CID_MPEG_AUDIO_L2_BITRATE;
ctrls[i++].value =3D V4L2_MPEG_AUDIO_L2_BITRATE_256K;
ctrls[i].id =3D V4L2_CID_MPEG_VIDEO_BITRATE;
ctrls[i++].value =3D 4096 * 1000;
ctrls[i].id =3D V4L2_CID_MPEG_VIDEO_BITRATE_PEAK;
ctrls[i++].value =3D 4096 * 1000;
ctrls[i].id =3D V4L2_CID_MPEG_VIDEO_ASPECT;
ctrls[i++].value =3D V4L2_MPEG_VIDEO_ASPECT_4x3;
mc.count =3D i;
ioctl(fd2, VIDIOC_S_EXT_CTRLS, &mc);


of course I tried to remove different mpeg settings, but ... it's not =

chaning anything
I tried old v4l-dvb snaphots, v4l included within kernel 2.6.22.19 but =

with no success ... 2.6.25.4 v4l drivers do not provide any MPEG PS at =

all, that is a read on /dev/video1 timeouts
status is it's working for around 30 minutes then VLC prints error =

messages, sound / image become ugly and the only solution is to stop / =

restart the read of the MPEG PS ...
anyone having the same behavior when reading PS with VLC for more than =

thirty minutes ?
-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
