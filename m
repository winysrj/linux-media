Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dora.fastpath.it ([66.150.225.37])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marauder@tiscali.it>) id 1JSeqg-0007DT-G4
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 21:50:26 +0100
Date: Fri, 22 Feb 2008 21:49:43 +0100
From: David Santinoli <marauder@tiscali.it>
To: Ysangkok <ysangkok@gmail.com>
Message-ID: <20080222204943.GA16321@aidi.santinoli.com>
References: <15a344380802220720j4ce3a2f0y8401c4e9b90bb553@mail.gmail.com>
	<15a344380802220739i15ba0739na6372c8b61695fca@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <15a344380802220739i15ba0739na6372c8b61695fca@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV Nova-T Stick problems
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

On Fri, Feb 22, 2008 at 04:39:05PM +0100, Ysangkok wrote:
> However I cannot get it to work. I have fetched the firmware
> dvb-usb-dib0700-1.10.fw (34306 bytes). When I use (dvb)scan I get
> "tuning failed".

Hi Ysangkok,
  I have a Nova-T Stick very similar to yours (mine has USB
vendor:product ID 2040:7060 while yours is 2040:7070).  Assuming the
hardware is substantially the same, you might want to 'modprobe mt2060'
and check for this line in the dmesg output:

MT2060: successfully identified (IF1 = 1220)

Cheers,
 David

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
