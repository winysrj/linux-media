Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <COL103-W528F8A33AD6A34779DB71888340@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <dheitmueller@kernellabs.com>
Date: Thu, 25 Jun 2009 10:59:01 -0400
In-Reply-To: <829197380906250738x36483ee3sb747019a4d1f23c4@mail.gmail.com>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
	<829197380906250700s3f96262bhad95e9a758e88d3f@mail.gmail.com>
	<COL103-W2753C79E5C866460426A1888340@phx.gbl>
	<829197380906250738x36483ee3sb747019a4d1f23c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: hverkuil@xs4all.nl, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: RE: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick -
 what 	am I doing wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>


Can I ask a much more mundane question?  I'm sure there's a simple answer=
=2C but all my googling hasn't shown it to me yet.=20



When this card works=2C I use it with Helix Producer to generate video for =
RealPlayer.  A command like this starts the encoding:



> LD_PRELOAD=3D/usr/local/lib/libv4l/v4l1compat.so /usr/local/helix/produce=
r/producer -vc /dev/video0 -vp 0 -ac 0 -ap 'line'



However=2C Helix Producer is unable to change the channel on the device.=20
It can only grab whatever the card is currently tuned to.  (This is a
closed-circuit coax feed within our building=2C broadcasting on analog
channel 3). =20



And for the life of me=2C I can't find a program or utility that will let
me change the analog cable channel my tuner card picks up.  I've seen
various utilities for scanning and changing digital channels (e.g.
w_scan)=2C but none that seem to apply to old NTSC channels.  The silly
workaround that I have to do is sit at the console=2C fire up X=2C launch
"tvtime"=2C change it to channel 3=2C then quit "tvtime".  Then Helix
Producer can record off that channel. =20



Surely there must be some command-line way to change the Pinnacle device to=
 channel 3 before I launch Helix Producer?



Thanks!


_________________________________________________________________
Windows Live=99: Keep your life in sync.=20
http://windowslive.com/explore?ocid=3DTXT_TAGLM_WL_BR_life_in_synch_062009=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
