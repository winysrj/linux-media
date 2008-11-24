Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1L4jLk-0007oF-5n
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 22:52:08 +0100
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	C47161800461
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 21:51:46 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: linux-dvb@linuxtv.org, "Igor M. Liplianin" <liplianin@tut.by>
Date: Tue, 25 Nov 2008 07:51:35 +1000
Message-Id: <20081124215142.DB2AD1BF2A3@ws1-10.us4.outblaze.com>
Subject: Re: [linux-dvb] [PATCH] Add Compro VideoMate E650F (DVB-T part only)
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


> 
> Message: 2
> Date: Sun, 23 Nov 2008 13:47:41 +0200
> From: "Igor M. Liplianin" <liplianin@tut.by>
> Subject: [linux-dvb] [PATCH] Add Compro VideoMate E650F (DVB-T part
> 	only)
> To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
> Message-ID: <200811231347.41452.liplianin@tut.by>
> Content-Type: text/plain;  charset="koi8-r"
> 
> From: Igor M. Liplianin <liplianin@me.by>
> 
> Add Compro VideoMate E650F (DVB-T part only).
> The card based on cx23885 PCI-Express chip, xc3028 tuner and ce6353 demodulator.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> 
----Snip---

Igor,

Is this based on my earlier patches sent to the mailing list?
http://linuxtv.org/pipermail/linux-dvb/2008-August/028341.html

If so have you had this working correctly?

What happens if you do now request the module cx25840?

My patches were previously not committed due to:
* I only had two people who had this card (same pci ids) and both gave me conflicitng results. (regarding the need for cx25840, if you search the mailing list archives from about August through September this year you will find the conversations).
* The pci ids are shared across various cards from Compro VideoMate Series and therefore the cards are detected incorrectly, the eeprom dumps for each card that people have contacted the list about previously are on the wiki pages.

Keep up the effort in supporting DVB cards in linux.

Regards,
Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
