Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0J8SmiC012316
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 03:28:48 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0J8SUMR027480
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 03:28:31 -0500
Date: Mon, 19 Jan 2009 09:26:10 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Brian Marete" <bgmarete@gmail.com>
Message-ID: <20090119092610.65a2a90a@free.fr>
In-Reply-To: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
References: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Video4linux-list <video4linux-list@redhat.com>
Subject: Re: Problem streaming from gspca_t613 Webcam
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

On Mon, 19 Jan 2009 03:29:29 +0300
"Brian Marete" <bgmarete@gmail.com> wrote:

> Hello,
> 
> I have a USB camera using the gspca_t613 driver. Its vendor/model ID
> is 17a1:0128.
> 
> I am using kernel 2.6.28.1
> 
> I get a blank screen when I try to access it from skype or aMSN, and
> the following MPlayer commands gives a constant stream of "select
> timeout" error messages:
> mplayer tv:// -tv
> device=/dev/video0:driver=v4l2:outfmt=mjpeg:fps=7:width=640:height=480
> 
> Loading the gspca module with the option debug=511 gives the following
> output in the kernel log from module load to a couple of minutes of
> the above MPlayer command:
> 
> Jan 19 01:55:28 oqb kernel: [   93.376076] usb 3-2: new full speed USB
> device using uhci_hcd and address 3
> Jan 19 01:55:28 oqb kernel: [   93.533862] usb 3-2: configuration #1
> chosen from 1 choice
> Jan 19 01:55:28 oqb kernel: [   93.718772] Linux video capture
> interface: v2.00 Jan 19 01:55:28 oqb kernel: [   93.749063] gspca:
> main v2.3.0 registered
	[snip]

Hello Brian,

You should get a newer version of gspca. Look at the gspca_README.txt
in my page (see below).

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
