Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47FBBF28.7010408@bsc-bvba.be>
Date: Tue, 08 Apr 2008 20:53:28 +0200
From: Luc Brosens <dvb2@bsc-bvba.be>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <47EBF4B7.2060705@linuxtv.org>	<c8b4dbe10803271241i20990cf3j1b75c85f1f649916@mail.gmail.com>	<47EBFC19.4060106@linuxtv.org>	<c8b4dbe10803271428y13bd710co995e25bb9a2eb614@mail.gmail.com>	<47EC14A3.7010505@linuxtv.org>	<e2d627830804080624m9a5c3wf48146b863c5f183@mail.gmail.com>
	<47FB75E5.7090808@linuxtv.org>
In-Reply-To: <47FB75E5.7090808@linuxtv.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge WinTV-CI Spec
Reply-To: dvb2@bsc-bvba.be
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

Hi there,

I'm the Luc attempting a driver.  Current status at http://www.bsc-bvba.be/linux/dvb

help and suggestions more than welcome

regards,

Luc

Steven Toth wrote:
> Derk Dukker wrote:
>> Hi all,
>>
>> I was wondering if there is any progress going on at the Hauppauge WinTV 
>> CI usb. I heard that a guy named Luc is currently working on it. Luc do 
>> you have any information about your progress or do you have a site where 
>> I/we can track back the progress? I also noticed that the design of the 
>> Hauppauge WinTV CI usb is quite the same as the Terratec Cinergy CI usb 
>> which I bought. SmarDTV is the vendor of it (I opened the case and on 
>> the print board stood SmarDTV). You can get the specification from the 
>> website (see also earlier emails).
>> I think both the devices are the same, so when one driver is created it 
>> will probably also works on the terratec cinergy ci. I don't know if the 
>> specification from smarDTV is enough...
>> I have had contact with the dutch terratec support and asked them if 
>> they can get me the specification to create a linux driver. He said that 
>> he would check it out if it is possible for me to have the 
>> specification, as soon as he knows more he will update me. But that 
>> email responds was 1 or 2 weeks ago. I will email him again. As soon as 
>> I got something I will post it here.
> 
> I looked at the published spec and I it looks like it's for a newer 
> device yet to hit the market. Trying to read it word for word will 
> largely miss-represent what the WinTVCI device is, or its feature set. 
> (Although I was at one point convinced this document was a super-set of 
> the WinTVCI device).
> 
> I also looked at the USB traffic on the current Hauppauge driver, with a 
> cam inserted and decryption happening. The protocol appears pretty simple.
> 
> I don't like their URB handling and their constant polling of the device 
> regardless of whether it's being used or not, but that's likely an ugly 
> feature of the windows implementation. I suspect a Linux driver could be 
> written to do whatever it likes (mostly).
> 
> - Steve
> 
> 
> 
>> regards,
>>
>> Derk
>>
>> On Thu, Mar 27, 2008 at 11:41 PM, Steven Toth <stoth@linuxtv.org 
>> <mailto:stoth@linuxtv.org>> wrote:
>>
>>     Aidan Thornton wrote:
>>      > On Thu, Mar 27, 2008 at 7:57 PM, Steven Toth <stoth@linuxtv.org
>>     <mailto:stoth@linuxtv.org>> wrote:
>>      >> Aidan Thornton wrote:
>>      >>  > On Thu, Mar 27, 2008 at 7:25 PM, Steven Toth
>>     <stoth@linuxtv.org <mailto:stoth@linuxtv.org>> wrote:
>>      >>  >> Recap: I said I'd notify the list when the spec was released
>>     for the
>>      >>  >>  Hauppauge CI device.
>>      >>  >>
>>      >>  >>  Hello!
>>      >>  >>
>>      >>  >>
>>      http://www.smardtv.com/index.php?page=dvbci&rubrique=specification
>>     <http://www.smardtv.com/index.php?page=dvbci&rubrique=specification>
>>      >>  >>
>>      >>  >>  Looks like SmartDTV have finally got something out of the
>>     door. Put your
>>      >>  >>  email address in their database and they'll email you the
>>     PDF with full
>>      >>  >>  command interface describing the protocol.
>>      >>  >>
>>      >>  >>  Regards,
>>      >>  >>
>>      >>  >>  - Steve
>>      >>  >
>>      >>  > Hi,
>>      >>  >
>>      >>  > I'm not sure how that's relevant. It seems to be the spec for
>>      >>  > something called CI+, intended to prevent unauthorised
>>     systems from
>>      >>  > getting access to the decrypted stream coming out the CAM and
>>     ensure
>>      >>  > only authorised host devices can use CAMs. I expect open source
>>      >>  > software will be able to make use of this stuff approximately
>>     when
>>      >>  > hell freezes over. If this catches on, say hello to more copy
>>      >>  > protection and bye-bye to being able to use CAMs under Linux!
>>      >>
>>      >>  A subset of the spec will work with the CI USB device, for
>>     those that
>>      >>  are interested.
>>      >
>>      > Yeah, that's what I was wondering about - it doesn't seem to specify
>>      > anything about CI USB devices, just the standard PC card based
>>      > interface. (It even states that it doesn't deal with any interfaces
>>      > other than that one). In what sense does the WinTV-CI implement
>>     this -
>>      > does it translate between standard CIs and some subset of this
>>      > protocol done over USB? (I'm not even sure, at a glance, if this
>>     makes
>>      > sense.)
>>
>>     I only glanced at the spec, but from what I'm told the command API is
>>     implemented over USB. I suspect that Luc (the guy working on the Linux
>>     driver) might be able to consolidate this command set, with the USB logs
>>     he's been capturing. If not then something is clearly wrong.
>>
>>     I'd been promised this document during December 2007 by the vendor and
>>     said that I'd post it here to the community as soon as it was released.
>>
>>     - Steve
>>
>>
>>
>>     _______________________________________________
>>     linux-dvb mailing list
>>     linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
>>     http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>>
>> ------------------------------------------------------------------------
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
