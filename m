Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1LH5Kv-0001ZK-IR
	for linux-dvb@linuxtv.org; Mon, 29 Dec 2008 00:46:22 +0100
Message-ID: <49580FAB.2000003@rogers.com>
Date: Sun, 28 Dec 2008 18:45:47 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Mark Jenks <mjenks1968@gmail.com>
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>	<1230500176.3120.60.camel@palomino.walls.org>
	<e5df86c90812281451o111e3ebem77c7d9bb8469e149@mail.gmail.com>
In-Reply-To: <e5df86c90812281451o111e3ebem77c7d9bb8469e149@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
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

Mark Jenks wrote:
>
>
> On Sun, Dec 28, 2008 at 3:36 PM, Andy Walls <awalls@radix.net
> <mailto:awalls@radix.net>> wrote:
>
>     If one of these devices only has DVB support and no analog V4L
>     support,
>     then it would make sense why one of them would have "h->video_dev" set
>     to NULL.  The device shouldn't have a V4L2 "video_dev" if it doesn't
>     support analog (V4L2) devices.  I believe the 1800 supports analog
>     video
>     but the 1250 does not (someone correct me on this if I'm wrong -
>     I'm no
>     expert on these devices).
>
>
> Andy,
>  
> You are correct.  They are both are cx23885 cards, and only one of
> them has an analog input to it. The 1250 is a DVB and the 1800 is DVB,
> but is a MCE card with analog(svideo, etc), in.
>

The HVR-1250 device itself supports analogue, but such support is not
yet realized within the cx23885 driver.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
