Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.7.61.12] (helo=killala.koala.ie)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@koala.ie>) id 1LGdqn-0001iO-L1
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 19:25:26 +0100
Received: from [127.0.0.1] (cozumel.koala.ie [195.7.61.7])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id mBRIQc93021261
	for <linux-dvb@linuxtv.org>; Sat, 27 Dec 2008 18:26:41 GMT
Message-ID: <49567308.2060606@koala.ie>
Date: Sat, 27 Dec 2008 18:25:12 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <494B9754.6000403@koala.ie>
	<37219a840812191046o68406337wda5fec55a4bf1fcf@mail.gmail.com>
In-Reply-To: <37219a840812191046o68406337wda5fec55a4bf1fcf@mail.gmail.com>
Subject: Re: [linux-dvb] can you confirm that the nova-td-500 is supported
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
> On Fri, Dec 19, 2008 at 7:45 AM, Simon Kenyon <simon@koala.ie> wrote:
>   
>> just bought what i though was a t-500 and when i opened the box it
>> contained a td-500
>>
>> the wiki says (in bright bold colours) that it is not (and never would
>> be) supported
>>
>> however, from looking at the mailing list it appear to be supported
>>
>> i can of course take it out of the sealed bag and try
>>
>> however, to preserve any change of swapping it i thought i would ask
>> here first
>>     
>
> There is a very old version of the board that is not supported.  There
> are very few of those boards around nowadays.
>
> The new Nova-TD-500 is definitely supported.  Look for the 84xxx model
> number -- that is the new revision.  This is the one that you are
> likely to have, if you recently purchased that board.
>
> Regards,
>
> Mike
>
>   
well i have been trying to get this to work for a few days now. this is 
what appears in the kernel log:

dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in cold state, will try 
to load a firmware
firmware: requesting dvb-usb-dib0700-1.20.fw
[snip]
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[snip]
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
ep 0 read error (status = -32)
I2C read failed on address 41
ep 0 read error (status = -32)
I2C read failed on address 40
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully initialized and 
connected.
usbcore: registered new interface driver dvb_usb_dib0700

i can tzap to a channel, but get nothing when i try to read from 
/dev/dvb/adapter0/dvr0

also i get errors from w_scan:

tune to: :738000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :770000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :794000:I999B8C999D999M999T999G999Y999:T:27500:
----------no signal----------
tune to: :794000:I999B8C999D999M999T999G999Y999:T:27500: (no signal)
----------no signal----------
tune to: :818000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
dumping lists (0 services)
Done.






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
