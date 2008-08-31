Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZv8d-0002Bw-0q
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 00:11:16 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6H00N6RK9L0MG0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 31 Aug 2008 18:10:33 -0400 (EDT)
Date: Sun, 31 Aug 2008 18:10:32 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <002d01c90b5b$dec12860$9c437920$@com.au>
To: Thomas Goerke <tom@goeng.com.au>
Message-id: <48BB16D8.3000601@linuxtv.org>
MIME-version: 1.0
References: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
	<002d01c90b5b$dec12860$9c437920$@com.au>
Cc: linux-dvb@linuxtv.org, 'jackden' <jackden@gmail.com>, stev391@email.com
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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

Thomas Goerke wrote:
>> Tom,
>> (Jackden please try first patch and provide feedback, if that doesn't
>> work for your card, then try this and provide feedback)
>>
>> The second dmesg (with debugging) didn't show me what I was looking
>> for, but from past experience I will try something else.  I was looking
>> for some dma errors from the cx23885 driver, these usually occured
>> while streaming is being attempted.
>>
>> Attached to this email is another patch.  The difference between the
>> first one and the second one is that I load an extra module (cx25840),
>> which normally is not required for DVB as it is part of the analog side
>> of this card.  This does NOT mean analog will be supported.
>>
>> As of today the main v4l-dvb can be used with this patch and this means
>> that the cx23885-leadtek tree will soon disappear. So step 2 above has
>> been modified to: "Check out the latest v4l-dvb source".
>>
>> Other then that step 4 has a different file name for the patch.
>>
>> Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you
>> have completed the missing steps already).
>>
>> If the patch works, please do not stop communicating, as I have to
>> perform one more patch to prove that cx25840 is required and my
>> assumptions are correct. Once this is completed I will send it to
>> Steven Toth for inclusion in his test tree. This will need to be tested
>> by you again, and if all is working well after a week or more it will
>> be included into the main tree.
>>
>> Regards,
>> Stephen
>>
>>
>> --
> 
> Stephen,
> 
> After following Steven Toth's advice re CPIA, applying your patch and then
> make, make install, I can now report that the Compro E800F card is working!
> This is very impressive and thanks for your help.
> 
> I have added the card to MythTV and all channels were successfully added.  I
> am not sure about the comparable signal strength's compared to the Hauppauge
> Nova card I also have installed - this is something I can provide feedback
> on at a later stage.
> 
> I have tried from a soft and hard reset and all seems ok.
> 
> See below for the o/p from dmesg.  Please let  me know if there is anything
> else you would like to try/test.

Stephen,

It looks like your patches work. If you want this merged then mail me 
the patch, I'll put this up on a ~stoth/cx23885-something tree and we 
can have Thomas test one more time before a merge request is generated.

Good work.

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
