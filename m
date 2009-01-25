Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1LR39U-0000YH-88
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 12:27:45 +0100
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	3391A18001A3
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 11:27:37 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Wayne and Holly" <wayneandholly@alice.it>
Date: Sun, 25 Jan 2009 21:27:37 +1000
Message-Id: <20090125112737.45A011BF28D@ws1-10.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast PxDVR3200 H
Reply-To: linux-media@vger.kernel.org
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

> Hello list,
> I have a Leadtek WinFast PxDVR3200 H that I am attempting to utilise with
> MythTV.  The Wiki site states that experimental support exists for the DVB
> side and that "Successful tuning of typical Australian channels" has been
> achieved.
> I am able to create a channels.conf (attached) using scan, and am then able
> to tune using mythtv-setup, however none of these channels are viewable with
> the mythfrontend due to it being unable to gain a lock.
> 
> Relevant bits and pieces:
> 
> scan, using the latest it-Varese file scan is able to tune to three of the
> five transponders as per the attached file "scan".  It also scans on
> 800000000Hz but I have no idea why.
> 
> The file leadtek.dmesg contains the relevant info from dmesg (and
> messages.log) regarding the initialisation of the card itself.  There are no
> error messages at any time (that I am aware of) despite all of my fiddling
> about.
> 
> Of the three transponders that are in my channels.conf file, the third one
> (618000000Hz) causes an error when tuning in mythtv-setup.  It states that
> channels are found but the tsid is incorrect.  As such, only the first two
> successful transponders (706000000 and 602000000) are tuned by myth.
> 
> When I attempt to view the tuned channels, myth is unable to gain a lock on
> any of them.  The reported signal strength is about 58% and the S/N varies
> between 3 and 3.8dB.  I am able to tune DVB-T channels on my TV using the
> same aerial cable but am wondering if signal strength is an issue.
> 
> I am running it on Kubuntu with a 2.6.24-19 kernel, I have a recent version
> of the v4l-dvb tree (approx Nov 08) and am using firmware version 2.7.  I
> haven't updated the drivers or the firmware as I have no reason to believe
> there are changes that would effect this.  That said, if someone thinks
> there has been changes I will get straight on it.
> 
> I am more than happy to provide more debugging info if required (if you are
> willing to tell me where else to look) and appreciate any help provided.
> 
> Cheers
> Wayne

Wayne,

Can you load the cx23885 and tuner_xc2028 module with debug enabled and provide the dmesg output.

You can do this by putting the following lines in /etc/modprobe.d/options
options tuner_xc2028 debug=1
options cx23885 debug=1

Can you split the dmesg output into the following sections:
1) Initial boot up or first module load
2) First access of the card for tuning/scanning
3) while scanning for channels with scan-dvb
4) while scanning for channels with MythTV
5) while trying to tune channels with MythTV

Have you tried to watch TV with xine or other non-MythTV programs? (at one stage I did have a problem with MythTV but it worked in gxine).

Regards,

Stephen.

-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
