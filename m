Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stuart.langridge@gmail.com>) id 1JOE0f-00069o-RL
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 16:22:26 +0100
Received: by wa-out-1112.google.com with SMTP id m28so1504832wag.13
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 07:22:17 -0800 (PST)
Message-ID: <4c91566f0802100722l313413e4y52eb1058e1614470@mail.gmail.com>
Date: Sun, 10 Feb 2008 15:22:17 +0000
From: "Stuart Langridge" <sil@kryogenix.org>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Freecom DVB-T USB adapter not recognised
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have a Freecom DVB-T USB adapter, listed in lsusb as:

aquarius@tv:~$ lsusb
Bus 004 Device 003: ID 14aa:0161 AVerMedia (again) or C&E

it does not seem to be being recognised by the kernel when I plug it
in. http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices#Freecom_rev_4_DVB-T_USB_2.0_tuner
suggests that the latest revision of this device isn't yet supported,
but doesn't list the above device ID (14aa:0161). It does list
14aa:0160 as unsupported, though; how can I find out whether my device
is the same? Also, what needs to happen for the device to be
supported? Is it just a question of finding an appropriate firmware
file and dropping it in /lib/firmware, or does the driver itself in
the kernel need to be hacked on to make the device work?

sil

-- 
New Year's Day --
everything is in blossom!
I feel about average.
   -- Kobayashi Issa

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
