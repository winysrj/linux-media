Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Jezri-0001OB-E8
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 22:42:33 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JYE007O1S9V5ZT0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 27 Mar 2008 17:41:56 -0400 (EDT)
Date: Thu, 27 Mar 2008 17:41:55 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <c8b4dbe10803271428y13bd710co995e25bb9a2eb614@mail.gmail.com>
To: Aidan Thornton <makosoft@googlemail.com>
Message-id: <47EC14A3.7010505@linuxtv.org>
MIME-version: 1.0
References: <47EBF4B7.2060705@linuxtv.org>
	<c8b4dbe10803271241i20990cf3j1b75c85f1f649916@mail.gmail.com>
	<47EBFC19.4060106@linuxtv.org>
	<c8b4dbe10803271428y13bd710co995e25bb9a2eb614@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge WinTV-CI Spec
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

Aidan Thornton wrote:
> On Thu, Mar 27, 2008 at 7:57 PM, Steven Toth <stoth@linuxtv.org> wrote:
>> Aidan Thornton wrote:
>>  > On Thu, Mar 27, 2008 at 7:25 PM, Steven Toth <stoth@linuxtv.org> wrote:
>>  >> Recap: I said I'd notify the list when the spec was released for the
>>  >>  Hauppauge CI device.
>>  >>
>>  >>  Hello!
>>  >>
>>  >>  http://www.smardtv.com/index.php?page=dvbci&rubrique=specification
>>  >>
>>  >>  Looks like SmartDTV have finally got something out of the door. Put your
>>  >>  email address in their database and they'll email you the PDF with full
>>  >>  command interface describing the protocol.
>>  >>
>>  >>  Regards,
>>  >>
>>  >>  - Steve
>>  >
>>  > Hi,
>>  >
>>  > I'm not sure how that's relevant. It seems to be the spec for
>>  > something called CI+, intended to prevent unauthorised systems from
>>  > getting access to the decrypted stream coming out the CAM and ensure
>>  > only authorised host devices can use CAMs. I expect open source
>>  > software will be able to make use of this stuff approximately when
>>  > hell freezes over. If this catches on, say hello to more copy
>>  > protection and bye-bye to being able to use CAMs under Linux!
>>
>>  A subset of the spec will work with the CI USB device, for those that
>>  are interested.
> 
> Yeah, that's what I was wondering about - it doesn't seem to specify
> anything about CI USB devices, just the standard PC card based
> interface. (It even states that it doesn't deal with any interfaces
> other than that one). In what sense does the WinTV-CI implement this -
> does it translate between standard CIs and some subset of this
> protocol done over USB? (I'm not even sure, at a glance, if this makes
> sense.)

I only glanced at the spec, but from what I'm told the command API is 
implemented over USB. I suspect that Luc (the guy working on the Linux 
driver) might be able to consolidate this command set, with the USB logs 
he's been capturing. If not then something is clearly wrong.

I'd been promised this document during December 2007 by the vendor and 
said that I'd post it here to the community as soon as it was released.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
