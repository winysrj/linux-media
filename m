Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4B3kXme015203
	for <video4linux-list@redhat.com>; Sun, 10 May 2009 23:46:33 -0400
Received: from smtp115.rog.mail.re2.yahoo.com (smtp115.rog.mail.re2.yahoo.com
	[68.142.225.231])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n4B3kJh7016386
	for <video4linux-list@redhat.com>; Sun, 10 May 2009 23:46:19 -0400
From: William Case <billlinux@rogers.com>
To: CityK <cityk@rogers.com>
In-Reply-To: <4A077247.8030305@rogers.com>
References: <1241982336.31677.0.camel@localhost.localdomain>
	<4A077247.8030305@rogers.com>
Content-Type: text/plain
Date: Sun, 10 May 2009 23:45:32 -0400
Message-Id: <1242013532.3277.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: Hauppauge WinTV-hvr-1800 PCIe won't work with tvtime or mplayer.
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

Hi CityK;

On Sun, 2009-05-10 at 20:33 -0400, CityK wrote:
> William Case wrote:

> Note: cx88 associated modules do NOT apply to this device (cx88 driver
> modules are for the PCI based cx2388x chipsets, where x=0/1,2,3).  This
> is a PCIe based device which is serviced, amongst others, by the cx23885
> driver module. 

I have removed all the extra modules I have been playing with and
removed any modprobe instructions I had been trying.

> 
> Also, have a look in the wiki for the device article which appears to
> contain some info that would be useful for you.

I re-installed v4l-dvb-4c7466ea8d64.tar.bz2, as suggested on the wiki.
The extracted files are in /lib/modules/["kernel
version"]/kernel/drivers/media with today's installation date. (last
modified)

> With a hardware encoding device, the /dev/video0 should be the MPEG2
> stream whereas /dev/video1 would be the raw stream compatible with apps
> like tvtime.  mplayer /dev/video0 should work. .... note that the node
> number (N) of the character device (/dev/videoN) will be different if
> you have multiple devices installed in the system, so you will have to
> adjust accordingly.

I am trying to set up analog viewing through my cable provider.
tvtime.xml is set to video0. It still gives me an excellent picture but
no sound. video1 just gives me a black screen - no sound.

On mplayer device=/dev/video0 remains the same --terrible picture; no
sound. mplayer device=/dev/video0 produces the error message 
'vo: x11 uninit called but X11 not initialized..' and quits.

The mplayer script I am using is a slightly modified copy of the command
suggested on the wiki.

Basically the info I submitted originally remains the same except the
cx2388x modules are gone.

Usually I like to work away at these kind problems until I conquer them
myself.  But I have been on this one for over two weeks and I am driving
myself to distraction.  I really do appreciate your time and advice.

-- 
Regards Bill
Fedora 10, Gnome 2.24.3
Evo.2.24.5, Emacs 22.3.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
