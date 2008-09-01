Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KaHdJ-0005Xo-9d
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 00:12:27 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	C2A9618001D5
	for <linux-dvb@linuxtv.org>; Mon,  1 Sep 2008 22:11:49 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Laurence Huizinga" <lhuizinga@iinet.net.au>
Date: Tue, 2 Sep 2008 08:11:49 +1000
Message-Id: <20080901221149.B913547808F@ws1-5.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Compro DVB T300 Card support under ArchLinux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Hi,
> Was wondering if anyone knew what was necessary to get a compro dvb t-300
> card working with Freevo, with Archlinux as a base.  Do i need to download
> firmware etc.  My LC17 Box will be running at 64-bit on an intel 945 board
> with p4-D 3.0Ghz.  Have only installed Archlinux as yet.
> 
> Is there support for this card in the latest kernels (and is there
> anectdotal evidence of it working in Freevo or Myth if I have to, or
> should i look at another (newer) card)?  Obviously i will really only be
> interested in the digital tv tuner part of this hybrid card, and the video
> capture function. Cheers,
> Larry

Larry,

Is this the card, you are referring to:
http://www.comprousa.com/en/product/e300/e300.html

If so at the moment I'm writing patches that should add support for this card.

Could you please read this and complete the steps that I have listed for your card:
http://linuxtv.org/pipermail/linux-dvb/2008-August/028090.html

If the details generated are similar to:
http://linuxtv.org/wiki/index.php/Compro_VideoMate_E650
Or
http://linuxtv.org/wiki/index.php/Compro_VideoMate_E800F
You can try the other links below to see if it will work.

Read (At the bottom, or you can catch up on the conversation, note that the main v4l-dvb tree should now be used instead of the cx23885-leadtek tree):
http://linuxtv.org/pipermail/linux-dvb/2008-August/028233.html
And do the steps listed, please provide the requested feedback to me.

Then if this does not work read this one (At the bottom, or you can catch up on the conversation):
http://linuxtv.org/pipermail/linux-dvb/2008-August/028341.html
And same deal the feedback would be great.

As I do not own any of the cards referenced above the previous links provide me with the required information to get the DVB-T side of the card working.

At least one person has the E800 working in MythTV (the DVB-T is the same on both cards) so I do not see any issues. I'm not familiar with Arch Linux or Freevo, but give it a try.

Thanks, for your time.

Stephen.




-- 
Nothing says Labor Day like 500hp of American muscle
Visit OnCars.com today.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
