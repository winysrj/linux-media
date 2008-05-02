Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <481A6495.60508@linuxtv.org>
Date: Thu, 01 May 2008 20:47:17 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: RISCH Gilles <roodemol@cjbous.net>
References: <200804272327.20455.roodemol@cjbous.net>	<4815F1DE.7090906@linuxtv.org>
	<200805020038.34997.roodemol@cjbous.net>
In-Reply-To: <200805020038.34997.roodemol@cjbous.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-HVR-1200
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

>> RISCH Gilles wrote:
>>> Hello,
>>>
> On Monday 28 April 2008 17:48:46 Steven Toth wrote:
>>> the Hauppauge WinTV-HVR-1200 is now listened as a supported card in the
>>> wiki. What I'm missing are some instructions how to get the card working.
>>> Does a such document already exist?
>> No, but feel free to update the wiki so other benefit from your work.
>>
>> 1. Build and install the modules, as per the wiki instructions.
>> 2. Reboot and your done, as per the wiki instructions.
>> 3. Scan for channels or use an existing channels.conf, as per the wiki
>> instructions.
>> 4. Update the HVR1200 wiki page.
>>
>> Regards,
>>
>> Steve

RISCH Gilles wrote:
> Hello,
> 
> my card is running, I've added some lines to the wiki:
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1200
> 
> can someone review / try it out
> 
> Regards
> 


Please do not top-quote.  Replies should appear below the quoted text.

Your wiki entry says, 

"
  5. add this line to /etc/modules.d/dvb:
  options cx23885 card=7
"

Why?  Does the cx23885 driver not autodetect your board?

The HVR1200 has a subsystem ID that should allow the driver to autodetect your board.  If your board is not autodetected, it means one of two things:

1) The subsystem id of your card is missing, and we can simply add that for you to avoid the need for module option.

2) For one reason or another, the device may be reading the eeprom incorrectly, causing the subid not to show properly.  This is unlikely, but I have seen it happen in certain motherboards using cx23885 based products.

Please test without the module option -- your board should be properly autodetected.  If this is not the case, please send in your full dmesg output.

Regards,

Mike Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
