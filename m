Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0UD6O8a017423
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 08:06:24 -0500
Received: from dd6904.kasserver.com (dd6904.kasserver.com [85.13.131.139])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0UD67le006272
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 08:06:08 -0500
Received: from [10.0.1.47]
	(HSI-KBW-078-042-032-195.hsi3.kabel-badenwuerttemberg.de
	[78.42.32.195])
	by dd6904.kasserver.com (Postfix) with ESMTP id 33A9C3009A5D8
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 14:06:10 +0100 (CET)
Message-ID: <4982FB36.7080008@softronic-mannheim.de>
Date: Fri, 30 Jan 2009 14:05:58 +0100
From: =?ISO-8859-15?Q?Marius_R=E4sener?= <mr@softronic-mannheim.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Terratec Cinergy C PCI - Mantis Driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi V4L-List,

i hope i can find a solution with your help here.
The situation:
Hp ProLiant DL380 G2 Server should become a LinuxMCE Core (got that cheap).
LinuxMCE is based on Kubuntu 7.10 (i386 in my case)
I think the components of the System arent relevant, but correct my 
please if not.
Maybe that there are only PCI-X slots available, but all Cards I use are 
3.3V compatible (with the 2 notch).

DVB-C Card is "Terratec Cingery C PCI HD".

I installed the card via this method:

cd /usr/src
sudo apt-get install mercurial
sudo hg clone http://jusst.de/hg/mantis 
cd mantis
sudo make
sudo make install
sudo reboot


this worked for me several times.
(
i got the expected dmesg output:
[  101.667604] found a VP-2040 PCI DVB-C device on (0a:01.0),
[  101.670427] DVB: registering new adapter (Mantis dvb adapter)
[  102.189326] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[  102.192819] mantis_frontend_init (0): found Philips CU1216 DVB-C 
frontend (TDA10023) @ 0x0c
[  102.192823] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 
frontend attach success
[  102.192829] DVB: registering adapter 0 frontend 0 (Philips TDA10023 
DVB-C)...
)
but after the last complete new-installation its not anymore.
(
now die dmesg output:
~: dmesg | grep -i dvb
~:
)
i'm not sure what to try next. the card itself installs in Vista x64 
without any errors so its no hardware defect i guess.
i also tried to install a older version of the mantis driver, but i'm 
not sure if i downloaded them correctly.
i'm also not sure if i can reinstall older or newer versions of the 
driver without messing something up. does that work?
i also tried several different pci-x slots caused that procedure 
sometimes helped me in windows environment...

any hints please for me before i jump from a bridge or something :)

greetings from sunny mannheim, germany
marius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
