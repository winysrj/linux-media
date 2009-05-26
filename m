Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:55414 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZEZSSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 14:18:22 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1014861eyd.37
        for <linux-media@vger.kernel.org>; Tue, 26 May 2009 11:18:22 -0700 (PDT)
Message-ID: <4A1C3268.2090905@gmail.com>
Date: Tue, 26 May 2009 14:18:16 -0400
From: Chris Capon <ttabyss@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: EPG (Electronic Program Guide) Tools
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi:
I've installed an HVR-1600 TV card in a Debian system to receive ATSC
digital broadcasts here in Canada.  Everything works great.

scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB > channels.conf

	finds a complete list of broadcasters.

azap -c channels.conf -r "channel-name"

	tunes in the stations and displays signal strength info.

cp /dev/dvb/adapter0/dvr0 xx.mpg

	captures the output stream which can be played by mplayer.



What I'm missing is information about the Electronic Program Guide
(EPG).  There doesn't seem to be much info on linuxtv.org on how to read 
it.  Googling hasn't produced meaningful clues.

Where does the EPG come from?

Is it incorporated into the output stream through PID's some how or is
it read from one of the other devices under adapter0?

Are there simple command line tools to read it or do you have to write a
custom program to interpret it somehow?

Could someone please point me in the right direction to get started?  If
no tools exist, perhaps links to either api or lib docs/samples?


Much appreciated.
Chris.
