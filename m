Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JnWJx-0008VP-Jv
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 11:58:56 +0200
Message-ID: <480B13C8.1010301@iki.fi>
Date: Sun, 20 Apr 2008 12:58:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>	<47FA3A7A.3010002@iki.fi>
	<47FAFDDA.4050109@iki.fi>	<c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>	<47FC373F.5060006@iki.fi>	<c4e36d110804090130s5b66a357s3ec754a1d617b30@mail.gmail.com>	<47FCE5FB.9080003@iki.fi>	<c4e36d110804090905t3574e09ao8cadadacc9c12080@mail.gmail.com>
	<c4e36d110804191724j47b6e39byda88f2ed8707bd28@mail.gmail.com>
In-Reply-To: <c4e36d110804191724j47b6e39byda88f2ed8707bd28@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

Zdenek Kabelac wrote:
> I've tried to replace .usb_ctrl wth CYPRESS_FX2
> But didn't get much futher:

To AF9015 module? (seen logs)

Looks like you are trying to do it totally wrong way.
You should not use AF9015 at all because your device has CY7C68013 
(AF9015 is "replaced" by CY7C68013).

- CY7C68013 USB-bridge - driver unknown (USB-protocol used depends 
firmware used by this chip. If we have luck there is used protocol that 
has already driver)
- AF9013 demodulator - driver exists
- TDA18271 tuner - driver exists

> Will I need to do any additional modification - any different firmware
> for download ?

Most likely.

> Is there any guide how to trace the driver in Windows - does anyone
> have any experience to use qemu-kvm for this - will this even work ?

There is some help in linuxtv.org wiki.

But here is list of tools I and many other use generally when debugging 
Windows drivers:

USB Snoop
For sniffing USB-data in Windows
http://benoit.papillault.free.fr/usbsnoop/

Usbreplay
For parsing usbsnoop logs and replaying data to device
http://mcentral.de/wiki/index.php5/Usbreplay

VMware Workstation & Player
For running Windows in virtual machine. Supports USB2.0.
http://vmware.com/

Transedit MMC
For tuning to frequency & showing stream information
http://www.dvbviewer.com/en/index.php?page=downloads

> Technilly it looks similar to Leadtek Winfast Gold from this discussion:
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg30055.html

No. This was only changing to new tuner. You have totally different 
device and situation.

> But I'm so far lost how the thing should be initialized.
> 
> Zdenek

If you can take some Windows sniffs, for example one when plug stick and 
other when tuning successfully to channel, I can try to look what kind 
of USB-protocol is used.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
