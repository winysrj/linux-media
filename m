Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ttabyss@gmail.com>) id 1M90o6-0002g4-5K
	for linux-dvb@linuxtv.org; Tue, 26 May 2009 19:51:23 +0200
Received: by ey-out-2122.google.com with SMTP id d26so828789eyd.17
	for <linux-dvb@linuxtv.org>; Tue, 26 May 2009 10:51:17 -0700 (PDT)
Message-ID: <4A1C2C0F.9090808@gmail.com>
Date: Tue, 26 May 2009 13:51:11 -0400
From: Chris Capon <ttabyss@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] EPG (Electronic Program Guide) Tools
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

Hi:
I've installed an HVR-1600 card in a Debian system to receive ATSC 
digital broadcasts here in Canada.  Everything works great.

scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB > channels.conf

	finds a complete list of broadcasters.

azap -c channels.conf -r "channel-name"

	tunes in the stations and displays signal strength info.

cp /dev/dvb/adapter0/dvr0 xx.mpg

	captures the output stream which can be played by mplayer.



What I'm missing is information about the Electronic Program Guide 
(EPG).  There doesn't seem to be much info on linuxtv.org on how to read it.

Where does the EPG come from?

Is it incorporated into the output stream through PID's some how or is 
it read from one of the other devices under adapter0?

Are there simple command line tools to read it or do you have to write a 
custom program to interpret it somehow?

Could someone please point me in the right direction to get started?  If 
no tools exist, perhaps links to either api or lib docs/samples?


Much appreciated.
Chris.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
