Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2N12Ktb023306
	for <video4linux-list@redhat.com>; Sat, 22 Mar 2008 21:02:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2N11lm5011165
	for <video4linux-list@redhat.com>; Sat, 22 Mar 2008 21:01:47 -0400
Date: Sat, 22 Mar 2008 21:01:42 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
In-Reply-To: <200803222017.40862.bonganilinux@mweb.co.za>
Message-ID: <Pine.LNX.4.64.0803222027350.6294@bombadil.infradead.org>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<200803211655.31085.bonganilinux@mweb.co.za>
	<20080322000557.GA21314@localhost>
	<200803222017.40862.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
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

On Sat, 22 Mar 2008, Bongani Hlope wrote:

> On Saturday 22 March 2008 02:05:57 Robert Fitzsimons wrote:
>> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
>> ---
>>  drivers/media/video/bt8xx/bttv-driver.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>>
>> Hi Bongani
>>
>> I only noticed that you might be using a 32 bit userspace, so the radio
>> compat_ioctl needs to be implmented.
>>
>> Robert
>>
>>
>>
>> diff --git a/drivers/media/video/bt8xx/bttv-driver.c
>> b/drivers/media/video/bt8xx/bttv-driver.c index 5404fcc..1bdb726 100644
>> --- a/drivers/media/video/bt8xx/bttv-driver.c
>> +++ b/drivers/media/video/bt8xx/bttv-driver.c
>> @@ -3601,6 +3601,7 @@ static const struct file_operations radio_fops =
>>  	.read     = radio_read,
>>  	.release  = radio_release,
>>  	.ioctl	  = video_ioctl2,
>> +	.compat_ioctl	= v4l_compat_ioctl32,
>>  	.llseek	  = no_llseek,
>>  	.poll     = radio_poll,
>>  };
>
> I run a 64-bit kernel and 64-bit user-space, only a chrooted version of
> mplayer and it's dependencies are 32 bit, and I don't use them that often.
>
> file /usr/bin/radio
> /usr/bin/radio: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for
> GNU/Linux 2.6.9, dynamically linked (uses shared libs), stripped
>
> That patch doesn't help also...

Unfortunately, I coudn't reproduce your bug here.

I tested with a bttv board, plus two radio applications - radio and kradio
(radio-3.95-7mdv2008.0 and kradio-1.0-0.r497.3mdv2008.0 packages). None of 
them used V4L1 API. I also tested reading frequency, using
 	v4l-info /dev/radio0

I also used ioctl-test, running all V4L1 API calls, with this result 
(I've enabled debug on v4l1-compat, and added a small patch to bttv to use 
video_ioctl2 debug):

Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt848 (rev 17) at 0000:05:06.0, irq: 16, latency: 32, mmio: 0xce000000
bttv0: using: STB, Gateway P/N 6000699 (bt848) [card=3,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00fbffff [init]
bttv0: tuner type=2
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_STREAMOFF, dir=-w (0x40045613)
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_OVERLAY, dir=-w (0x4004560e)
v4l1-compat: VIDIOCCAPTURE / VIDIOC_PREVIEW: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_AUDIO, dir=r- (0x80345621)
BT848 radio (STB, Gateway P/N 6: Get for index=0
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, capability=0, mode=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=9963785, type=2, name=Mute, min/max=0/1, step=0, default=0, flags=0x00000000
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_CTRL, dir=rw (0xc008561b)
BT848 radio (STB, Gateway P/N 6: Enum for index=9963785
BT848 radio (STB, Gateway P/N 6: id=9963785, value=-32512
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_TUNER, dir=rw (0xc054561d)
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, capability=0, rangelow=0, rangehigh=0, signal=0, afc=0, rxsubchans=0, audmode=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCAP, dir=r- (0x80685600)
BT848 radio (STB, Gateway P/N 6: driver=bttv, card=BT848 radio (STB, Gateway P/N 6, bus=PCI:0000:05:06.0, version=0x00000911, capabilities=0x00010000
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc050561a)
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, audioset=0, tuner=0, std=00000000, status=0
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc050561a)
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw (0xc0405602)
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc050561a)
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, audioset=0, tuner=0, std=00000000, status=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_STD, dir=r- (0x80085617)
BT848 radio (STB, Gateway P/N 6: value=00000000
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FBUF, dir=r- (0x8030560a)
v4l1-compat: VIDIOCGFBUF / VIDIOC_G_FBUF: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FREQUENCY, dir=rw (0xc02c5638)
BT848 radio (STB, Gateway P/N 6: tuner=0, type=1, frequency=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=video-cap
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCGPICT / VIDIOC_G_FMT: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_TUNER, dir=rw (0xc054561d)
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, capability=0, rangelow=0, rangehigh=0, signal=0, afc=0, rxsubchans=0, audmode=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_STD, dir=r- (0x80085617)
BT848 radio (STB, Gateway P/N 6: value=00000000
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=vbi-cap
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCGVBIFMT / VIDIOC_G_FMT: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=video-over
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCGWIN / VIDIOC_G_WIN: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=video-cap
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCGWIN / VIDIOC_G_FMT: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=video-cap
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCMCAPTURE / VIDIOC_G_FMT: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_AUDIO, dir=-w (0x40345622)
BT848 radio (STB, Gateway P/N 6: index=0, name=, capability=0, mode=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=9963785, type=2, name=Mute, min/max=0/1, step=0, default=0, flags=0x00000000
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_CTRL, dir=rw (0xc008561c)
BT848 radio (STB, Gateway P/N 6: id=9963785, value=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_TUNER, dir=rw (0xc054561d)
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, capability=0, rangelow=0, rangehigh=0, signal=0, afc=0, rxsubchans=0, audmode=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_TUNER, dir=-w (0x4054561e)
BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, capability=0, rangelow=0, rangehigh=0, signal=0, afc=0, rxsubchans=0, audmode=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_INPUT, dir=rw (0xc0045627)
BT848 radio (STB, Gateway P/N 6: value=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_STD, dir=-w (0x40085618)
BT848 radio (STB, Gateway P/N 6: value=000000ff
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FBUF, dir=-w (0x4030560b)
v4l1-compat: VIDIOCSFBUF / VIDIOC_S_FBUF: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FREQUENCY, dir=rw (0xc02c5638)
BT848 radio (STB, Gateway P/N 6: tuner=0, type=1, frequency=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FREQUENCY, dir=-w (0x402c5639)
BT848 radio (STB, Gateway P/N 6: tuner=0, type=1, frequency=0
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=video-cap
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCSPICT / VIDIOC_G_FMT: -22
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FBUF, dir=r- (0x8030560a)
v4l1-compat: VIDIOCSPICT / VIDIOC_G_FBUF: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_INPUT, dir=rw (0xc0045627)
BT848 radio (STB, Gateway P/N 6: value=0
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_STREAMOFF, dir=-w (0x40045613)
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
BT848 radio (STB, Gateway P/N 6: type=video-cap
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0d05604)
v4l1-compat: VIDIOCSWIN / VIDIOC_G_FMT: -22
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0d05605)
BT848 radio (STB, Gateway P/N 6: type=video-over
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0d05605)
v4l1-compat: VIDIOCSWIN / VIDIOC_S_FMT #2: -22
BT848 radio (STB, Gateway P/N 6: err:
BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYBUF, dir=rw (0xc0585609)
v4l1-compat: VIDIOCSYNC / VIDIOC_QUERYBUF: -22

I got no oops. The tests were done also on a 64bit kernel, on a dual-core 
machine.

Cheers,
Mauro

---

I've patched the ioctl-test program (at v4l2-apps/test dir, on v4l/dvb 
development environment, available at http://linuxtv.org/hg/v4l-dvb) with 
this diff:

diff -r f24051885fe9 v4l2-apps/test/ioctl-test.c
--- a/v4l2-apps/test/ioctl-test.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/v4l2-apps/test/ioctl-test.c	Sat Mar 22 21:52:16 2008 -0300
@@ -47,6 +47,8 @@ typedef __u32 u32;
  #else
  typedef u_int32_t u32;
  #endif
+
+#define CONFIG_VIDEO_V4L1_COMPAT

  /* All possible parameters used on v4l ioctls */
  union v4l_parms {
@@ -142,7 +144,7 @@ int ioctls[] = {
  	VIDIOCSYNC,/* int */
  #endif
  	/* V4L2 ioctls */
-
+#if 0
  	VIDIOC_CROPCAP,/* struct v4l2_cropcap */
  	VIDIOC_DQBUF,/* struct v4l2_buffer */
  	VIDIOC_ENUMAUDIO,/* struct v4l2_audio */
@@ -173,7 +175,7 @@ int ioctls[] = {
  	VIDIOC_S_OUTPUT,/* int */
  	VIDIOC_S_PARM,/* struct v4l2_streamparm */
  	VIDIOC_TRY_FMT,/* struct v4l2_format */
-
+#endif
  #if 0
  	VIDIOC_G_AUDIO_OLD,/* struct v4l2_audio */
  	VIDIOC_G_AUDOUT_OLD,/* struct v4l2_audioout */
@@ -214,7 +216,7 @@ int main (void)
  {
  	int fd=0, ret=0;
  	unsigned i;
-	char *device="/dev/video0";
+	char *device="/dev/radio0";
  	union v4l_parms p;

  	if ((fd = open(device, O_RDONLY)) < 0) {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
