Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 16 Sep 2008 12:36:46 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <412bdbff0809160544h28f90d86x81adcb37626fd518@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-id: <48CFE09E.2030009@linuxtv.org>
MIME-version: 1.0
References: <412bdbff0809152102j4faa675cw3134efe5403020bd@mail.gmail.com>
	<48CF3D97.40805@linuxtv.org>
	<412bdbff0809160544h28f90d86x81adcb37626fd518@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] [FIX] Use correct firmware for the ATI TV Wonder 600
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

Devin Heitmueller wrote:
> On Tue, Sep 16, 2008 at 1:01 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> I'll push this in... I like the fact that you defined the xc3028L firmware in the header -- I will also push up a patch to change the HVR1400 (cx23885 ExpressCard) to use XC3028L_DEFAULT_FIRMWARE instead of specifying the filename explicitly.
> 
> Michael,
> 
> Thanks for your help in getting this pulled in.  The moral of this
> story seems to have been that it's *way* easier to just buy the damn
> thing than to add support for someone's device remotely.  92 emails
> over three weeks to get support added versus 1 evening to get support
> working right.  :-)

/me nods

Better still, have someone give you a device for free in return for help.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
