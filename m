Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JLLBsP026630
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 16:21:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1JLKbVi030689
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 16:20:37 -0500
Date: Tue, 19 Feb 2008 18:20:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Message-ID: <20080219182026.73bb270f@gaivota>
In-Reply-To: <pan.2008.02.19.17.24.31.993112@gimpelevich.san-francisco.ca.us>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Hi Daniel,

On Tue, 19 Feb 2008 09:24:32 -0800
Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us> wrote:

> On Tue, 19 Feb 2008 13:38:45 -0300, Mauro Carvalho Chehab wrote:
> 
> > Could you please rebase your changesets fixing the gpio's for PowerColor Real
> > Angel 330 and send them to me?
> 
> I intend to do exactly that sometime within the next couple of weeks.

I've contacted Dâniel Fraga and fixed the remaining issue with his PowerColor
Real Angel 330: firmware should be version 2.5 in order to work. He also
confirmed that the GPIOs are the same as yours for his board.

I've already committed the fixes for it at cx88-xc3028. On his board, both radio
and TV worked fine.

To make easier for all I've changed the firmware extracting tool
to get the firmwares from cx88vid.sys. The extracting tool, and the generated
firmware still needs to be tested.

Dâniel & Daniel, could you please test ? Hopefully, I didn't make any mistake
when changing the extracting tool ;)

The tool is available at:

linuxt/Documentation/video4linux/extract_xc3028.pl

The instructions for usage written at the beginning of the file:

# For firmware version 2.5, you can use the following procedure:
#       1) Download the windows driver with something like:
#               wget http://www.power-color.com/drivers/real_angel/RA330_Driver_and_Appl
ication.zip
#                       or
#               wget ftp://driver1.cptech.com.tw/Driver/RA330TV/ra330_xp.zip
#
#       2) Extract the file cx88vid.sys from the zip into the current dir:
#               unzip -x RA330_Driver_and_Application.zip "Real Angel Driver & Application/Driver/Plug_Play/cx88vid.sys"
#       3) run the script:
#               ./extract_xc3028.pl cx88vid.sys
#       4) copy the generated file:
#               cp xc3028-v25.fw /lib/firmware

The real test were done using Dâniel's cx88vid.sys from his CD. I expect that
the site has the same file, otherwise, md5 will fail, and the firmware won't
be extracted.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
