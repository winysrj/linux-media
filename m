Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <czhang1974@gmail.com>) id 1KTeWy-0003E8-WC
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 17:14:30 +0200
Received: by wr-out-0506.google.com with SMTP id 50so599979wra.13
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 08:14:24 -0700 (PDT)
Message-ID: <bd41c5f0808140814n4cb6a2cdn597a1a9dcce14fc2@mail.gmail.com>
Date: Thu, 14 Aug 2008 15:14:24 +0000
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

On Wed, Aug 13, 2008 at 4:39 PM, Paul Marks <paul@pmarks.net> wrote:
> On Wed, Aug 13, 2008 at 9:05 AM, Chaogui Zhang <czhang1974@gmail.com> wrote:
>>
>> Do the following and see if it works:
>>
>> Power off your system (don't just reboot), then unplug power, wait for
>> 20 seconds and plug it back in then start your Ubuntu.
>
> Hey, you're right!  Thanks.  The remote is working perfectly on Gentoo
> now.  0x6b is also visible in i2cdetect.
>
> On Wed, Aug 13, 2008 at 9:11 AM, Steven Toth <stoth@linuxtv.org> wrote:
>>
>> If this is true, and the IR device reset line is wired to the bridge, we
>> should try to identify the GPIO and force a device reset on driver load.
>
> If you can't figure out how to reset it, then at least put a comment
> in the kernel code mentioning the need to power off.  It might save
> someone a lot of effort in the future.

I don't think users look at the driver code that often when running
into a problem like that. Instead, I added a note on the wiki page
http://www.linuxtv.org/wiki/index.php/DViCO_FusionHDTV5_RT_Gold for
this card so others can find it easily if they google.

-- 
Chaogui Zhang

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
