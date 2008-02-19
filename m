Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1K2jerh003241
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 21:45:40 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1K2j4Q8015656
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 21:45:04 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JRexC-0007do-TI
	for video4linux-list@redhat.com; Wed, 20 Feb 2008 02:45:02 +0000
Received: from 200-207-206-233.dsl.telesp.net.br ([200.207.206.233])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 02:45:02 +0000
Received: from fragabr by 200-207-206-233.dsl.telesp.net.br with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 02:45:02 +0000
To: video4linux-list@redhat.com
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Date: Tue, 19 Feb 2008 19:27:21 -0300
Message-ID: <20080219192721.1fb91780@tux.abusar.org.br>
References: <20080127173132.551401d9@tux.abusar.org.br>
	<20080128165403.1f7137e0@gaivota>
	<20080128182634.345bd4e8@tux.abusar.org.br>
	<20080128184534.7af7a41b@gaivota>
	<20080128192230.59921445@tux.abusar.org.br>
	<20080129004104.17e20224@gaivota>
	<20080129021904.1d3047d1@tux.abusar.org.br>
	<20080129025020.60fa33de@gaivota>
	<20080129050103.2fae9d61@tux.abusar.org.br>
	<20080129122547.63214371@gaivota>
	<37219a840802182044k5a24bcbbm3646560c595df564@mail.gmail.com>
	<20080219065109.199ee966@gaivota> <20080219133845.56fc5e7c@gaivota>
	<pan.2008.02.19.17.24.31.993112@gimpelevich.san-francisco.ca.us>
	<20080219182026.73bb270f@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080219182026.73bb270f@gaivota>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: When
 xc3028/xc2028 will be supported?
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

On Tue, 19 Feb 2008 18:20:26 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> # For firmware version 2.5, you can use the following procedure:
> #       1) Download the windows driver with something like:
> #               wget http://www.power-color.com/drivers/real_angel/RA330_Driver_and_Appl
> ication.zip
> #                       or
> #               wget ftp://driver1.cptech.com.tw/Driver/RA330TV/ra330_xp.zip

	The cx88vid.sys I provided is the exact same file as
cx88vid.sys from the above site ;).

	But, something probably went wrong with the extraction tool

Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Loading 60 firmware images from xc3028-v25.fw, type: xc2028 firmware, ver 2.5
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE F8MHZ (3), id 0, size=6621.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=6617.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Loading 60 firmware images from xc3028-v25.fw, type: xc2028 firmware, ver 2.5
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE F8MHZ (3), id 0, size=6621.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=6617.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE FM (401), id 0, size=6517.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=6531.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE (1), id 0, size=6611.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE MTS (5), id 0, size=6595.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type (0), id 100000007, size=161.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Firmware type INIT1 F8MHZ D2620 DTV7 (408a), id 2012d00022000 is corrupted (size=10946, expected 786712)
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Error: firmware file is corrupted!
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Releasing partially loaded firmware file.
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Loading 60 firmware images from xc3028-v25.fw, type: xc2028 firmware, ver 2.5
Feb 19 19:22:28 tux vmunix: xc2028 0-0061: Reading firmware type BASE F8MHZ (3), id 0, size=6621.
Feb 19 19:22:29 tux vmunix: xc2028 0-0061: Error on line 1070: -121

	With the previous xc3028-v25.fw you provided me everything is ok.

	The result .fw file is:

50763 Feb 19 19:20 xc3028-v25.fw

md5sum: a32040cb492ea1ee52772c51ec967525

-- 
Linux 2.6.24: Arr Matey! A Hairy Bilge Rat!
http://u-br.net http://www.abusar.org/FELIZ_2008.html


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
