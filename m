Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep27-int.chello.at ([62.179.121.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1KBd85-0006jl-IL
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 00:06:24 +0200
Message-ID: <4862C130.6000300@hispeed.ch>
Date: Thu, 26 Jun 2008 00:05:36 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
References: <4861501B.9050507@kolumbus.fi>	<48615A7E.2030600@tungstengraphics.com>
	<4862A909.6040105@kolumbus.fi>
In-Reply-To: <4862A909.6040105@kolumbus.fi>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Ticlkess Mantis remote control implementation
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

On 25.06.2008 22:22, Marko Ristola wrote:
> Roland Scheidegger wrote:
>> On 24.06.2008 21:50, Marko Ristola wrote:
>>   
>>> Hi,
>>>
>>> I have still my own version of Manu's jusst.de/mantis driver that is 
>>> based on v4l-dvb-linuxtv main branch,
>>> mainly because I use so new Linux kernels.
>>> I have done the following improvement lately:
>>>
>>> I implemented a remote control patch, that doesn't poll the remote 
>>> control all the time.
>>> It polls the remote control only if you press the button (a tickless 
>>> version, you know).
>>> It surprised me, that the actual implementation was really small, it 
>>> took very few lines of code.
>>>
>>>     
>> You're not the first to think that the constant polling is not
>> necessary, too bad these things always get lost because they aren't
>> integrated in the official driver...
>>
>> http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html
>>   
> Okay, I understood from your patch that you just deliver all key repeats 
> as initial key presses.
> You have disabled the polling altogether, but just deliver the key 
> presses as initial key presses
> and deliver the "key unpressed" instantly after the key press.
Yes, I guess though this is probably somewhat of an abuse of the API and
maybe there could be an easier way by just delivering one key press
without having to send an unpress event. I dunno though, I'm not
familiar enough with the ir / input code.

> What is the feeling? I think that it might work for my remote control 
> equally.
> Also I noticed that you mentioned that you remote control's initial key 
> repeat comes after 270ms.
> So polling on my code should be done with 300ms intervals for example.
> Maybe it would make my own remote control also more robust.
> 
> My version is better only in the sense that some application would be 
> able to
> catch the fact that the user is pressing a button and holding it down a 
> long time. Maybe some programs need that for robustness.
That's the theory, but with the delays from the remote it didn't happen
to work in practice here consistently. Maybe if you'd change the default
initial repeat / frequency of the input layer code (which I failed to
do), since increasing the poll frequency just above 300ms is a bad idea
(larger than the input layer code initial repeat - hence it is
impossible to get single key presses).
Also, I'm not sure there's any program out there which actually cares if
you press a key multiple times or hold it down? And ultimately, you
can't reliably detect this from the remote itself anyway (well you could
try based on the timing intervals), since apparently you just get the
same keycode again if you hold it down.

> 
> Your version is better in the sense that you repeat 270ms and 220ms 
> rerepeats correctly, as the remote control sends them.
> 
> Can we implement a version that has both advantages and is still 
> acceptable to the kernel?
> 
> + no work cancellation needs to be done during normal operation.
> + no current time calculation is done.
> 
> With both features working, it could be done in the following way:
> Set a work with a timeout of 300ms.
> Deliver all key presses and repeats instantly.
> On key press delivery, cancel the assumed ealier delayed check and setup 
> a new checking work with 300ms delay.
> If a 300ms checking delay will be ever active, it will just inform "no 
> key pressed" and continue.
It sounds good in theory (and I tried something along these lines), but
finally decided I didn't want to waste any more time - it got too
complicated (mostly because I failed to change the initial repeat /
frequency of the input layer code, looking at it I'm not sure it can be
done after initialization, and if you do it before you will need to
duplicate all the logic for key repeats which is in the input code
yourself). Just didn't seem worth the trouble.

> 
> On my opinion this "final" implementation might be a generic 
> implementation which could be used in more places than on Mantis driver.
> 
> One question is, that are these Mantis remote controls at all like RC5 
> remote controls mentioned in ir-common.c/h.
> If yes, the correct way might be to use it's implementation.
> 
> Personally I haven't seen a "key unpressed" IRQ with my remote.
> That event seems to be needed, if RC5 code is going to be used.
> 
> It might though be, that the interrupt line for "key unpressed" isn't 
> the same as with "key pressed".
> That might be rather easy to investigate and the implementation for "key 
> unpressed" would be then trivial.
I don't think you'd ever get something for key unpressed. Seems quite
logical, the uart just generates an interrupt for any key it receives,
and if you "unpress" well there simply won't be any more keys.

So all in all I figured not using any kind of auto-repeat works just as
well, and the only real improvement possible (e.g. the timing based
recognition of hold-down keys) is something likely noone cares about
anyway but requires 10 times as complicated code.

Roland

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
