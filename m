Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAALk3dB007285
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 16:46:03 -0500
Received: from host7.webserver1010.com (host7.webserver1010.com
	[209.239.40.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAALjpIf012022
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 16:45:51 -0500
Received: from glaun.com (localhost [127.0.0.1])
	by host7.webserver1010.com (8.12.11.20060614/8.12.10) with ESMTP id
	mAALjobB020374
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 16:45:50 -0500
From: "Asher Glaun" <asher@glaun.com>
To: video4linux-list@redhat.com
Date: Mon, 10 Nov 2008 17:45:50 -0400
Message-Id: <20081110214550.M62106@glaun.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Subject: saa7134  Sabrent TVFM. Changes to radio?
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

Everything but radio works, i.e. all inputs, TV tuner, audio etc. Command line
client “radio” and “gnomeradio” both show signal strength and audio is FM
static hiss so I’m sure I’m receiving a signal but cannot tune the card.
Changing the frequency in the clients does nothing.

I load modprobe saa7134 card=42 tuner=68 radio_nr=0. This creates /dev/radio0
which is where I point “radio” and “gnomeradio”.  Wrote a script to cycle
through all the tuners, still the same static. Dual boot machine and radio
works flawlessly in MS Vista.

I contacted to Michael Rodríguez-Torrent, an original developer of
saa7134-cards.c and he says that the radio was the first thing he got working
and that since everything else works he might suspect some changes that are
causing problems.  He writes ..

“Your best shot might be a post to the mailing list asking what could have
changed with regards to the handling of radios in the module and how the board
definition can be updated to reflect that.”

Any help will be appreciated.

Thanks,
Asher.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
