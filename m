Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB18RCh9000956
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 03:27:12 -0500
Received: from QMTA07.emeryville.ca.mail.comcast.net
	(qmta07.emeryville.ca.mail.comcast.net [76.96.30.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB18QUZG014116
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 03:26:30 -0500
Message-ID: <49339FB1.7000700@personnelware.com>
Date: Mon, 01 Dec 2008 02:26:25 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <7d7f2e8c0811302255q3168bbe1yfcd075616d4d9fc6@mail.gmail.com>
In-Reply-To: <7d7f2e8c0811302255q3168bbe1yfcd075616d4d9fc6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: USB device for uncompressed NTSC capture
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

Steve Fink wrote:
> This may be the wrong place for this question. I've been looking at a
> number of places, but haven't managed to figure out what I need to
> know.
> 
> I have a camera that only has analog NTSC output. I would like to get
> the frames into my Linux laptop. The frames are 8-bit deep grayscale
> and 320x240. I assume that they are getting expanded up into NTSC
> format or something; I'm ok with that; I don't need it to be very
> accurate.
> 
> On my desktop box, I have a Hauppage WinTV PCI card that hands me the
> frames back via v4l. That works perfectly. I want to do the same on my
> laptop, only using USB rather than PCI for obvious reasons. (1394
> would be fine too. But I want something cheap.)

if it only has analog out, how will the 1394 help?

but cuz you say it will, first place I checked:
http://microcenter.com/single_product_results.phtml?product_id=0246465
2-Port FireWire 1394 CardBus PCMCIA Adapter RoHS
$35

I have seen cheaper.  i saw one in the bargin bin once for $10.   really should
have grabbed it.

Also, many laptops come with it.  not that that makes it cheap, but maybe you
could pick up an old one for $100 or less.  feel like messing with linux on ppc
mac?  (no clue if you can find a mac for under 100.)

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
