Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33106.mail.mud.yahoo.com ([209.191.69.136])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JThhL-0004T7-Lb
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 19:05:08 +0100
Date: Mon, 25 Feb 2008 10:04:30 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Message-ID: <347808.47907.qm@web33106.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD
	SP400 rebadge)
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

Hi Manu,

Thanks for the reply
Yes, indeed I tried over the weekend and by selecting the higher limitation by ISEL register:

if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0, 0x40)) {

My rotor now moves. Do you think it is better to use static current protection?

But unfortunately that is not the end of the story. The problem that I am
having now is that patched mythtv rewrites the limits in my rotor?! And the weird thing is 
it does in such a way that I had to take the motor apart to recalibrate it. It looks like there are
hard limits in the rotor (Aston 1.2) firmware which are not the software limits because trying to reset 
them either from Linux side or from Windoz did not help. So I actually had to take it apart to recalibrate
the motor inside the rotor. I do not think there is a problem with the rotor itself because I have been using it for over 2 years with my other Twinhah 102g card without any problems.
I also wrote a small command line program (using libsec) that will do only rotor commands. With that
program I can do goto n, store, reset, soft limits. All there operations work fine. Goto nn steps also
works somewhat even though it is not taking the specified number of steps precisely. I am not sure why.

Getting back to my mythtv setup - I have a committed switch behind the rotor. So the rotor command is followed by (with 15ms delay) the switch, tone burst and then tunning commands. I turned on the verbose in mantis module and looked what i2c reports. The diseqc sequence looks correct. The only thing I see is that the fifo gets filled up by the end of the sequence so we have to wait for a few cycles before sending the next byte. So now I am thinking could there be any problems if the pause between writing the diseqc bytes is a bit longer since we write byte, check if fifo is full and then write the next byte. What do you think about that? I was thinking of trying to write the whole diseqc command and then check fifo or even better first check fifo and then write the command since we have 15ms between commands anyway.
On the side - switch works 50% of the times so I should look into that too. It is a really good Spaun switch and even with 102g works flawlessly.


Thanks for the help!
Simeon



----- Original Message ----
From: Manu Abraham <abraham.manu@gmail.com>
To: Simeon Simeonov <simeonov_2000@yahoo.com>
Cc: linux-dvb@linuxtv.org
Sent: Sunday, February 24, 2008 12:26:34 PM
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD SP400 rebadge)

Manu Abraham wrote:
> Simeon Simeonov wrote:
>> Hi Gernot,
>>
>> I can confirm that I have similar experience to yours.
>> By the way do you know if one can control from the soft side (register or some other means)
>> the max current output for the card. I am having a problem when trying to tune with a rotor.
>> On the Linux side the current seems to be capped at 300 mA as on the XP I see it goes to
>> about 440 mA. I was still surprised that this card can supply less current than the 102g but
>> we take what we get ...

Can you please try this change, whether it helps in your case ?

In mantis_dvb.c

line #251

if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0, 0)) {

change it to

if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0x80, 0x40)) {

and see whether it helps in improving your current limited situation.
according to the specification it should yield 500 - 650mA

A word of caution, make sure that the auxilliary power connector is
connected. Current drawn will be a bit much higher in this case,
additionally Static Current Limiting is used, hence additional dissipation,
which means more current drawn which might overload the PCI bus, hence
  it would be nice to use the auxilliary power connector.

Regards,
Manu





      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
