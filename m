Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 217-112-173-73.cust.avonet.cz ([217.112.173.73]
	helo=podzimek.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrej@podzimek.org>) id 1LOdLw-0005ZB-9U
	for linux-dvb@linuxtv.org; Sun, 18 Jan 2009 20:30:36 +0100
Message-ID: <49738339.9030203@podzimek.org>
Date: Sun, 18 Jan 2009 20:30:01 +0100
From: Andrej Podzimek <andrej@podzimek.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3 works,
	but keys get stuck
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

Hello, 

based on this enum in v4l/af9015.h

	enum af9015_remote {
		AF9015_REMOTE_NONE                    = 0,
		AF9015_REMOTE_A_LINK_DTU_M,
		AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
		AF9015_REMOTE_MYGICTV_U718,
		AF9015_REMOTE_DIGITTRADE_DVB_T,
	};

I added this line to /etc/modprobe.conf

	options dvb-usb-af9015 remote=2

After reloading the module, the remote control (almost) worked. Unfortunately, keys got stuck somehow, just as if I were holding a key on the keyboard. Another key press changed the event being repeated, but there seemed to be *no* key release events at all.

Pressing the channel up/down keys seemed to stop that key event flood, but both of my keyboards (one on the laptop and an external one) stopped working. Again, this may have been due to the absence of a key release event. (This time the key events were not that obvious, since channel up/down does not produce an alphanumeric key code.)

I use kernel 2.6.27.10, revision af9015-57423d241699 and (presumably) MSI Digivox Mini II V3.

Either I misunderstood / misconfigured something, or this could be a bug. I'm not familiar with this source code and don't have time to explore it in detail. However, feel free to ask for debugging output and other data you may need.

Regards,

Andrej Podzimek

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
