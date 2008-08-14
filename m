Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <czhang1974@gmail.com>) id 1KTe5J-0001O2-7M
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 16:45:56 +0200
Received: by wr-out-0506.google.com with SMTP id 50so588543wra.13
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 07:45:48 -0700 (PDT)
Message-ID: <bd41c5f0808140745q7ac4cc31tbddfb7525d29a799@mail.gmail.com>
Date: Thu, 14 Aug 2008 14:45:48 +0000
From: "Chaogui Zhang" <czhang1974@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48A43DF3.6000705@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <8fcafd2c0808131723l21031daej9e9ae3eeabfa57f7@mail.gmail.com>
	<48A37D44.7090808@linuxtv.org>
	<8fcafd2c0808131806l1fcc7563v121715d937d39a5d@mail.gmail.com>
	<8fcafd2c0808131840u4fe27c7dq84953bd34d24e0b1@mail.gmail.com>
	<8fcafd2c0808132039h4d0ada9xef21a8502e495b9d@mail.gmail.com>
	<48A43DF3.6000705@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Digital tuning failing on Pinnacle 800i with dmesg
	output
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

On Thu, Aug 14, 2008 at 2:15 PM, Steven Toth <stoth@linuxtv.org> wrote:
> James Lucas wrote:
>> On Wed, Aug 13, 2008 at 8:40 PM, James Lucas <orbus42@gmail.com
>> <mailto:orbus42@gmail.com>> wrote:
>>
>>     Anyway, update.  Installed in the windows machine, and got the
>>     drivers installed successfully, but the player software that comes
>>     with the card requires windows xp, and the newest version of windows
>>     I have is 2000.  I know analog capture is pretty well supported in
>>     windows by things like virtualdub and media player classic, but do
>>     you know of any apps I can use to test the HD functionality?
>>
>>     While I had the card out, got the following from visual inspection:
>>
>>     Printed on the PCB:
>>     pctv 800i rev 1.1
>>
>>     There were two large visible chips on the card:
>>     Samsung C649 S5H1409X01-T0  N079X
>>
>>     Conexant Broadcast Decoder  CX23883-39  72013496  0729 Korea
>>
>>     I imagine the tuner chip is hidden under the metal box (shielding?).
>>
>>     James
>>
>>
>>
>> Another update - I spoke too soon.  One of the windows drivers is
>> refusing to load properly.  I don't know if the signifies a bad card or
>> just that the driver doesn't work on anything less than xp.  I don't
>> have any way to test at the moment.  I'm happy to try anything you want
>> in the way of diagnosis under linux though.
>
> I don't think anyone else is reporting i2c issues on that board, so it's
> possible you just have a bad unit.

I saw similar i2c error messages back when we were trying to add
support for the card (I never posted on the list about it because that
happened when I was fiddling with the code). I do not remember the
specifics, but it went away later on as the code matured. It might
have something to do with multiple instances of the driver being
attached to the xc5000, but we certainly cannot rule out the
possibility of a bad unit.

>
> It goes without saying, try to bring up the baord on a supported windows
> platform to verify it... or perhaps take it to a neighbours house a
> wreck his xp install ;)
>
> If you get to the point of it working in windows but not on Linux then
> we'll be able to make progress.
>
> - Steve
>

-- 
Chaogui Zhang

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
