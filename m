Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JrrUy-0002y7-F7
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 11:24:13 +0200
Received: by py-out-1112.google.com with SMTP id a29so1506153pyi.0
	for <linux-dvb@linuxtv.org>; Fri, 02 May 2008 02:24:07 -0700 (PDT)
Message-ID: <c8b4dbe10805020224l75b58f98ycef9c022b00b5bc2@mail.gmail.com>
Date: Fri, 2 May 2008 10:24:07 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Juan Antonio Garcia" <juanantonio_garcia_01@yahoo.es>
In-Reply-To: <d9def9db0805011258v664fdcbegcff266581670b4a6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <905882.45101.qm@web23108.mail.ird.yahoo.com>
	<d9def9db0805011258v664fdcbegcff266581670b4a6@mail.gmail.com>
Cc: Jakob Steidl <j.steidl@liwest.at>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB driver for Pinnacle PCTV200e and PCTV60e
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

On Thu, May 1, 2008 at 8:58 PM, Markus Rechberger <mrechberger@gmail.com> wrote:
> Hi,
>
>
>  On 5/1/08, Juan Antonio Garcia <juanantonio_garcia_01@yahoo.es> wrote:
>  >
>  > Hi,
>  >
>  > I updated the driver for being supported in kernel 2.6.24 (Ubuntu 8.04).
>  >
>  > I am distributing the update thought the Ubuntu forums, but it would be
>  > better to distribute it to more users. So Linux has more HW supported.
>  >
>  > What it should be done so it is included in the v4l tree?
>  >
>
>  I forwarded the mail to the linux-dvb ML.
>
>  > Now the driver supports 2 devices:
>  >
>  > - Pinnacle PCTV 200e
>  > - Pinnacle PCTV 60e
>  >
>  > The driver wiki is:
>  >
>  > http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_200e
>  >
>
>  Markus

Hi,

This driver seems like it should be trivial to get working on
linux-dvb, which is where you want it - the tree you've based it on
isn't much longer for this world. (I don't think any of the code
you're using has changed significantly between Markus' branch and the
main one). It needs some cleanup, though. At a glance:

- Don't use C++-style comments (the single-line // ones)
- The whole "addr == pctv200e_mt2060_config.i2c_address" part looks
iffy; I think you should remove this and use i2c_gate_ctrl instead.
Unfortunately, I'm not sure this'll work currently, since mt2060
doesn't appear to support it.
- ctrl_msg_last_device/ctrl_msg_last_operation must go - they won't
work right if you use multiple devices of this type. The code in the
"if (ctrl_msg_last_device == 0)" section can probably go elsewhere,
but I'm not sure where
- Why are you incrementing the register value in pctv200e_ctrl_msg?

The linuxtv developers will probably be able to give you more advice.

Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
