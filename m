Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MH3Oie018675
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 13:03:24 -0400
Received: from web27912.mail.ukl.yahoo.com (web27912.mail.ukl.yahoo.com
	[217.146.182.62])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3MH38V3019920
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 13:03:08 -0400
Date: Tue, 22 Apr 2008 18:03:02 +0100 (BST)
From: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080422132139.1e8e5f4a@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <542613.5449.qm@web27912.mail.ukl.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

--- Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Edward,
> 
> Thanks for your report.
> 
> There were lots of changes on em28xx driver those days, although I
> agree that
> the only one that would affect just audio is the one you've pointed.
> If you
> just revert this changeset, does the audio work again?
> 
Hi Mauro

I updated to changeset 7673 and reversed 7651, and got a fully working
driver. These are the firmware loading messages from the working
driver:

(insert stick)
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.

(start mplayer - missing from first pastebin)
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
0000000000000000.
xc2028 1-0061: Loading firmware for type=MTS (4), id 0000000000000010.

--

Edward Sheldrake


      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
