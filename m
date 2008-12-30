Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUNRsq8001784
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 18:27:54 -0500
Received: from mx1.wp.pl (mx1.wp.pl [212.77.101.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUNRdGB026724
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 18:27:40 -0500
Received: from poczta-26.free.wp-sa.pl (HELO localhost) ([10.1.1.125])
	(envelope-sender <jurskij@wp.pl>) by smtp.wp.pl (WP-SMTPD) with SMTP
	for <video4linux-list@redhat.com>; 31 Dec 2008 00:27:38 +0100
Date: Wed, 31 Dec 2008 00:27:37 +0100
From: "Janusz Jurski" <jurskij@wp.pl>
To: video4linux-list <video4linux-list@redhat.com>
Message-ID: <495aae6913ee57.85045613@wp.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="part495aae6913f064.12713864"
Subject: gspca (ubuntu 8.10) and sonixj camera problems
Reply-To: jj@ds.pg.gda.pl
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

This is a multi-part message in MIME format.

--part495aae6913f064.12713864
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi All,

My system configuration is as folows:
- clean Ubuntu8.10 (live CD) - kernel 2.6.27
- my USB sonixj camera connected - it is 0c45:612a Microdia PC Camera 
(SN9C110)
- dmesg shows no errors or suspicious messages

Problem: I cannot get any application to work with my camera. Even svv 
mentioned in http://moinejf.free.fr/gspca_README.txt does not work. Logs 
for svv and streamer are below. Attached is also a raw file generated 
with svv (just 2kB in size). The logs show JPEG conversion errors. 
Anyone has a similar problem? Any helpful ideas on what to do?

I appreciate your help.
Thanks,
JJ

svv returns the following errors (or similar - it often asks for a 
different number of bits, sometimes it complains about unknown huffman 
code during JPEG decompression):

ubuntu@ubuntu:~/Desktop$ ./svv
raw pixfmt: JPEG 640x480
pixfmt: RGB3 640x480
mmap method
libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 more 
bits
libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 more 
bits
libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 more 
bits
libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 more 
bits
libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 more 
bits
ubuntu@ubuntu:~/Desktop$

streamer (another application that I tried) returns a similar conversion 
error:
ubuntu@ubuntu:~/Desktop$ LD_PRELOAD=/usr/local/lib/libv4l/v4l1compat.so 
streamer -o a.jpeg
files / video: JPEG (JFIF) / audio: none
libv4l2: error converting / decoding frame data: v4l-convert: error 
parsing JPEG header: Not a JPG file ?


ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=406;flags=0x1 
[MAPPED];field=NONE;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
Input/output error
^C^C - one moment please
libv4l2: error converting / decoding frame data: v4l-convert: error 
parsing JPEG header: Not a JPG file ?


ioctl: VIDIOC_DQBUF(index=1;type=VIDEO_CAPTURE;bytesused=406;flags=0x1 
[MAPPED];field=NONE;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
Input/output error
ubuntu@ubuntu:~/Desktop$

----------------------------------------------------
Czujesz zwi±zek z Kopernikiem?! :)
Sprawd¼ swoje korzenie na bliscy.pl
Zbuduj drzewo swojej rodziny: 
http://klik.wp.pl/?adr=http%3A%2F%2Fcorto.www.wp.pl%2Fas%2Fbliscy.html&sid=597

--part495aae6913f064.12713864
Content-Type: application/x-ns-proxy-autoconfig; name="image.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="image.dat"

/9j/2wCEAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYn
KSopGR8tMC0oMCUoKSgBBwcHCggKEwoKEygaFhooKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgo
KCgoKCgoKCgoKCgoKCgoKCgoKCgoKP/EAaIAAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKCwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoLEAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYT
UWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZX
WFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPE
xcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+foRAAIBAgQEAwQHBQQEAAECdwABAgMR
BAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVG
R0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKz
tLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/AABEIAeACgAMBIQAC
EQEDEQH/2gAMAwEAAhEDEQA/AOVg8PasJES1tZyLS5aGJUlJ2XDb+Pu/ePHNJaeH71vJaNhBHb3j
wRSSXOFS4JcMAcdenNAE8fhPULY2axTRR51CSztM3eC1wd2duV915p1n4Q1BpLUWs0TtHfvZQBLz
O2c5yenHUcmgBbfwlfqLM280O1dSksbYi76XJ3bsfL15GTToPB+ow/ZPs8sK7dReytv9L6XBznHy
9eRzQAlr4S1MLaC3ltwq6k9lbAXPS5Od2OOvK802LwnqKJbGCWAqmoyWVsFus/6Sd27Ax15HNAFZ
PD+reXH5VtcCOK4a3h2ysoE7bvlGB944Wlt/CF+RaQLbCGG3vGtIFkkwiXBL5GNuN3TnmgCzF4S1
KSWGWKeIt/aEllATd/8ALwd2do28dRzS23hG/ja3NrJArHUWs4WS5AJuMMODtzwGHNACW3g6+iSy
W1kgjSPUHsLQJdAYuDuzj5evK80lt4Ov0ezeCWLcuovYWpN5nFwd2cZX3XmgB0HhHUkW1FtNb4Gp
PZW+Lr/l5O7cRx7jmoh4V1KG2gaGW32R38lnb4uc/wCkc7sAjryOaAKgsGWE2qQtHEBu2JHt3H5i
M4Xn1qE2IkJZMyiAPtG3cEJLZONuBzQAlzbywyvMzyLI25vMYkHOHXg7fwpDYXEMP2ZIJETO7y0Q
jcfnIzhOex5oAiaNpiziEy+QXx8m5ULb88bMAmkvVljzM/nKWZykjbgc4cfKdnXHHHSgBsVhNa5g
ht5YiFIEKIQ3V2GcJz6800Q+YXMcZkWAu33CwjJL5P3OCTQA6YO0zSBpNwLMr85Bw4yPk44GOKRY
vs8TpAGiQZACKRnBc84TnkZ5oAa8AJDbN3llymUyAW8zJAKdTUk6yszPmUsrMysc5U4cZB2cccUA
EdpLBF5EMMkYGSEjQjJ+ducJz681H9iaUMwi8xYS+P3e4KzGTJ+5gE0APnilifzX81X3Nsdt3DYc
cHZwcccU4WMsKNbxwSxgE4SOMjP3yM4Tn15oAQ2wlW4KQ7lUsHIjyAT5g5+SmzwFIgGiwhLbMpgZ
G/p8lAEpspY5WUWzLIAwBEXP8Z/ufjTPsyzLK0cAcKW3sseRk7xz8negBbmOaJjK6yICzbJGUjDf
OMA7OvbilFg9uRHHbOkke7aBEQR98/3M+9AETW3nrIViaQRK5OFLBNxfORs4ycfWpLuFyitcBmVm
ZkMqnG7DjjKe2KAJWtpwz26wygsSTEsZBb75GQE59a67wtdSSvoyoW22urCTjOF/1nsMcigDT0Vv
JbQguIgfFcyHyxt4Jz2x6/8A1qXSyW/sJWYlT4vlyGYkdMDv/h9KAHaM4A0IjH/I4TAkdTjtnP6c
fSjR8g6C3Q/8JhMMk9Pbr/h9KAE0xhv8PZIOPGM2Of068fp9KNKkAj0IBsKfF84J3Yx046/4fSgB
dFdJG0NI2EjR+L5ncK2dufXngfl9KZo1zEsegkzIEHjGcly4wBwPXj9PpQBJpcohfw6rtsZvGE2w
M2M9OnP+fSk0N1Z9FVG+ZfF82/a33Qce/H6fSgBdGmQroD+YNq+MZvm3cfz/AMPpT9HcL/YAyVJ8
Yz8k49Pf/D6UAN0d8Dw+AwAHjOfPP/1/8PpVa3kzpulZYYXxbc9+nH1/w+lAHmmlQh7G3eOEOyRA
krHnBIcZ+574rvPDMrxLosWwQxx6ruUFNuceZwDtHegDR0kKZ9CdwGkPiqaMM3JUEYwMnjjjjH0p
+k8DRFGEDeL5txHBPbBOR+XH0oAXSGBGg55UeMZuM9/Tr/h9KXRyR/YBzjHjCbqenT3/AMPpQAmk
lY20EKFUt4ylZiAAWPQAnOfw/Sl0h8LoAU/8zjMOvf06/wCH0oAm0mTzP7BVmyo8XS5Bbv09f8+l
GlSuY9BQyOAfGEyYDkccED736cfSgBNHk2/2G6nax8YTI53Y/Pn9P0pdJfeNAVmyo8YzEgt9B6/4
fSgA0iVj/wAI+Wcnb4xmAG7oOOOv+H0o0Yqp8N8Km3xnMAFAHHXnkep/wNABor5GgZb7vjSfnPQc
cdf8PpUNmzCy0cKxDHxfcgENjsMD7wx+n0oA4LStA1drO18m1uPNt5TCqrKxKXDhsj7v3jxzVi08
O3xS2MZEEdtePbQtJdYVLg7w3OOvTJoAsJ4S1C0NkkMyRk6hJZ2g+2YzcHdnGR7jmi18H30htUgm
hcx6i9lEou87bg7snG33Xk0AEHha/ItJLa4gONTksrYrd8C5O7cR8vHUc06HwhqMJsxBLAGGoPZW
2Lr/AJeDnOOPcc0ANtfCWqqLQW8tuETUHsbVVuelyc7scdeVyahm8N3tjbpdGaAxQXktrERdZxNh
i2OPQjmgAP/Z

--part495aae6913f064.12713864
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--part495aae6913f064.12713864--
