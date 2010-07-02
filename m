Return-path: <video4linux-list-bounces@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1277562210.8545.30.camel@localhost>
References: <1277269620009-5211808.post@n2.nabble.com>
	<1277562210.8545.30.camel@localhost>
Date: Sat, 3 Jul 2010 08:43:26 +1100
Message-ID: <AANLkTimm_LR036rKfItTw0_N39CerzeszzVHOifXhkFF@mail.gmail.com>
Subject: Re: V4L & VLC 1.0.6 and standard selection
From: Emmanuel CHANSON <emmanuelchanson@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Many thanks Andy,

Using SECAM-DK is Ok with SECAM_K1

BR,

Emmanuel



2010/6/27 Andy Walls <awalls@md.metrocast.net>

> On Tue, 2010-06-22 at 22:07 -0700, manunc wrote:
> > I am trying to catch my tuner card signal by using vlc and v4l
> >
> > Under Fedora 12:
> > vlc-1.0.6-1.fc12.i686
> > vlc-core-1.0.6-1.fc12.i686
> >
> >
> > libv4l-0.6.4-1.fc12.i686
> > xorg-x11-drv-v4l-0.2.0-3.fc12.1.i686
> > v4l2-tool-1.0.3-5.fc12.i686
> >
> >
> > By using the cvlc command to catch the tuner card signal and setting
> > standard in the command line I did not see the SECAM K1, so I wonder if
> the
> > fix has been committed or not in this release or if I have to patch the
> > sources:
> >
> >
> http://git.videolan.org/?p=3Dvlc.git;a=3Dcommitdiff;h=3Dbeb5d0fdc3c4b8b12=
ec385f96ab8a27c342b7236
> >
> > I used:
> >
> > $ cvlc -vv v4l2:// :v4l2-dev=3D/dev/video0 :v4l2-adev=3Dhw.1,0
> > :v4l2-tuner-frequency=3D207250 :v4l2-standard=3D13 ....
> >
> > I dont see SECAM K1
> > ....
> >
> > [0xb7108988] v4l2 demux debug: Trying libv4l2 wrapper
> > [0xb7108988] v4l2 demux debug: opening device '/dev/video0'
> > [0xb7108988] v4l2 demux debug: V4L2 device: BT878 video (Hauppauge
> (bt878))
> > using driver: bttv (version: 0.9.18) on PCI:0000:00:0b.0
> > [0xb7108988] v4l2 demux debug: the device has the capabilities: (X) Vid=
eo
> > Capure, ( ) Audio, (X) Tuner, ( ) Radio
> > [0xb7108988] v4l2 demux debug: supported I/O methods are: (X) Read/Writ=
e,
> > (X) Streaming, ( ) Asynchronous
> > [0xb7108988] v4l2 demux debug: device support raw VBI capture
> > [0xb7108988] v4l2 demux debug: video input 0 (Television) has type: Tun=
er
> > adapter *
> > [0xb7108988] v4l2 demux debug: video input 1 (Composite1) has type:
> External
> > analog input
> > [0xb7108988] v4l2 demux debug: video input 2 (S-Video) has type: Extern=
al
> > analog input
> > [0xb7108988] v4l2 demux debug: video input 3 (Composite3) has type:
> External
> > analog input
> > [0xb7108988] v4l2 demux debug: video standard 0 is: NTSC
> > [0xb7108988] v4l2 demux debug: video standard 1 is: NTSC-M
> > [0xb7108988] v4l2 demux debug: video standard 2 is: NTSC-M-JP
> > [0xb7108988] v4l2 demux debug: video standard 3 is: NTSC-M-KR
> > [0xb7108988] v4l2 demux debug: video standard 4 is: PAL *
> > [0xb7108988] v4l2 demux debug: video standard 5 is: PAL-BG
> > [0xb7108988] v4l2 demux debug: video standard 6 is: PAL-H
> > [0xb7108988] v4l2 demux debug: video standard 7 is: PAL-I
> > [0xb7108988] v4l2 demux debug: video standard 8 is: PAL-DK
> > [0xb7108988] v4l2 demux debug: video standard 9 is: PAL-M
> > [0xb7108988] v4l2 demux debug: video standard 10 is: PAL-N
> > [0xb7108988] v4l2 demux debug: video standard 11 is: PAL-Nc
> > [0xb7108988] v4l2 demux debug: video standard 12 is: PAL-60
> > [0xb7108988] v4l2 demux debug: video standard 13 is: SECAM
> > [0xb7108988] v4l2 demux debug: video standard 14 is: SECAM-B
> > [0xb7108988] v4l2 demux debug: video standard 15 is: SECAM-G
> > [0xb7108988] v4l2 demux debug: video standard 16 is: SECAM-H
> > [0xb7108988] v4l2 demux debug: video standard 17 is: SECAM-DK
> > [0xb7108988] v4l2 demux debug: video standard 18 is: SECAM-L
> > [0xb7108988] v4l2 demux debug: video standard 19 is: SECAM-Lc
> > [0xb7108988] v4l2 demux debug: tuner 0 (Television) has type: Analog TV,
> > frequency range: 44000,0 kHz -> 958000,0 kHz
> > [0xb7108988] v4l2 demux debug: tuner 0 (Television) frequency: 207250,0
> kHz
> > ...
> >
> > A developper from videolan told me this:
> > That list comes from the V4L2 driver for your analog TV capture card. It
> > does not come from VLC. So we cannot "fix" it.
> > In any case, SECAM-K1 is probably one of the choice, but with a differe=
nt
> > name.
>
>
> The video4linux list is effectively dead.  Use
> linux-media@vger.kernel.org .
>
> > Does anyone know if some of the options can be applied to decode SECAM
> K1?
> > ou K'
>
> Use SECAM-DK.  It is not significantly different from SECAM-K1:
>
>
> http://www.pembers.freeserve.co.uk/World-TV-Standards/Transmission-System=
s.html#CCIR
>
>
> $ v4l2-ctl -d /dev/video0 --help
> $ v4l2-ctl -d /dev/video0 --list-standards
> $ v4l2-ctl -d /dev/video0 --list-inputs
>
> $ v4l2-ctl -d /dev/video0 --set-standard=3Dsecam
>
> or
>
> $ v4l2-ctl -d /dev/video0 --set-standard=3D0x00320000
> (SECAM-DK is defined as
>  V4L2_STD_SECAM_D|V4L2_STD_SECAM_K|V4L2_STD_SECAM_K1 =3D> 0x00320000 in
>  include/linux/videodev2.h)
>
> or
>
> $ v4l2-ctl -d /dev/video0 --set-standard=3D0x00200000
> (SECAM-K1 defined as 0x00200000 in include/linux/videodev2.h)
>
> The setting should persist until you switch to another input (Tuner,
> SVideo, Composite).  The Tuner input will limit what standard can
> actually be set for the tuner.
>
> Regards,
> Andy
>
> > Thanks by advance for you replies
> >
> > BR
> > --
> > Emmanuel
>
>
>


-- =

Emmanuel

CHANSON Emmanuel
Mobile Nouvelle-Cal=E9donie: +687.77.35.02
Mobile France: +33 (0) 6.68.03.89.56
@email : emmanuelchanson@gmail.com
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
