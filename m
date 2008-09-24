Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kibdn-0005Ux-Mh
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 23:11:20 +0200
From: Darron Broad <darron@kewl.org>
To: Janne Grunau <janne-dvb@grunau.be>
In-reply-to: <200809242204.09153.janne-dvb@grunau.be> 
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
	<8C08530B-BAD7-4E83-B1CA-6AB66EE9F53F@ginandtonic.no>
	<7674.1222283382@kewl.org> <200809242204.09153.janne-dvb@grunau.be>
Date: Wed, 24 Sep 2008 22:11:16 +0100
Message-ID: <9043.1222290676@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <200809242204.09153.janne-dvb@grunau.be>, Janne Grunau wrote:

lo

>On Wednesday 24 September 2008 21:09:42 Darron Broad wrote:
>> The problem in mythtv appears to be in OpenV4L2DeviceAsInput(void)
>> where is opens the video device twice although I have no confirmed
>> it.
>
>If that's the case and the tvtime && cat test supports it it's more a 
>driver issue than an issue in mythtv. Using different fd for 
>controlling (ioctl) and data transfer (read) is fine and works with 
>other drivers.

What we are seeing here is in cx88-video and doesn't seem specific
to any cx88 card as such but I don't have any other card to test
therefore there is no evidence either way that this is a hvr-4000
only problem as yet, but more tests ought to be done.

As far as that function is concerned, my point is that it
appears to be raising the fault.

When testing tvtime & cat /dev/video0 what occurs is an
an open, EBUSY read, then a release. The release here
always puts the tuner in standby whether the previous
read was valid or not. This seems to be the bug as previously
pointed out.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
