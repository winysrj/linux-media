Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <czhang1974@gmail.com>) id 1KTRBr-0006DO-1k
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 02:59:48 +0200
Received: by wr-out-0506.google.com with SMTP id 50so249600wra.13
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 17:59:43 -0700 (PDT)
Message-ID: <bd41c5f0808131759n12273e40xca994123c12d952a@mail.gmail.com>
Date: Wed, 13 Aug 2008 20:59:42 -0400
From: "Chaogui Zhang" <czhang1974@gmail.com>
To: "Paul Marks" <paul@pmarks.net>
In-Reply-To: <8e5b27790808130939m43918485kb81128ccbe782621@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
	<8e5b27790808122233r539e6404y777e2bade7c78b47@mail.gmail.com>
	<bd41c5f0808130905y30efc79m84bdcf5128c425a@mail.gmail.com>
	<8e5b27790808130939m43918485kb81128ccbe782621@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] FusionHDTV5 IR not working.
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

On Wed, Aug 13, 2008 at 12:39 PM, Paul Marks <paul@pmarks.net> wrote:
> On Wed, Aug 13, 2008 at 9:05 AM, Chaogui Zhang <czhang1974@gmail.com> wrote:
>>
>> Do the following and see if it works:
>>
>> Power off your system (don't just reboot), then unplug power, wait for
>> 20 seconds and plug it back in then start your Ubuntu.
>
> Hey, you're right!  Thanks.  The remote is working perfectly on Gentoo
> now.  0x6b is also visible in i2cdetect.

Good to hear that it works now. You probably want to avoid running
i2cdetect or any other tools that touch the i2c bus. We discovered
that the IR receiver is very "intolerant". It disappears if you try to
probe it in any way. See the following discussing for more details:

http://lists-archives.org/video4linux/19405-ir-remote-support-for-fusion-rt-gold.html

>
> On Wed, Aug 13, 2008 at 9:11 AM, Steven Toth <stoth@linuxtv.org> wrote:
>>
>> If this is true, and the IR device reset line is wired to the bridge, we
>> should try to identify the GPIO and force a device reset on driver load.
>
That would be the ideal solution, although I don't know how to reset
the IR chip via GPIO and I don't know if that is even possible. DViCO
advises their windows user to unplug the power if the remote stops
working suddenly :). It seems likely that a software reset may not be
doable, otherwise I assume the DViCO software would have done that,
but you never know.

Note that you do not need to do the unplug power trick every time you
power up the machine. The code is now safe enough that as long as no
intentional i2c bus probing is done by the user, the ir receiver
should work. The only time I had an issue was when I accidentally
unplugged the ir receiver, then when I plugged it back in, the remote
stopped working, so I had to do the power off trick. I have been using
the remote since I submitted my patch about a year ago and that was
the only time I had to cut power to my system to reset the IR.

PS: See http://www.fusionhdtv.co.kr/ENG/Support/FAQRemote.aspx?act=RD&id=316&pg=0&CATID=13
for DViCO's support page which mentions the trick.

-- 
Chaogui Zhang

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
