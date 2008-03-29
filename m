Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2TMpM9I015608
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 18:51:22 -0400
Received: from S1.cableone.net (s1.cableone.net [24.116.0.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2TMpAnE018152
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 18:51:11 -0400
Received: from [72.24.208.253] (unverified [72.24.208.253])
	by S1.cableone.net (CableOne SMTP Service S1) with ESMTP id
	150317929-1872270
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 15:51:05 -0700
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: video4linux-list@redhat.com
Date: Sat, 29 Mar 2008 17:49:10 -0500
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
In-Reply-To: <20080329052559.GA4470@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803291749.10451.vanessaezekowitz@gmail.com>
Subject: Re: [PATCH 0 of 9] videobuf fixes
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

On Saturday 29 March 2008 12:25:59 am Brandon Philips wrote:
> > I've opened 3 mplayer windows, reading /dev/video0. I closed the second one and
> > opened again. I got an error:
> 
> Shouldn't V4L2 devices not be able to stream to multiple applications at
> once?  Quoting the spec:

I'm not exactly on top of current driver development, so I apologize if this response if misdirected.

I disagree with the proposal.

In certain instances, it is desirable for more than one application at a time to read from a stream (provided both are receiving the exact same stream, i.e. without lost/duplicate frames).  The case could be argued that one may want to use a command-line tool set like mjpegtools and ffmpeg to record a stream, while using xawtv to view the stream.  In point of fact, I've done this myself and have found it incredibly handy.

I can see how it would be especially useful on machines with fewer resources than are needed for complex applications like mythtv.

> "V4L2 drivers should not support multiple applications reading or
> writing the same data stream on a device by copying buffers, time
> multiplexing or similar means. This is better handled by a proxy
> application in user space. When the driver supports stream sharing
> anyway it must be implemented transparently. The V4L2 API does not
> specify how conflicts are solved."

Rather that lose a useful capability, why not just extend the spec to allow for it (and the potential error condition of course)?  It's not as though all of the applications prior to this would suddenly stop working once you do.

-- 
"Life is full of happy and sad events.  If you take the time
to concentrate on the former, you'll get further in life."
Vanessa Ezekowitz  <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
