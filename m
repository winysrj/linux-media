Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35985 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdDOO6d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 10:58:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAJs94EYkgXtr7P+HLsBnu6=j==g=wWRVFy91vofcdDziSfw60w@mail.gmail.com>
References: <CAJs94EYkgXtr7P+HLsBnu6=j==g=wWRVFy91vofcdDziSfw60w@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Sat, 15 Apr 2017 17:58:12 +0300
Message-ID: <CAJs94EbFyv=b3mX2g7zG6XzJZHmre+1mECdtXsEpOqMms-Vfxg@mail.gmail.com>
Subject: Re: musb: isoc pkt loss with pwc
To: Alan Stern <stern@rowland.harvard.edu>, Bin Liu <b-liu@ti.com>,
        hdegoede@redhat.com, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've managed to build OpenVizsla USB tool.
So, here is how the things look like from hardware USB sniffer  point of view:

[        ]   7.219456 d=  0.000997 [181.0 +  3.667] [  3] IN   : 4.5
[    T   ]   7.219459 d=  0.000003 [181.0 +  7.083] [800] DATA0: 53 da
50 f9 c1 a5 4a d5 14 2c 55 4c 03 96 33 98 92 e5 07 45 e0 52 25 0b 32
d9 d0 66 1d a2 dc d9 1e 4c 42 9f 9a 4a 28 94 4a 8b a2 2a 2d 87 1e 86
6e 08 55 d3 14 3e 1f 6c b0 2d 61 3e d8 d0 04 27 1f ca 74 71 24 b5 31
c2 57 0e f9 90 17 7b 39 d8 43 2e 8d ee a1 3d 8f 7e f4 02 d2 8f 9e 81
f4 83 83 a4 1f 4c a5 f5 d0 0b 4b e7 e0 a5 d2 8f de 54 6a 2e 95 8a 6d
a8 74 c7 16 49 0f f5 30 4a 25 c5 d2 f6 60 29 9a 7e d0 a2 53 2a 61 d3
c3 40 a4 8c 34 3c aa e1 51 8e 46 a5 4d 20 f4 d0 15 08 65 b5 85 51 8a
24 90 4a b2 68 94 ac 20 e9 b1 33 9b 7a 8c 4c 9d 42 a6 9a 2c 2c 7d 28
d9 05 51 59 0b 44 b9 70 a8 68 36 84 da 41 51 b6 2c ca 10 e9 83 a7 78
6a 79 3c 65 e3 30 55 d3 14 52 4d 3b a4 2a 1f 03 aa 53 20 55 b3 8b a7
c4 85 50 59 45 55 b5 2d aa 4a 9b 52 aa 6a 4b a9 5a 07 ab b4 09 ad 4a
53 4e 25 9a 94 4f 49 3d 95 32 9f f0 a8 34 09 90 6a 76 88 94 91 6c 3e
73 d0 82 ac 1a 4f ac 52 64 d5 85 ac 87 6c e5 d2 87 5b 0b 45 65 35 34
4a b5 e1 51 1b 46 a5 a9 00 ea c3 77 d1 ea 07 37 ac fa d1 1a 56 9d b1
0d a6 ce a1 57 28 f5 c3 03 a9 73 f0 72 ea 1e 7c 51 6a 39 b4 23 d4 19
d9 b4 1c dc 91 e9 c7 93 e9 87 07 4b 3f 3a 50 fa d1 59 58 fa e1 d9 50
fa e1 8b 48 f7 e0 a9 c0 e9 43 37 2d 9e 12 a5 d4 e3 26 56 ba 37 a2 39
28 4b a1 a4 17 41 28 69 53 04 b5 36 83 4a 56 d1 93 59 d8 a9 1b 3a 45
36 76 ea de e0 c9 26 0b c8 1c b4 41 54 d9 29 9e 4a d8 d4 e6 4f 8b 5c
95 40 72 55 04 c9 55 31 54 e2 31 cd 61 ad 05 a1 14 4d 6d 0c 55 25 13
43 32 55 08 f1 a4 50 ad 87 53 81 51 9a 4d a6 02 a4 b4 0b 4e 95 4a 45
f8 94 52 e9 83 a7 d5 f5 09 93 39 a8 2c 71 bb 0c 7a 30 c9 e0 48 f5 e1
ad f6 d0 1e 43 15 56 6d 12 d5 d0 aa 99 46 b5 a4 2a 71 44 6a 93 2a 31
34 ea 14 a7 5a 28 2a 75 a0 aa 20 2a b8 ca 92 a8 86 55 19 18 a5 82 a9
12 14 95 e2 2a cb a2 2c b0 32 38 b2 aa d2 c8 ab 14 49 f5 33 a9 32 9f
78 f4 b0 a2 a8 7a 6c 2b 20 22 2b c1 91 53 15 43 99 40 2b fd 8c a1 2a
c8 2a 96 43 25 c4 2a ca a1 12 5e 35 73 28 13 5a d5 42 a8 4f c4 4a ea
39 54 4b aa a4 28 4a 42 a9 36 86 0a ad b2 f1 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 3c 60 24 bf 31 d2 a2 48 75 a1 08
23 6d cf 91 36 46 da 20 a9 9f 62 a4 38 8c f4 29 47 72 01 49 a7 92 a4
4f 48 d2 bc 42 92 52 90 14 2d 49 52 5d 28 29 1a 94 34 cb 46 49 3b 45
49 2b 41 49 4d 0a 93 da 45 93 36 4d 9a 37 4d 4a 17 4e 6a 37 52 2a 53
da a5 4a 73 99 d2 86 4a 2d 56 6a 17 58 aa b2   Unexpected ERR CRC
[        ]   7.220456 d=  0.000997 [182   +  3.667] [  3] IN   : 4.5
[    T   ]   7.220459 d=  0.000003 [182   +  7.000] [800] DATA0: 13 36
65 6d 00 75 0e dd cd a7 3b 02 aa d8 cd a5 0f d5 6c 1a a5 9a 05 a4 1e
77 3c 3a 23 8a ce 98 e2 68 1d b3 81 94 34 29 90 b2 2a 25 53 9d d0 54
9b 06 51 a9 2c 40 b5 2e c2 54 91 46 f1 54 f7 62 54 cd 26 54 d9 a1 54
5a 5a a5 dd b4 aa 69 83 a9 24 3b 8c aa b2 83 ab ac 03 56 d2 c0 aa bd
cb a7 0f 96 94 48 25 0e 49 7d 52 1c 15 cf a2 92 6c 3a 73 d8 c8 ea 54
64 b5 89 d5 dc 20 2b a3 17 93 e9 c3 d5 a1 28 59 09 8b 2a 91 aa a7 51
49 42 68 0e ba d0 aa 76 15 5a c5 16 59 3d 1e 60 f5 78 16 b1 8a 0d b0
7a 9c 58 ed 14 58 ed d2 aa a0 2a d1 62 aa 9d 52 aa 4d a9 a2 85 54 f3
0e a7 da 2d a5 aa ae 50 2a 63 bb 11 95 b6 a5 54 d9 9b 53 d9 10 2b 0d
a8 39 20 f5 28 7a e8 45 40 d4 5e 18 2a dd 0c aa bb f4 79 e8 82 4e c9
0e 75 6a a1 53 36 78 d2 cd a1 0f 2e d1 f0 29 9b 49 01 55 76 0b a7 fa
09 81 e8 12 a8 85 ae 5a 00 b5 d8 45 50 22 9b d3 1c 54 33 39 06 65 8b
a6 0c 88 2a 98 1c 6a 26 53 9b 41 3e 15 0a a5 80 2a 85 51 9b 4e b5 34
4a c3 a7 66 1c 95 b8 0d a8 e4 33 96 3e d8 b2 07 f7 44 fa d0 7b 38 9c
a3 4f a7 98 95 ed 2e 81 aa 38 66 95 a2 28 fd cc ab 82 a3 54 48 95 29
93 92 50 aa c2 a8 7c 2a a6 0a 8c 92 90 2a 05 51 06 57 29 84 6a 79 95
29 88 a8 2a 25 51 0d ae 2a 8d b2 bc 4a 4a a3 4a ab 5a 1a b5 70 05 52
89 67 55 52 1a 95 7e 42 55 f6 13 83 fa 04 ad 12 14 b5 51 05 51 2d b2
52 a1 50 1b 5a 2d 08 65 a8 55 0b 21 b4 10 aa 61 56 29 85 2a b2 3a 8d
a1 12 56 b5 49 94 50 ca 21 ad 1e f7 06 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 3e 60 24 b7 39 d2 e6 48 2d 48 da e5 48 09 48 20 29 59
1c 71 a4 26 1c 91 04 92 4e 81 49 fa 29 50 6a 3d 4f da 38 29 8a 94 ed
b8 e0 b2 1e ba 70 79 38 78 5b a4 14 8b 93 aa 59 3c 69 ee e2 49 e9 26
4a 2d 51 4a 81 52 3f 41 4a 9b 29 7d 8a 95 da 82 a5 6c ac e4 c9 d2 46
4b 8a 97 ba 82 98 5a c8 34 77 23 a6 79 05 33 a9 a6 01 4e 6a 3d 74 aa
ee 80 a7 90 a7 7e 82 9f 1c 7d 4a 36 79 9a d2 20 e7 e1 50 8c d9 1c 2c
0b 2d 9b 43 c1 e4 e1 50 21 c9 a3 c6 10 96 43 3e 60 fc 7c f8 83 6b 0b
a4 ac b6 c5 52 9d 4b a6 2a ba e0 d4 d2 e2 a9 ce 7c aa 6d 09 55 53 46
d5 76 51 aa b4 94 6a 2e a4 9a 0b a9 aa 8e 52 a5 2b 6c fa 50 ca a4 76
a0 54 b4 9b 47 ad 1d 22 b5 12 1c 95 4d a2 84 43 b9 0d a2 74 15 45 05
41 49 b2 28 94 66 d1 a8 46 a0 94 6a a4 6c da 1e ba 94 4a b5 01 55 6d
8a aa 1c ab d2 96 55 c5 36 41 d4 87 1a 5b 3c   Unexpected ERR CRC
[        ]   7.222456 d=  0.001997 [184   +  3.667] [  3] IN   : 4.5
[        ]   7.222459 d=  0.000003 [184   +  7.000] [  3] DATA0: 00 00
[        ]   7.223456 d=  0.000997 [185.0 +  3.667] [  3] IN   : 4.5
[        ]   7.223459 d=  0.000003 [185.0 +  7.000] [  3] DATA0: 00 00
[        ]   7.224456 d=  0.000997 [186   +  3.583] [  3] IN   : 4.5
[        ]   7.224459 d=  0.000003 [186   +  6.917] [  3] DATA0: 00 00
[        ]   7.225456 d=  0.000997 [187.0 +  3.667] [  3] IN   : 4.5
[        ]   7.225459 d=  0.000003 [187.0 +  7.000] [  3] DATA0: 00 00

Here, I believe that IN request is missed at 7.221 and this leads to
the issues with missed data.


2016-08-28 13:13 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
> Hello Bin,
>
> I would like to start new thread on my issue. Let me recall where the issue is:
> There is 100% frame lost in pwc webcam driver due to lots of
> zero-length packages coming from musb driver.
> The issue is present in all kernels (including 4.8) starting from the commit:
>
> f551e13529833e052f75ec628a8af7b034af20f9 ("Revert "usb: musb:
> musb_host: Enable HCD_BH flag to handle urb return in bottom half"")
>
> The issue is here both when DMA enabled and DMA disabled.
>
> Attached here is a plot. The vertical axis designates the value of
> rx_count variable from function musb_host_packet_rx(). One may see
> that there are only two possibilities: 0 bytes and 956 bytes.
> The horizontal axis is the last three digits of the timestamp when
> musb_host_packet_rx() invoked. I.e for [   38.115379] it is 379. Given
> that my webcam is USB 1.1 and base time is 1 ms, then all frames
> should be grouped close to some single value. (Repeating package
> receive event every 1 ms won't change last tree digits considerably)
> One may see that it is not true, in practice there are two groups. And
> receive time strongly correlates with the package size. Packages
> received near round ms are 956 bytes long, packages received near 400
> us are 0 bytes long.
>
> I don't know how exactly SOF and IN are synchronized in musb, could
> someone give a hint? But from what I see the time difference between
> subsequent IN package requests is sometimes more than 1 ms due to
> heavy urb->complete() callback. After such events only zero length
> packages are received. Surprisingly, that `synchronization' is
> recovered sometimes in the middle of URB like the following:
>
> [  163.207363] musb int
> [  163.207380] rx_count 0
> [  163.207393] req pkt c9c76200 // Expected musb int at 163.208393
> [  163.207403] int end
> // No interrupt at 163.208393
> [  163.209001] musb int
> [  163.209017] rx_count 956
> [  163.209108] req pkt c9c76200
> [  163.209118] int end
>
> And then the series of 956 bytes long packages are received until URB
> giveback will occasionally break it again.
> Do I understand correctly, that SOF is generated every 1 ms by
> hardware and should be followed by IN immediately?
> If so, it is not clear to me how they should be aligned when the time
> difference between to subsequent INs is greater than 1ms.
>
> --
> With best regards,
> Matwey V. Kornilov.
> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
