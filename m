Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gw.deuromedia.ro ([194.176.161.33] helo=deuromedia.de)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Doru.Marin@Deuromedia.ro>) id 1JR5gg-00086i-7i
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 14:05:38 +0100
Message-ID: <47B98257.8060200@Deuromedia.ro>
Date: Mon, 18 Feb 2008 15:04:23 +0200
From: Doru Marin <Doru.Marin@Deuromedia.ro>
MIME-Version: 1.0
To: "P. van Gaans" <w3ird_n3rd@gmx.net>
References: <47B19015.20208@gmx.net>
	<47B2F82F.6070804@Deuromedia.ro>	<47B3512C.5010107@gmx.net>
	<47B62C4B.3020604@gmx.net> <47B97E8B.8090905@gmx.net>
In-Reply-To: <47B97E8B.8090905@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DiSEqC trouble with TT S-1500
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

P. van Gaans wrote:
> On 02/16/2008 01:20 AM, P. van Gaans wrote:
>   
>> On 02/13/2008 09:21 PM, P. van Gaans wrote:
>>     
>>> On 02/13/2008 03:01 PM, Doru Marin wrote:
>>>       
>>>> Hi,
>>>>
>>>> Can you explain how you select those 4 positions ? DiSEqC commands or 
>>>> tone/voltage changes ?
>>>> Also can you determine the input type of those positions (Hi/Low, 
>>>> H/V, etc) ? A scenario to see when and why that happens, would be 
>>>> more useful.
>>>>
>>>> P. van Gaans wrote:
>>>>         
>>>>> Hi,
>>>>>
>>>>> I've got a Technotrend S-1500 (if it matters: I use it with Kaffeine 
>>>>> 0.8.3). It works mostly fine, but there's a strange problem. With my 
>>>>> Spaun 4/1 DiSEqC switch (they cost approx 25-40 euro), I can only 
>>>>> switch without trouble to position 1 and 2. If I tune directly to 
>>>>> position 3 it won't lock.
>>>>>
>>>>> However, if I first tune to a channel on position 1 or 2 and try a 
>>>>> channel on position 3 after that, it will work. Position 4 however 
>>>>> is completely unreachable.
>>>>>
>>>>> On a standalone receiver, there's no trouble with the same cable.
>>>>>
>>>>> Now Spaun is a really expensive and respected brand. So their 
>>>>> switches possibly work in a different way, because a cheap Maximum 
>>>>> 4/1 switch works perfectly with the S-1500. Position 1, 2, 3 and 4 
>>>>> all work perfectly. I also did some "dry testing" indoors and it 
>>>>> looks like a 7 euro Satconn 4/1 switch would also work fine, but a 
>>>>> 17 euro Axing SPU 41-02 probably won't.
>>>>>
>>>>> I'm guessing this could be solved in stv0299.c but I'm not much of 
>>>>> an expert. I took a look at the code but I'm not really sure what to 
>>>>> do.
>>>>>
>>>>> _______________________________________________
>>>>> linux-dvb mailing list
>>>>> linux-dvb@linuxtv.org
>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>   
>>>>>           
>>> I select them with Kaffeine. Hi/low and H/V doesn't matter. I tried 
>>> upgrading to Kaffeine 0.8.5 but that doesn't make a difference. The 
>>> "scan" application has the same issues.
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>       
>> Nobody any ideas? If not, does anybody have some idea what the 
>> difference between position 1+2, pos 3 and pos 4 could be? I was 
>> thinking 1 and 2 might be working because of toneburst, but I don't 
>> think Kaffeine uses such a signal and that doesn't explain why pos 3 
>> works if first tuning to 1 or 2 and 4 doesn't work at all.
>>
>>     
>
> I've figured out a bit more. If I tune directly to postion 3, I get pos
> 1. Whenever I tune to pos 4, I get pos 2.
>
> I'll also ask people from Kaffeine as I'm not sure if the problem is in 
> the application, driver or somewhere else.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Hi,

Strange scenario. You're not saying anything about input types and the 
switch type. Are you sure that are properly connected ? How the switch 
inputs are marked and from where you got the input signals ? Please 
elaborate, if you want a proper answer.
I suggest to play with 'scandvb' from dvb-apps package instead of 
Kaffeine. Look into scanning results if the scanned channels match with 
what you wished to have on those positions.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
