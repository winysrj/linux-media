Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <20932892.1220359551794.JavaMail.root@elwamui-sweet.atl.sa.earthlink.net>
Date: Tue, 2 Sep 2008 08:45:51 -0400 (GMT-04:00)
From: William Melgaard <piobair@mindspring.com>
To: Matyas Sustik <linux-dvb.list@sustik.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, stev391@email.com
Subject: Re: [linux-dvb] Fusion HDTV 7
Reply-To: William Melgaard <piobair@mindspring.com>
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

This refers to the Dual Express card.
I have a (FusionHDTV7) RT Gold card. On August 1,I received instructions from Steve to:
1. run dscaler regspy under Windows & record values for the wiki page
2. run 'lspce -vnn' in Linux & copy the values to the wiki page.
3. take High Resolution pictures of it for the wiki page
4. Record major components

I did the above, except that dscaler does not recognize the RT Gold, and I need more specific instructions for use with 'regspy'.  I received a message from the linux-dvb administrator that my reply (including the pictures) exceeded the 2Mb message limit, so I don't know what happened to that information.

Additional advice would be appreciated.

William

-----Original Message-----
>From: Matyas Sustik <linux-dvb.list@sustik.com>
>Sent: Aug 30, 2008 8:33 PM
>To: Michael Krufky <mkrufky@linuxtv.org>
>Cc: linux-dvb@linuxtv.org
>Subject: Re: [linux-dvb] Fusion HDTV 7
>
>Thanks for your comments!
>
>I can report that the card receives OTA HD channels.  Both tuners
>work (at the same time) allowing two HD channels to be received.
>(azap/mplayer and mythtv both work.)
>
>The last missing piece was with the firmware.  A script which came
>with the firmware files from www.steventoth.net placed the firmware
>file dvb-fe-xc5000-1.1.fw to /lib/firmware/2.6.26-amd64 instead of
>/lib/firmware.  This may be distro specific.
>
>I could have figured all this out by the available docs and reading
>the logs.  However here is a list of what may improve the documentation:
>
>1.  Emphasize that other than the card module (in my case cx23885) need
>to be reloaded for compatibility between modules.  Therefore the compile
>from sources and reboot is needed.  (Easier than to find, remove and reload
>all the relevant modules.)
>
>2.  The firmware file has to be hunted down.  In my case the manufacturer
>provides .exe files only (maybe self-extracting) so I could not get the
>firmware that way.  Why not just have a page with the firmware files
>themselves?  The need for the firmware file also could be emphasized.
>(This is apparent if one reads the logs.)
>
>Some info on what should be in the logs when the card works:
>
>CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Express
>[card=10,autodetected]
>DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)..
>
>xc5000: Successfully identified at address 0x64
>xc5000: Firmware has not been loaded previously
>
>xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
>firmware: requesting dvb-fe-xc5000-1.1.fw
>xc5000: firmware read 12332 bytes.
>xc5000: firmware upload
>
>Thanks again,
>Matyas
>-
>Every hardware eventually breaks.  Every software eventually works.
>
>_______________________________________________
>linux-dvb mailing list
>linux-dvb@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
