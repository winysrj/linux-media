Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtphost.cis.strath.ac.uk ([130.159.196.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gnapier@cis.strath.ac.uk>) id 1Jvv0C-0001UO-Pi
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 15:57:45 +0200
Received: from [130.159.178.173] (euan.eee.strath.ac.uk [130.159.178.173])
	(authenticated bits=0)
	by smtphost.cis.strath.ac.uk (8.13.4/8.13.4/Debian-3sarge3) with ESMTP
	id m4DDsFLS028309
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 14:54:16 +0100
Message-ID: <48299D88.3060608@cis.strath.ac.uk>
Date: Tue, 13 May 2008 14:54:16 +0100
From: Gary Napier <gnapier@cis.strath.ac.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-3000
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

Hi all,

I have been attempting to build a linux-tv system using the Haugpage 
HVR-3000. Now i have been aware of the problems with this card,
with regards to the dual frontend. Using the wiki entries as a base, i 
installed Mythbuntu, and removed it's default cx_88 module, before building
my own using the wiki steps. I am using a Via C7 1.5GHz  system on a 
Jetway motherboard, mini ITX, one PCI slot.

So, in the end i can use dvb-tools to get a TV picture (found the BBC 
channels available in the uk via DVB-T)
Scan finds very little channels, but i do have some BBC channels to 
test. This would indicate a reception issue i believe.
TZAP spits out the constant hex codes i expect.

The problem.
The tv is very slow to update and impossible to watch. I would like to 
know if this is a driver/software issue or
a hardware issue. During TV playback the processor maxs out at 100%

1. Am i right in assuming that the output from the HVR-3000 (DVB-T) is 
an MPEG stream, and as such needs very little CPU resources?
2. Am i right in assuming that with the Hardware MPEG decoding ability 
of the Via C7, very little CPU resources are needed for playback?
3. What tools are available for me to get a measure of signal strength 
and quality of broadcast, which i believe may be the issue (although 
dedicated Set Top boxes seem to work fine)?
4. Please share any other comments that may be useful to the setup.

Cheers
Gary


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
