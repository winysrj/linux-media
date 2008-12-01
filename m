Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB16tDgl003904
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 01:55:13 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB16t1f8003140
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 01:55:02 -0500
Received: by rv-out-0506.google.com with SMTP id f6so2652711rvb.51
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 22:55:01 -0800 (PST)
Message-ID: <7d7f2e8c0811302255q3168bbe1yfcd075616d4d9fc6@mail.gmail.com>
Date: Sun, 30 Nov 2008 22:55:01 -0800
From: "Steve Fink" <sphink@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: USB device for uncompressed NTSC capture
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

This may be the wrong place for this question. I've been looking at a
number of places, but haven't managed to figure out what I need to
know.

I have a camera that only has analog NTSC output. I would like to get
the frames into my Linux laptop. The frames are 8-bit deep grayscale
and 320x240. I assume that they are getting expanded up into NTSC
format or something; I'm ok with that; I don't need it to be very
accurate.

On my desktop box, I have a Hauppage WinTV PCI card that hands me the
frames back via v4l. That works perfectly. I want to do the same on my
laptop, only using USB rather than PCI for obvious reasons. (1394
would be fine too. But I want something cheap.)

What devices are supported that would give me what I need? I scrounged
around on the linuxtv wiki and various other places, but it seems like
all of the USB sticks with analog inputs were doing fancy mpeg-2
compression, which kinda sucks for me:  I'm not saving the frames
anywhere, I'm processing them as they come in. So I'd rather not have
them compressed and then decompressed immediately. Also, although
quality isn't that big of a concern for me, latency is.

I don't need audio, TV tuning, a remote, or any of the other usual
crud that these things seem to have. I just want to get a stream of
frames at a rather low resolution, with the bits relatively
unmolested. I suspect that there may be many USB devices that would do
this for me, but for the life of me I can't figure out how to tell
which ones they are.

I am currently running the 2.6.26 kernel that comes with Fedora 9
(2.6.26.6-79.fc9.i686), but I'm happy to upgrade, downgrade, or
compile my own drivers.

My code is currently using v4l (either v4l1 or v4l2, autodetected).
I've never understood the V4L vs DVB thing, but I could switch to a
different API if necessary.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
