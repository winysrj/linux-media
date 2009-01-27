Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1LRu2w-0001W4-0p
	for linux-dvb@linuxtv.org; Tue, 27 Jan 2009 20:56:31 +0100
Message-ID: <497F66E5.9060901@gmail.com>
Date: Tue, 27 Jan 2009 23:56:21 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Manu <eallaud@gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<1232998154.24736.2@manu-laptop>
In-Reply-To: <1232998154.24736.2@manu-laptop>
Content-Type: multipart/mixed; boundary="------------010004050902030105020602"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
 on HDchannels
Reply-To: linux-media@vger.kernel.org
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
--------------010004050902030105020602
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Manu wrote:
> Le 26.01.2009 13:50:24, Manu Abraham a écrit :
>> On Mon, Jan 26, 2009 at 8:19 PM, Alex Betis <alex.betis@gmail.com>
>> wrote:
>>
>>> Latest changes I can see at
>>>> http://mercurial.intuxication.org/hg/s2-liplianin/ were made about
>> 7
>>>> to 10 days ago. Is this correct? If that's correct, then I'm using
>>>> latest Igor drivers. And behavior described above is what I'm
>> getting.
>>>> I can't see anything related do high SR channels on Igor
>> repository.
>>> He did it few months ago. If you're on latest than you should have
>> it.
>>>
>>
>> It won't. All you will manage to do is burn your demodulator, if you
>> happen
>> to
>> be that lucky one, with that change. At least a few people have 
>> burned
>> demodulators by now, from what i do see.
> 
> Hmm OK, but is there by any chance a fix for those issues somewhere or 
> in the pipe at least? I am willing to test (as I already offered), I 
> can compile the drivers, spread printk or whatever else is needed to 
> get useful reports. Let me know if I can help sort this problem. BTW in 
> my case it is DVB-S2 30000 SR and FEC 5/6.

It was quite not appreciable on my part to provide a fix or reply in
time nor spend much time on it earlier, but that said i was quite
stuck up with some other things.

Can you please pull a copy of the multiproto tree
http://jusst.de/hg/multiproto or the v4l-dvb tree from
http://jusst.de/hg/v4l-dvb

and apply the following patch and comment what your result is ?
Before applying please do check whether you still have the issues.


BTW: lot of patience you have compared to the other users :)

Regards,
Manu


--------------010004050902030105020602
Content-Type: text/x-patch;
 name="increase_timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="increase_timeout.patch"

--- a/linux/drivers/media/dvb/frontends/stb0899_algo.c  Tue Jan 27 23:29:44 2009 +0400
+++ b/linux/drivers/media/dvb/frontends/stb0899_algo.c  Tue Jan 27 23:48:52 2009 +0400
@@ -1345,6 +1345,10 @@
                FecLockTime     = 20;   /* 20 ms max time to lock FEC, 20Mbs< SYMB <= 25Mbs             */
        }

+       /* give a factor of safety */
+       searchTime *= 3;
+       FecLockTime *= 3;
+
        /* Maintain Stream Merger in reset during acquisition   */
        reg = stb0899_read_reg(state, STB0899_TSTRES);
        STB0899_SETFIELD_VAL(FRESRS, reg, 1);


--------------010004050902030105020602
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010004050902030105020602--
