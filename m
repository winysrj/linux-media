Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <489F9DDA.5050109@siriushk.com>
Date: Mon, 11 Aug 2008 10:03:06 +0800
From: Timothy Lee <timothy.lee@siriushk.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <489C16EF.5030004@siriushk.com> <489C4056.9080804@linuxtv.org>
	<489D4D5D.2020700@siriushk.com> <489F2C4A.4070908@linuxtv.org>
In-Reply-To: <489F2C4A.4070908@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Support for Magic-Pro DMB-TH usb stick
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

Michael Krufky wrote:
> Timothy Lee wrote:
>    
>> Michael Krufky wrote:
>>      
>>> Timothy Lee wrote:
>>>
>>>        
>>>> Attached is a patch against v4l-dvb repository to add support for
>>>> Magic-Pro DMB-TH usb stick.  DMB-TH is the HDTV broadcast standard used
>>>> in Hong Kong and China.
>>>>
>>>> Regards,
>>>> Timothy Lee
>>>>
>>>>          
>>> Timothy,
>>>
>>> In order for your patch to be applied to the kernel, a sign-off is
>>> required.
>>>
>>> Please respond to this email with your sign-off, as described here:
>>>
>>> http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches
>>>
>>> e) All patches shall have a Developers Certificate of Origin
>>>
>>>
>>> Also, what software can people use with your device&  driver to tune
>>> to DMB-TH services?
>>>
>>> How do users scan for services?
>>>
>>>        
>> Dear Michael,
>>
>> Thanks for your hint on getting the patch accepted.  I've now cleaned
>> up the patch to pass checkpatch.pl, and signed it off.
>>
>> I've also attached a second patch against the dvb-apps repository
>> which adds a DMB-TH scan file for Hong Kong.  Since the ProHDTV stick
>> contains a DMB-TH decoder (lgs8gl5) onboard, it outputs MPEG-TS to the
>> PC.
>>
>> I've been using mplayer to test the driver.  But since I'm using
>> dvb-usb's generic video streaming mechanism, I imagine the driver
>> should be compatible with other DVB software.
>>      
> Timothy,
>
> I've applied your patch to my cxusb tree, with slight modifications, in
> order to coincide with another patch to the same code.  Please test the
> tree and confirm proper operation before I request a merge into the
> master branch.
>
> http://linuxtv.org/hg/~mkrufky/cxusb
>
> I'll push the Hong Kong scan file to dvb-apps after this tree is merged
> into the master branch.
>
> If you have any additional fixes / changes to make before this is merged
> into master, please generate them against this cxusb tree.
>    
I've tested your cxusb tree, and the newly added code is working fine.  
Thanks!

Regards,
Timothy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
