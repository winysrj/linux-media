Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S4tdc4023033
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 00:55:39 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9S4tRtm025268
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 00:55:27 -0400
Received: by ug-out-1314.google.com with SMTP id j30so402412ugc.13
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 21:55:26 -0700 (PDT)
Date: Tue, 28 Oct 2008 13:55:33 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Pete Eberlein <pete@sensoray.com>
Message-ID: <20081028135533.4cfad1b9@glory.loctelecom.ru>
In-Reply-To: <1225124312.4423.21.camel@pete-desktop>
References: <1225124312.4423.21.camel@pete-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134 empress: simultaneous capture
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

Hi Pete

> I'm working with a board that has a saa7134 chip with a go7007 mpeg
> encoder.  I've modified the saa7134 driver to detect the board and
> load the saa7134 go7007 driver from GregKH's staging patch.  I think
> this works similar to the saa7134 empress driver.
> 
> The raw video is on /dev/video0 and the mpeg compressed video is
> on /dev/video1.  Video capture from each video device works fine
> individually, but when I try to capture from both devices
> simultaneously, the mpeg compressed stream goes blank (select timeout
> - as if there is no video signal.)
> 
> Can anyone tell me if simultaneous capture works for a saa7134 empress
> based board?  Is there a reason I shouldn't expect this to work?

Try start and save data from /dev/video1
cat /dev/video1 > test.dat

If data in the file test.dat consist 0x00 or 0x80 you have raw  YUV channel data for /dev/video0.
Check the file /linux/drivers/media/video/saa7134/saa7134-core.c

If you have this source. That's incorrect definition of IRQ.
 /* TS capture -- dma 5 */
if (dev->ts_q.curr) {
ctrl |= SAA7134_MAIN_CTRL_TE5;
 irq |= SAA7134_IRQ1_INTE_RA2_3 |
 SAA7134_IRQ1_INTE_RA2_2 |
 SAA7134_IRQ1_INTE_RA2_1 | 
 SAA7134_IRQ1_INTE_RA2_0;
} 

SAA7134_IRQ1_INTE_RA2_3 and SAA7134_IRQ1_INTE_RA2_2 are used for planar video,
not for TS.

Correct source

 /* TS capture -- dma 5 */
if (dev->ts_q.curr) {
ctrl |= SAA7134_MAIN_CTRL_TE5;
 irq |= SAA7134_IRQ1_INTE_RA2_1 |
SAA7134_IRQ1_INTE_RA2_0;
} 

This patch submitted Tue Aug 26 18:47:10 2008 +0200 (2 months ago) changeset 8796	a86838411eb2

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
