Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm21-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.209]:37148 "HELO
	nm21-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751274Ab2BLIdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 03:33:55 -0500
Message-ID: <1329035221.45427.YahooMailClassic@web39301.mail.mud.yahoo.com>
Date: Sun, 12 Feb 2012 00:27:01 -0800 (PST)
From: Jan Panteltje <panteltje@yahoo.com>
Subject: Request to move the DVB-infrared remote output to for example /dev/dvb/adaptorX/irX
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Reason:
The current output from IR remotes in DVB seems to go to /dev/input/eventX
This causes huge problems with other applications,
because the pressed keys appear in those applications as input,
even if no DVB application is running,
all that is required is that the DVB USB device is plugged in (that will load the related modules).

An example of disaster caused by the current system:

You are filling in your tax form.
Kid pressed some keys on the remote, it has 100 ms auto repeat.
Your income is now 20 digits, most of those '9', the form is closed,
and send.

You are bidding on an item on ebay, you got it for 10 million dollars now.
Try explaining that to a seller.

You are watching a movie with mplayer, it exits because for example you went past EOF,
or audio video sync suddenly changes, what not.
Same for xine, and if those are run full screen it is a 100% hit every time.

Basically the /dev/input/eventX goes to any application or application input field that
has the focus in that moment.
That does not have to be visible at all to the user!

This behavior in itself I already consider a fatal bug or design flaw.

The other issue is that, with USB DVB devices, it is possible to have more than one connected
(I have 2, terrestrial and satellite), and it would make a lot more sense to get the IR
codes from /dev/dv/adaptorX/IR..X from a consistency POV. (and ONLY when you open that device for read).

I know about the possibility to grab the output for an application all by itself
with ioctl(), but this requires the DVB application to actually be started.
The /dev/input/ method dumps data to inputs without ANY DVB application started.
BAD.

Well, I have stated my concern, I can work around this myself I think,
but for normal users this can cause big havoc.
Even if you throw away the DVB remote, there are many other remotes in the room,
DVD player, TV, etc, and it cannot be guaranteed that no codes from those will not mess up
input fields (and CLOSE THESE causing actions taken !!!!) in some application.


