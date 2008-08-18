Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from omzesmtp01a.verizonbusiness.com ([199.249.25.195])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark.paulus@verizonbusiness.com>) id 1KV57a-0002kv-Gl
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 15:50:13 +0200
Received: from pmismtp03.mcilink.com ([166.37.158.163])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0K5S0062MUEM6L00@firewall.verizonbusiness.com> for
	linux-dvb@linuxtv.org; Mon, 18 Aug 2008 13:49:34 +0000 (GMT)
Received: from pmismtp03.mcilink.com ([127.0.0.1])
	by pmismtp03.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0K5S007FQUELYI@pmismtp03.mcilink.com> for
	linux-dvb@linuxtv.org; Mon, 18 Aug 2008 13:49:34 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.132.9])
	by pmismtp03.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0K5S00920UEKLQ@pmismtp03.mcilink.com> for
	linux-dvb@linuxtv.org; Mon, 18 Aug 2008 13:49:33 +0000 (GMT)
Date: Mon, 18 Aug 2008 07:49:40 -0600
From: Mark Paulus <mark.paulus@verizonbusiness.com>
In-reply-to: <37219a840808111258u23651495o6a7fba478214ef2c@mail.gmail.com>
To: linux-dvb@linuxtv.org
Message-id: <48A97DF4.4040804@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------040903040502080001030302
References: <48A05F58.8090405@verizonbusiness.com>
	<37219a840808111057w5945ecc6wd200c624168a196a@mail.gmail.com>
	<48A09672.2060707@verizonbusiness.com>
	<37219a840808111258u23651495o6a7fba478214ef2c@mail.gmail.com>
Subject: Re: [linux-dvb] [Fwd: Help with recent DVB/QAM problem please.] -
 RESOLVED!
Reply-To: mark.paulus@verizonbusiness.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040903040502080001030302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Michael Krufky wrote:
> On Mon, Aug 11, 2008 at 3:43 PM, Mark Paulus
> <mark.paulus@verizonbusiness.com> wrote:
>>
>> Michael Krufky wrote:
>>> 2008/8/11 Mark Paulus <mark.paulus@verizonbusiness.com>:
>>>> Redirecting to linux-dvb on suggestion from
>>>> Video4Linux user.
>>>>
>>>> -------- Original Message --------
>>>> Subject: Help with recent DVB/QAM problem please.
>>>>
>>>> Hi all,
>>>>
>>>> Background:
>>>> I have a machine in my basement with:
>>>> Hauppauge PVR-150 (connected to DCT2524)
>>>> Air2PC ATSC/OTA card (connected to antenna in attic)
>>>> Avermedia A180 (connected to comcast cable)
>>>> Dvico FusionHDTV RT 5 Lite (connectec comcast cable)
>>>> Debian using 2.6.24-x64 kernel
>>>>
>>>> Situation:
>>>> Up until a week ago, I was able to use azap to tune in
>>>> a bunch of mplexids, and get good locks on both the A180 and the Dvico
>>>> card.
>>>>  However, starting on Monday,
>>>> I am not able to get locks on either of my DVB cards.
>>>> I have been able, and am still able to get good locks
>>>> on my air2pc OTA card.
>>>>
>>>> Can anyone help me figure out why I can't seem to see
>>>> anything from my 2 QAM cards?  I've tried running a
>>>> dvbscan and neither card can make a good lock.  What
>>>> other debugging tools can I use to try to find any QAM
>>>> signals?  I've also tried doing a VSB-8 scan on the cable
>>>> cards, and also don't get any locks.
>>> Mark,
>>>
>>> It's good that you've moved the thread to the correct mailing list.
>>> However, I did already answer you and asked you some questions, to
>>> which you have not yet responded....
>>>
>>> Quoting myself:
>>>
>>> What variables have changed in your test environment since last Monday?
>>>
>>> If the answer is "nothing" , then the problem is more than likely due
>>> to your cable company moving services around.
>>>
>>> First, you should confirm that you still have clear QAM available...
>>> assuming yes, then I recommend scanning for channels again, using each
>>> card.
>>>
>>> Regards,
>>>
>>> Mike
>>>
>> As far as I know, no variables have changed.  The only thing that might
>> have been of note is that there seemed to have been a wierd Power Blip, and
>> my linux machine was off when I was not expecting it.
>> After turning it on, I noticed the problem.  However, it seems wierd
>> to me that a power blip would blow both QAM cards, and yet leave the ATSC
>> and the PVR-150 alone.  (I also have a PVR-150 attached to a Motorola
>> DCT-2524 in that machine).
>>
>> My biggest problem I have right now is determining if there is even
>> any clear QAM available.  I did a dtvscan -q from both cards, and neither
>> card is able to lock anything.  Before last week, I was
>> able to get locks on many multiplexes, even those populated completely with
>> encrypted PIDs.  (I would do an azap in one window
>> to lock a multiplex, then I could do a dvbstream in another window, and run
>> tsreader on my winxp box to actually look at a stream.  Encrypted streams
>> would show up as read w/nothing to look at.
>> Clear streams could be clicked, and would play in VLC, so I could
>> see what it is.)
>>
>> I will run another dtvscan to make sure things aren't there, but is
>> there any other means of determining the state of things QAM?  Somehow my
>> Motorola DCT-2524 seems to still see channels and
>> work fine, so if Comcast did change something, then they did
>> it so that it doesn't affect their STBs.
> 
> This is my point, exactly.  Since your provider has provided your STB,
> they also have an interface into the STB that allows them to update
> software and / or encryption keys, etc.
> 
> It is more than likely that your provider has changed the
> characteristics of the services on their cable.
> 
> You may want to contact your provider directly and ask them what has
> changed with your service within the past two weeks.
> 
> I've heard similar complaints from other users of your service provider.
> 
> Good Luck,
> 
> Mike
> 

Well, I just wanted to post the fact that I have a resolution, so that
others might see this.  I know I've seen this solution before, at least
in the ivtv side, but wanted to reiterate once again.

Apparently the issue was caused by a failing power supply.  I came home
on Friday to the machine being off, and not wanting to power on at all.
Put a Power Supply tester on the Power Supply, and it still didn't want
to fire up.  So, I changed out the Antec 400W PSU with a spare Cooler
Master 500W PSU I have, and walla, everything is working again.  

Apparently the tuners on these DVB cards really require lots of juice,
and a failing PSU just couldn't supply it.  So, the lack of tuning was
the warning sign that the PSU was about to fail.



--------------040903040502080001030302
Content-Type: text/x-vcard; charset=utf-8;
 name="mark_paulus.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mark_paulus.vcf"

YmVnaW46dmNhcmQNCmZuOk1hcmsgUGF1bHVzDQpuOlBhdWx1cztNYXJrDQpvcmc6TUNJO0xl
YyBJbnRlcmZhY2VzIC8gNDA0MTkNCmFkcjtkb206OzsyNDI0IEdhcmRlbiBvZiB0aGUgR29k
cyBSZDtDb2xvcmFkbyBTcHJpbmdzO0NPOzgwOTE5DQplbWFpbDtpbnRlcm5ldDptYXJrLnBh
dWx1c0B2ZXJpem9uYnVzaW5lc3MuY29tDQp0aXRsZTpNYXJrIFBhdWx1cw0KdGVsO3dvcms6
NzE5LTUzNS01NTc4DQp0ZWw7cGFnZXI6ODAwLXBhZ2VtY2kgLyAxNDA2MDUyDQp0ZWw7aG9t
ZTp2NjIyLTU1NzgNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------040903040502080001030302
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040903040502080001030302--
