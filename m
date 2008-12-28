Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mjenks1968@gmail.com>) id 1LGyNA-00051B-Es
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 17:20:13 +0100
Received: by wf-out-1314.google.com with SMTP id 27so5294838wfd.17
	for <linux-dvb@linuxtv.org>; Sun, 28 Dec 2008 08:20:06 -0800 (PST)
Message-ID: <e5df86c90812280820q78505583lb4e772bdf208a8d@mail.gmail.com>
Date: Sun, 28 Dec 2008 10:20:06 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
MIME-Version: 1.0
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0599440042=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0599440042==
Content-Type: multipart/alternative;
	boundary="----=_Part_124582_18144732.1230481206190"

------=_Part_124582_18144732.1230481206190
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> I tried to install a hvr-1800 in it yesterday, and I get a kernel oops on
> it and X won't start.   I compiled up a 2.6.27.10 kernel for it, and moved
> to that, and I still get the oops.    Checked my vmalloc and I am fine, but
> increased it anyways to 384 just for grins.
>

That is a nasty bug that you are hitting. You shouldn't get NULL
dereferences at any time. I'd either file this at the kernel's bugzilla or
try to get it attention some other way. I'm not a systems programmer so I
can't really help with a code fix.


> Here is more than enough debug info, I hope.  :)
>

Have you tried  removing the 1250? Or moving the 1800 to a different slot?
Or even manually placing the 1250 and 1800 on different IRQs via the BIOS?
I'm not sure if any of this will work, but it might be worth a try.

Also, what does your relevant kernel config look like? I have the 1800 and
mine is:

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22702=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_ISL6421=m

Not all of these are needed, but my 1800 works perfectly with all these, so
hopefully it is something you can work off of. This config is from kernel
2.6.27.1.
 Reply

Forward

Invite Andrey Falko to chat

Mark JenksOkay, I noticed something else about this. With only the 1250
install, I stil...
4:21 PM (17 hours ago)
Mark JenksLoading...4:21 PM (17 hours ago)
Mark Jenks to Andrey
show details 4:21 PM (17 hours ago)
Reply



On Sat, Dec 27, 2008 at 1:07 PM, Andrey Falko <ma3oxuct@gmail.com> wrote:

> I tried to install a hvr-1800 in it yesterday, and I get a kernel oops on
>> it and X won't start.   I compiled up a 2.6.27.10 kernel for it, and moved
>> to that, and I still get the oops.    Checked my vmalloc and I am fine, but
>> increased it anyways to 384 just for grins.
>>
>
> That is a nasty bug that you are hitting. You shouldn't get NULL
> dereferences at any time. I'd either file this at the kernel's bugzilla or
> try to get it attention some other way. I'm not a systems programmer so I
> can't really help with a code fix.
>
>
>> Here is more than enough debug info, I hope.  :)
>>
>
> Have you tried  removing the 1250? Or moving the 1800 to a different slot?
> Or even manually placing the 1250 and 1800 on different IRQs via the BIOS?
> I'm not sure if any of this will work, but it might be worth a try.
>
>
Okay, I noticed something else about this.  With only the 1250 install, I
still show a conflict, but it's with nvidia.  Which I am guessing is my
graphics module.

# cat /proc/interrupts
           CPU0       CPU1
  0:         43        122   IO-APIC-edge      timer
  1:          0         10   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge      parport0
  8:          1         98   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 10:          0          0   IO-APIC-edge      MPU401 UART
 12:          0        114   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      pata_amd
 15:        428     110508   IO-APIC-edge      pata_amd
 16:     692578     871510   IO-APIC-fasteoi   cx23885[0], nvidia
 17:          0         59   IO-APIC-fasteoi   aic7xxx
 19:          0          3   IO-APIC-fasteoi   ohci1394
 20:          0          4   IO-APIC-fasteoi   ehci_hcd:usb2
 21:      10431    2805257   IO-APIC-fasteoi   ohci_hcd:usb1
 22:          9     301431   IO-APIC-fasteoi   sata_nv, HDA Intel
 23:    2188108       9575   IO-APIC-fasteoi   sata_nv, eth0
NMI:          0          0   Non-maskable interrupts
LOC:    3616861    3955952   Local timer interrupts
RES:     405641     865050   Rescheduling interrupts
CAL:       2622       2092   function call interrupts
TLB:        727        496   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0


 Reply

Forward



Andrey Falko to me
show details 10:01 PM (12 hours ago)
Reply

On Sat, Dec 27, 2008 at 2:21 PM, Mark Jenks <mjenks1968@gmail.com> wrote:


> Okay, I noticed something else about this.  With only the 1250 install, I
> still show a conflict, but it's with nvidia.  Which I am guessing is my
> graphics module.
>
>
That is a good point. If you do report a bug make sure you are running the
open source nv driver and not the proprietary nvidia driver. I am running
the proprietary driver without issues, but trying the nv driver is another
thing for you to try.
 Reply

Forward

Invite Andrey Falko to chat





Your message has been sent.



Mark Jenks to Andrey
show details 10:17 AM (1 minute ago)
Reply

- Show quoted text -


On Sat, Dec 27, 2008 at 10:01 PM, Andrey Falko <ma3oxuct@gmail.com> wrote:

> On Sat, Dec 27, 2008 at 2:21 PM, Mark Jenks <mjenks1968@gmail.com> wrote:
>
>
>> Okay, I noticed something else about this.  With only the 1250 install, I
>> still show a conflict, but it's with nvidia.  Which I am guessing is my
>> graphics module.
>>
>>
> That is a good point. If you do report a bug make sure you are running the
> open source nv driver and not the proprietary nvidia driver. I am running
> the proprietary driver without issues, but trying the nv driver is another
> thing for you to try.
>

The nv drvier I don't believe is going to work for me at all.   I use
Composite video out from my MB.

-Mark
>
>
>

------=_Part_124582_18144732.1230481206190
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div id=":2se" class="ArwC7c ckChnd"><div class="gmail_quote"><div class="Ih2E3d"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">I
tried to install a hvr-1800 in it yesterday, and I get a kernel oops on
it and X won&#39;t start.&nbsp;&nbsp; I compiled up a 2.6.27.10 kernel for it, and
moved to that, and I still get the oops.&nbsp;&nbsp;&nbsp; Checked my vmalloc and I am
fine, but increased it anyways to 384 just for grins.<br>

</blockquote></div><div><br>That is a nasty bug that you are hitting.
You shouldn&#39;t get NULL dereferences at any time. I&#39;d either file this
at the kernel&#39;s bugzilla or try to get it attention some other way. I&#39;m
not a systems programmer so I can&#39;t really help with a code fix.<br>
<br></div><div class="Ih2E3d"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>Here is more than enough debug info, I hope.&nbsp; :)<br></blockquote>
</div><div><br>Have
you tried&nbsp; removing the 1250? Or moving the 1800 to a different slot?
Or even manually placing the 1250 and 1800 on different IRQs via the
BIOS? I&#39;m not sure if any of this will work, but it might be worth a
try.<br>
<br>Also, what does your relevant kernel config look like? I have the 1800 and mine is:<br><br>#<br># Multimedia devices<br>#<br><br>#<br># Multimedia core support<br>#<br>CONFIG_VIDEO_DEV=m<br>CONFIG_VIDEO_V4L2_COMMON=m<br>

# CONFIG_VIDEO_ALLOW_V4L1 is not set<br>CONFIG_VIDEO_V4L1_COMPAT=y<br>CONFIG_DVB_CORE=m<br>CONFIG_VIDEO_MEDIA=m<br><br>#<br># Multimedia drivers<br>#<br>CONFIG_MEDIA_TUNER=m<br>CONFIG_MEDIA_TUNER_SIMPLE=m<br>CONFIG_MEDIA_TUNER_TDA8290=m<br>

CONFIG_MEDIA_TUNER_TDA18271=m<br>CONFIG_MEDIA_TUNER_TDA9887=m<br>CONFIG_MEDIA_TUNER_TEA5761=m<br>CONFIG_MEDIA_TUNER_TEA5767=m<br>CONFIG_MEDIA_TUNER_MT20XX=m<br>CONFIG_MEDIA_TUNER_MT2131=m<br>CONFIG_MEDIA_TUNER_XC2028=m<br>

CONFIG_MEDIA_TUNER_XC5000=m<br>CONFIG_VIDEO_V4L2=m<br>CONFIG_VIDEOBUF_GEN=m<br>CONFIG_VIDEOBUF_DMA_SG=m<br>CONFIG_VIDEOBUF_DVB=m<br>CONFIG_VIDEO_BTCX=m<br>CONFIG_VIDEO_IR=m<br>CONFIG_VIDEO_TVEEPROM=m<br>CONFIG_VIDEO_TUNER=m<br>

CONFIG_VIDEO_CAPTURE_DRIVERS=y<br>CONFIG_VIDEO_HELPER_CHIPS_AUTO=y<br>CONFIG_VIDEO_IR_I2C=m<br>CONFIG_VIDEO_WM8775=m<br>CONFIG_VIDEO_CX25840=m<br>CONFIG_VIDEO_CX2341X=m<br>CONFIG_VIDEO_CX88=m<br>CONFIG_VIDEO_CX88_ALSA=m<br>

CONFIG_VIDEO_CX88_BLACKBIRD=m<br>CONFIG_VIDEO_CX88_DVB=m<br>CONFIG_VIDEO_CX88_VP3054=m<br>CONFIG_VIDEO_CX23885=m<br>CONFIG_DVB_CAPTURE_DRIVERS=y<br><br>#<br># DVB-S (satellite) frontends<br>#<br>CONFIG_DVB_CX24123=m<br><br>

#<br># DVB-T (terrestrial) frontends<br>#<br>CONFIG_DVB_CX22702=m<br>CONFIG_DVB_MT352=m<br>CONFIG_DVB_ZL10353=m<br>CONFIG_DVB_DIB7000P=m<br>CONFIG_DVB_TDA10048=m<br><br>#<br># ATSC (North American/Korean Terrestrial/Cable DTV) frontends<br>

#<br>CONFIG_DVB_NXT200X=m<br>CONFIG_DVB_OR51132=m<br>CONFIG_DVB_LGDT330X=m<br>CONFIG_DVB_S5H1409=m<br>CONFIG_DVB_S5H1411=m<br><br>#<br># Digital terrestrial only tuners/PLL<br>#<br>CONFIG_DVB_PLL=m<br><br>#<br># SEC control devices for DVB-S<br>

#<br>CONFIG_DVB_ISL6421=m<br><br>Not
all of these are needed, but my 1800 works perfectly with all these, so
hopefully it is something you can work off of. This config is from
kernel 2.6.27.1.<br></div></div>
</div><div class="LYI6Sd ckChnd"><div class="eNXyxd"><table class="EWdQcf"><tbody><tr><td><div class="cKWzSc X5Xvu"><img class="INkyme" src="images/cleardot.gif"> <span class="qZkfSe">Reply</span></div></td><td><br></td>
<td><div class="XymfBd X5Xvu"><img class="DTkpKe" src="images/cleardot.gif"> <span class="qZkfSe">Forward</span></div></td><td><br></td><td><div class="sKKCaf X5Xvu"><img class="eFsX1b" src="images/cleardot.gif"> <span class="qZkfSe">Invite Andrey Falko to chat</span></div>
</td><td class="bEgJye"><br></td></tr></tbody></table></div></div><div class="XoqCub"><div class="CNf1Cd"><div class="R7iiN c1norb"><div class="R7iiN vHYYR" style="margin-left: 4px;"><div class="wWwc8d" style="margin: -10px 0px 0px; padding: 0px;">
<div class="diLZtc"><div class="XoqCub"><div id=":2uy"><div style="display: none;" class="FL1GFc"><div class="AG5mQe RRKCwe"><img class="UFDhhb" src="images/cleardot.gif"></div><div class="YrSjGe ckChnd"><div class="ObUWHc hj2SD">
<table class="BwDhwd"><tbody><tr><td class="zyVlgb XZlFIc" style="width: auto;"><span class="lHQn1d"><img class="KaaYad QgQaBc" src="images/cleardot.gif"></span><span class="JDpiNd"><img class="ilX2xb" id="upi" name="upi" src="images/cleardot.gif" width="16" height="16"></span><span class="EP8xU" style="color: rgb(0, 104, 28);">Mark Jenks</span></td>
<td class="zyVlgb XZlFIc"><table class="K9osId"><tbody><tr><td><div class="IUCKJe bWGucb">Okay, I noticed something else about this. With only the 1250 install, I stil...</div></td></tr></tbody></table></td><td class="i8p5Ld">
<div class="XZlFIc"><span id=":2vg" class="rziBod" title="Sat, Dec 27, 2008 at 4:21 PM" alt="Sat, Dec 27, 2008 at 4:21 PM">4:21 PM (17 hours ago)</span> <span></span></div></td></tr></tbody></table></div></div></div><div class="ExShKe" style="display: none;">
<div class="AG5mQe RRKCwe"><img class="UFDhhb" src="images/cleardot.gif"></div><div class="YrSjGe ckChnd"><div class="ObUWHc rOkvff"><table class="BwDhwd"><tbody><tr><td class="zyVlgb XZlFIc"><span class="lHQn1d"><img class="KaaYad QgQaBc" src="images/cleardot.gif"></span><span class="JDpiNd"><img class="ilX2xb QrVm3d" id="upi" name="upi" src="images/cleardot.gif" width="16" height="16"></span><span class="EP8xU" style="color: rgb(0, 104, 28);">Mark Jenks</span><span class="bWGucb">Loading...</span></td>
<td class="i8p5Ld"><div class="XZlFIc"><span id=":2sn" class="rziBod" title="Sat, Dec 27, 2008 at 4:21 PM" alt="Sat, Dec 27, 2008 at 4:21 PM">4:21 PM (17 hours ago)</span> <span></span></div></td></tr></tbody></table></div>
</div></div><div class="HprMsc" style=""><div class="AG5mQe RRKCwe"><img class="UFDhhb" src="images/cleardot.gif"></div><div class="YrSjGe"><div class="ObUWHc qNeRme ckChnd"><table class="BwDhwd"><tbody><tr><td class="zyVlgb XZlFIc">
<table class="O5Harb"><tbody><tr><td><div class="xUReW"><span class="lHQn1d"><img class="KaaYad QgQaBc" src="images/cleardot.gif"></span><span class="JDpiNd"><img class="ilX2xb QrVm3d" id="upi" name="upi" src="images/cleardot.gif" width="16" height="16"></span><h3 class="EP8xU" style="color: rgb(0, 104, 28);">
<span>Mark Jenks</span></h3>&nbsp;<span class="tQWRdd">to <span class="Zv5tZd">Andrey</span> </span></div></td></tr></tbody></table></td><td class="i8p5Ld"><div class="XZlFIc"><span class="D05ws">show details</span> <span id=":2sq" class="rziBod" title="Sat, Dec 27, 2008 at 4:21 PM" alt="Sat, Dec 27, 2008 at 4:21 PM">4:21 PM (17 hours ago)</span> <span></span></div>
</td><td class="i8p5Ld"><div class="JbJ6Ye"><table class="gQ8wIf" id=":2ss"><tbody><tr><td class="cTzXV LtBCcf t9K9Me"><img class="DC6qBf" src="images/cleardot.gif"></td><td class="cTzXV t9K9Me"><div class="SvrlRe">Reply</div>
</td><td class="t9K9Me"><br></td><td class="wtnCQd tP6gIf t9K9Me"><img class="S1nudd" src="images/cleardot.gif"></td></tr></tbody></table></div></td></tr></tbody></table></div><div id=":2so" class="ArwC7c ckChnd"><br><br>
<div class="gmail_quote"><div class="Ih2E3d">On Sat, Dec 27, 2008 at 1:07 PM, Andrey Falko <span dir="ltr">&lt;<a href="mailto:ma3oxuct@gmail.com" target="_blank">ma3oxuct@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div class="gmail_quote"><div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">I
tried to install a hvr-1800 in it yesterday, and I get a kernel oops on
it and X won&#39;t start.&nbsp;&nbsp; I compiled up a 2.6.27.10 kernel for it, and
moved to that, and I still get the oops.&nbsp;&nbsp;&nbsp; Checked my vmalloc and I am
fine, but increased it anyways to 384 just for grins.<br>


</blockquote></div><div><br>That is a nasty bug that you are hitting.
You shouldn&#39;t get NULL dereferences at any time. I&#39;d either file this
at the kernel&#39;s bugzilla or try to get it attention some other way. I&#39;m
not a systems programmer so I can&#39;t really help with a code fix.<br>

<br></div><div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>Here is more than enough debug info, I hope.&nbsp; :)<br></blockquote>
</div><div><br>Have you tried&nbsp; removing the 1250? Or moving the 1800 to
a different slot? Or even manually placing the 1250 and 1800 on
different IRQs via the BIOS? I&#39;m not sure if any of this will work, but
it might be worth a try.<br>

<br></div></div></blockquote></div><div><br>Okay, I noticed something
else about this.&nbsp; With only the 1250 install, I still show a conflict,
but it&#39;s with nvidia.&nbsp; Which I am guessing is my graphics module.<div class="Ih2E3d"><br><br># cat /proc/interrupts<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CPU0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CPU1<br></div>&nbsp; 0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 43&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 122&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; timer<br>&nbsp; 1:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i8042<div class="Ih2E3d"><br>&nbsp; 7:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; parport0<br>
</div>&nbsp; 8:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 98&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rtc0<div class="Ih2E3d"><br>
&nbsp; 9:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; acpi<br>&nbsp;10:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MPU401 UART<br>&nbsp;12:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 114&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i8042<br>&nbsp;14:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pata_amd<br>
</div>
&nbsp;15:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 428&nbsp;&nbsp;&nbsp;&nbsp; 110508&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pata_amd<br>&nbsp;16:&nbsp;&nbsp;&nbsp;&nbsp; 692578&nbsp;&nbsp;&nbsp;&nbsp; 871510&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; cx23885[0], nvidia<br>&nbsp;17:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 59&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; aic7xxx<div class="Ih2E3d"><br>&nbsp;19:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; ohci1394<br>

&nbsp;20:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; ehci_hcd:usb2<br></div>&nbsp;21:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10431&nbsp;&nbsp;&nbsp; 2805257&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; ohci_hcd:usb1<br>&nbsp;22:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9&nbsp;&nbsp;&nbsp;&nbsp; 301431&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; sata_nv, HDA Intel<br>&nbsp;23:&nbsp;&nbsp;&nbsp; 2188108&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9575&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; sata_nv, eth0<div class="Ih2E3d">
<br>
NMI:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Non-maskable interrupts<br></div>LOC:&nbsp;&nbsp;&nbsp; 3616861&nbsp;&nbsp;&nbsp; 3955952&nbsp;&nbsp; Local timer interrupts<br>RES:&nbsp;&nbsp;&nbsp;&nbsp; 405641&nbsp;&nbsp;&nbsp;&nbsp; 865050&nbsp;&nbsp; Rescheduling interrupts<br>CAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2622&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2092&nbsp;&nbsp; function call interrupts<br>

TLB:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 727&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 496&nbsp;&nbsp; TLB shootdowns<div class="Ih2E3d"><br>TRM:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Thermal event interrupts<br>SPU:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Spurious interrupts<br>ERR:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>MIS:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp;<br></div>
</div></div><br>
</div><div class="LYI6Sd ckChnd"><div class="eNXyxd"><table class="EWdQcf"><tbody><tr><td><div class="cKWzSc X5Xvu"><img class="INkyme" src="images/cleardot.gif"> <span class="qZkfSe">Reply</span></div></td><td><br></td>
<td><div class="XymfBd X5Xvu"><img class="DTkpKe" src="images/cleardot.gif"> <span class="qZkfSe">Forward</span></div></td><td><br></td><td><br></td><td class="bEgJye"><br></td></tr></tbody></table></div></div></div></div>
</div></div></div></div></div></div></div></div><div class="XoqCub"><div class="CNf1Cd"><div class="R7iiN c1norb"><div class="R7iiN vHYYR" style="margin-left: 4px;"><div class="wWwc8d" style="margin: -10px 0px 0px; padding: 0px;">
<div class="diLZtc"><div class="XoqCub"><div id=":2vj"><div class="HprMsc" style=""><div class="AG5mQe RRKCwe"><img class="UFDhhb" src="images/cleardot.gif"></div><div class="YrSjGe"><div class="ObUWHc qNeRme ckChnd"><table class="BwDhwd">
<tbody><tr><td class="zyVlgb XZlFIc"><table class="O5Harb"><tbody><tr><td><div class="xUReW"><span class="lHQn1d"><img class="KaaYad QgQaBc" src="images/cleardot.gif"></span><span class="JDpiNd"><img class="Jx04sb" id="upi" name="upi" src="images/cleardot.gif" width="16" height="16"></span><h3 class="EP8xU" style="color: rgb(121, 6, 25);">
<span>Andrey Falko</span></h3>&nbsp;<span class="tQWRdd">to <span class="Zv5tZd">me</span> </span></div></td></tr></tbody></table></td><td class="i8p5Ld"><div class="XZlFIc"><span class="D05ws">show details</span> <span id=":2v2" class="rziBod" title="Sat, Dec 27, 2008 at 10:01 PM" alt="Sat, Dec 27, 2008 at 10:01 PM">10:01 PM (12 hours ago)</span> <span></span></div>
</td><td class="i8p5Ld"><div class="JbJ6Ye"><table class="gQ8wIf" id=":2v1"><tbody><tr><td class="cTzXV LtBCcf t9K9Me"><img class="DC6qBf" src="images/cleardot.gif"></td><td class="cTzXV t9K9Me"><div class="SvrlRe">Reply</div>
</td><td class="t9K9Me"><br></td><td class="wtnCQd tP6gIf t9K9Me"><img class="S1nudd" src="images/cleardot.gif"></td></tr></tbody></table></div></td></tr></tbody></table></div><div id=":2vi" class="ArwC7c ckChnd"><div class="Ih2E3d">
On Sat, Dec 27, 2008 at 2:21 PM, Mark Jenks <span dir="ltr">&lt;<a href="mailto:mjenks1968@gmail.com" target="_blank">mjenks1968@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><div>&nbsp;</div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div class="gmail_quote"><div>Okay, I noticed something else about
this.&nbsp; With only the 1250 install, I still show a conflict, but it&#39;s
with nvidia.&nbsp; Which I am guessing is my graphics module.<div><br><br>
</div></div></div></blockquote></div><br></div>That is a good point. If
you do report a bug make sure you are running the open source nv driver
and not the proprietary nvidia driver. I am running the proprietary
driver without issues, but trying the nv driver is another thing for
you to try.<br>
</div><div class="LYI6Sd ckChnd"><div class="eNXyxd"><table class="EWdQcf"><tbody><tr><td class=""><div class="cKWzSc X5Xvu"><img class="INkyme" src="images/cleardot.gif"> <span class="qZkfSe">Reply</span></div></td><td>
<br></td><td><div class="XymfBd X5Xvu"><img class="DTkpKe" src="images/cleardot.gif"> <span class="qZkfSe">Forward</span></div></td><td><br></td><td><div class="sKKCaf X5Xvu"><img class="eFsX1b" src="images/cleardot.gif"> <span class="qZkfSe">Invite Andrey Falko to chat</span></div>
</td><td class="bEgJye"><br></td></tr></tbody></table></div></div></div></div></div></div></div></div></div></div></div></div><div style="" class="XoqCub"><div style="" class="n38jzf"><table class="cyVRte" cellpadding="0" cellspacing="0">
<tbody><tr><td class="zIVQRb"><br></td><td class="Ptde9b"><br></td><td class="Qrjz3e"><br></td></tr><tr><td class="Ptde9b"><br></td><td class="m14Grb">Your message has been sent.</td><td class="Ptde9b"><br></td></tr><tr><td class="Gbtri">
<br></td><td class="Ptde9b"><br></td><td class="gmNpMd"><br></td></tr></tbody></table></div></div><div class="AG5mQe"><img class="UFDhhb" src="images/cleardot.gif"></div><div class="ObUWHc qNeRme ckChnd"><table class="BwDhwd">
<tbody><tr><td class="zyVlgb XZlFIc"><table class="O5Harb"><tbody><tr><td><div class="xUReW"><span class="lHQn1d"><img class="KaaYad QgQaBc" src="images/cleardot.gif"></span><span class="JDpiNd"><img class="ilX2xb QrVm3d" id="upi" name="upi" src="images/cleardot.gif" width="16" height="16"></span><h3 class="EP8xU" style="color: rgb(0, 104, 28);">
<span>Mark Jenks</span></h3>&nbsp;<span class="tQWRdd">to <span class="Zv5tZd">Andrey</span> </span></div></td></tr></tbody></table></td><td class="i8p5Ld"><div class="XZlFIc"><span class="D05ws">show details</span> <span id=":2s4" class="rziBod" title="Sun, Dec 28, 2008 at 10:17 AM" alt="Sun, Dec 28, 2008 at 10:17 AM">10:17 AM (1 minute ago)</span> <span></span></div>
</td><td class="i8p5Ld"><div class="JbJ6Ye"><table class="gQ8wIf" id=":2s6"><tbody><tr><td class="cTzXV LtBCcf t9K9Me"><img class="DC6qBf" src="images/cleardot.gif"></td><td class="cTzXV t9K9Me"><div class="SvrlRe">Reply</div>
</td><td class="t9K9Me"><br></td><td class="wtnCQd tP6gIf t9K9Me"><img class="S1nudd" src="images/cleardot.gif"></td></tr></tbody></table></div></td></tr></tbody></table></div><div><div><span id="q_11e7e751be6cd7df_0" class="WQ9l9c">- Show quoted text -</span></div>
<div class="Wj3C7c"><br><br><div class="gmail_quote">On Sat, Dec 27, 2008 at 10:01 PM, Andrey Falko <span dir="ltr">&lt;<a href="mailto:ma3oxuct@gmail.com" target="_blank">ma3oxuct@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div>On Sat, Dec 27, 2008 at 2:21 PM, Mark Jenks <span dir="ltr">&lt;<a href="mailto:mjenks1968@gmail.com" target="_blank">mjenks1968@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><div>&nbsp;</div>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="gmail_quote"><div>Okay, I noticed something else about
this.&nbsp; With only the 1250 install, I still show a conflict, but it&#39;s
with nvidia.&nbsp; Which I am guessing is my graphics module.<div><br><br>
</div></div></div></blockquote></div><br></div>That is a good point. If
you do report a bug make sure you are running the open source nv driver
and not the proprietary nvidia driver. I am running the proprietary
driver without issues, but trying the nv driver is another thing for
you to try.<br>

</blockquote></div><br></div></div>The nv drvier I don&#39;t believe is going to work for me at all.&nbsp;&nbsp; I use Composite video out from my MB.<br><font color="#888888"><br>-Mark</font><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
</blockquote></div><br>

------=_Part_124582_18144732.1230481206190--


--===============0599440042==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0599440042==--
