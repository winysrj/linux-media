Return-path: <linux-media-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:40042 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaBBSjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Feb 2014 13:39:36 -0500
Message-ID: <52EE8ACA.2070109@inf.u-szeged.hu>
Date: Sun, 02 Feb 2014 19:13:30 +0100
From: Zoltan Arvai <zarvai@inf.u-szeged.hu>
MIME-Version: 1.0
To: mchehab@redhat.com
CC: linux-media@vger.kernel.org
Subject: r820t possible bug
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi Mauro!

In the past few days I configured my Thinkpad T61 14'1 notebook to use 
rtl2832+r820t tuneres. It seems something could be wrong that related to 
r820t. Please take a look on the linked logs.

I use tvheadend 3.4patch1 version that configured to full mux reception.

First I tried Ubuntu 13.10 32bit (kernel 3.11.0-15) that has r820t 
support out of the box. At first it seemed to be very unreliable and it 
got frozen a couple of times. I saw that my dvb-t dongles was 
disconnected and reconnected. Also it seemed to have some problems with 
ACPI. (probably unrelated)

So, I installed Ubuntu 12.04.3 LTS 64bit (kernel 3.8.0-35) + media tree 
(1ec17dea59ca13b99176a8ab17bc055138714263 on yesterday) "basic" approach 
following the tutorial from
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
but it seems this has similar problems like Ubuntu 13.10.

It turned out that a system gets unsatble only when my dvb tuners are 
connected.
I have some parital logs that I collected
https://gist.github.com/azbesthu/8755858

Some details about the logs:

It seems it not makes a big difference if I connect only 1 tuner or 3 of 
them, but maybe it has more often trouble when more tunners are 
connected to the machine. Also it makes no difference when I connect the 
tuneres directly to the notebook or its docking statinon's usb hub.

Sometimes it gets completly frozen. SSH connection hangs, opening the 
lid not turns on the monitor, no connection with the outside world. In 
that case just holding the power button for a few seconsd can turn it off.

Once I had a crash while I set up muxes in tvheadend. When I mapped 
available channels the system had a crash that turnd the system 
partition to read-only. I was not able to save any logs, because the 
readonly filesystem... I was connected with ssh and I had some dmesg 
output that showed a kernel failure, but i messed it up while I tied to 
save it, unfortunately.  The system was so messed up that I was not able 
to turn off the machine by software. After turning it off and on again 
with the power button, It  seemd the usb subsystem had still problems, 
because the connected usb hub in the dock was disconnected continuously. 
Removing the power cord and the battery got it back to normal working.

After I turned on the machine and left it alone for a while, just 
checking dmesg for time to time to see what happens. After  5 to 30 
minutes I saw that one tuner disconnected and reconnected again after an 
error message. It was the same using hub and connecting it directly to 
the notebook.
It had an rc related problem with a tuner and an other tuner got 
reconnected.

Later I connected only one tuner. I watched a streamed for a few 
minutes. Everything seemd to be fine. But leaving the system alone for a 
while it got completly frozen again.

So I removed the tuneres and now the notebook runes withont any glitch, 
it's rock solid.

Is it possible that some kinde of bug triggerd on my system?
I can provide more logs if you tell me some info about how to do it, 
what use case can help you to debug the possible problems. In worst case 
I'm completly locked out from the system and hdd gets readonly befor 
able to write out logs.

Also I have in my inventory an rtl2832u+e4000 tuner and some it9135 and 
an af9015+tda18218, if some test needed with other tuners. I used it9135 
and af9015 tuners in similar configuration and those worked well.
I try to use three rtl2832u+r820t: 
http://logout.hu/bejegyzes/azbest/usb_dvb-t_tuner_rtl2832u_r820t.html

Some details about the system, with a tuner attached:
lsusb -v
https://gist.github.com/azbesthu/66a45e30b23dac1d15c8

dmesg
https://gist.github.com/azbesthu/e5724a430f9b3516bcda

Best regards,
Zoltan

