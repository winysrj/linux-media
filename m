Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail2.tandbergtv.com ([66.0.13.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rmarshall@tandbergtv.com>) id 1JNEDO-0003iB-Om
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 22:23:27 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C869CF.9997745D"
Date: Thu, 7 Feb 2008 16:22:53 -0500
Message-ID: <0A2AE08865A4194B9041E10200B82034ADDE1E@ATL-EXCH1.US.TANDBERGTV.COM>
From: "Marshall, Russ" <rmarshall@tandbergtv.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] out of order packets on the HVR4000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C869CF.9997745D
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I'm having a problem with out of order packets using MPE on the HVR4000.
The timestamp in the packet headers shows they are received in the right
order, however every now and then they will come off the stack out of
order.  Check out the attached packet capture, packet 32 is the first
out of order packet.  The text in the payload will also verify the
packets are coming in out of order.  I have sent this same data over
ethernet and over an external DVB receiver (also using the cx24116) with
no problems with out of order packets, so I believe the issue is
specific to the driver.

I'm running kernel 2.6.23.13 with v4l-dvb changeset 7162 patched with
Darron's v4l-dvb-hg-2008-02-07-sfe.diff patch.

Any ideas?

--
Russ

------_=_NextPart_001_01C869CF.9997745D
Content-Type: application/octet-stream;
	name="outoforder.cap.bz2"
Content-Transfer-Encoding: base64
Content-Description: outoforder.cap.bz2
Content-Disposition: attachment;
	filename="outoforder.cap.bz2"

QlpoOTFBWSZTWZUzj4QA+tb/////////////////////////or4QJuvTU2ja39fkO///4BFeSCXg
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

------_=_NextPart_001_01C869CF.9997745D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------_=_NextPart_001_01C869CF.9997745D--
