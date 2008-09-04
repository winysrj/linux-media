Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KbOD8-0003Ja-5y
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 01:25:58 +0200
Received: by wf-out-1314.google.com with SMTP id 27so169863wfd.17
	for <linux-dvb@linuxtv.org>; Thu, 04 Sep 2008 16:25:52 -0700 (PDT)
Message-ID: <e32e0e5d0809041625y22993606vae7f7ee63e936f9c@mail.gmail.com>
Date: Thu, 4 Sep 2008 16:25:51 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: stoth@linuxtv.org, "linux dvb" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1566724572=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1566724572==
Content-Type: multipart/alternative;
	boundary="----=_Part_62760_22233465.1220570751987"

------=_Part_62760_22233465.1220570751987
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> Tim Lucas wrote:
>
>> For some reason, when I  add the line
>> options cx23885 card=6
>> I can no longer boot the machine successfully.
>> The machine hangs saying that
>>
>> (Ctl-alt-F1)
>> kinit: No resume image, doing normal boot . . .
>> (Ctl-alt-F8)
>> udevd-event[3374]: run-program: '/sbin/modprobe' abnormal exit
>>
>> After a while it continues to boot, but the messages go by so fast that I
>> can't read them.  Finally, it just sits on a blank screen.  Since
2.6.24-19
>> was originally installed and it updated to 2.6.24-21, I am able to boot
into
>> the older kernel and then comment out that line.
>>
>> I am pretty sure that HVR1500 is card 6, so I am not sure what is wrong.
>>  I didn't have that problem, the first time I rebooted, but have had that
>> problem on every succesive reboot.
>>
>> Any ideas?
>>
>
> Please cc the list in all email, which I've done.
>
> Check the /var/log/messages or kern.log files to see what they contain.
>
> Or, if the system isn't booting, remove the module from your
> /lib/modules/`uname -r`/kernel/drivers/media/video/cx23885 dir then boot
> again.
>
> The card won't get initialised by the driver won't exist, then you can
> install the driver with 'make install' which will install it from your
> linux-dvb/v4l test tree, then load it at your own leisure with modprobe
> cx23885 debug=1.
>
>
> - Steve
>

Using your instructions, I figured out that the driver will not load using
modprobe. That is why the computer has trouble booting with that driver and
the HVR-1500 card selected.I also tried copying the relevant code and
putting it into the DViCO FusionHDTV7 Dual Express area to see if that
worked. I had the same results as when I tried loading the card as a
HVR-1500. I cannot get any signal from the card that way.  I know the card
is getting a signal because it shows a signal when loaded as a digital card.
 If you have any suggestions I would appreciate them.  Thank you.

-- 
--Tim

------=_Part_62760_22233465.1220570751987
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div><span class="Apple-style-span" style="border-collapse: collapse; ">&gt; Tim Lucas wrote:<br>&gt;<br>&gt;&gt; For some reason, when I &nbsp;add the line<br>&gt;&gt; options cx23885 card=6<br>&gt;&gt; I can no longer boot the machine successfully.<br>
&gt;&gt; The machine hangs saying that<br>&gt;&gt;<br>&gt;&gt; (Ctl-alt-F1)<br>&gt;&gt; kinit: No resume image, doing normal boot . . .<br>&gt;&gt; (Ctl-alt-F8)<br>&gt;&gt; udevd-event[3374]: run-program: &#39;/sbin/modprobe&#39; abnormal exit<br>
&gt;&gt;<br>&gt;&gt; After a while it continues to boot, but the messages go by so fast that I<br>&gt;&gt; can&#39;t read them. &nbsp;Finally, it just sits on a blank screen. &nbsp;Since 2.6.24-19<br>&gt;&gt; was originally installed and it updated to 2.6.24-21, I am able to boot into<br>
&gt;&gt; the older kernel and then comment out that line.<br>&gt;&gt;<br>&gt;&gt; I am pretty sure that HVR1500 is card 6, so I am not sure what is wrong.<br>&gt;&gt; &nbsp;I didn&#39;t have that problem, the first time I rebooted, but have had that<br>
&gt;&gt; problem on every succesive reboot.<br>&gt;&gt;<br>&gt;&gt; Any ideas?<br>&gt;&gt;<br>&gt;<br>&gt; Please cc the list in all email, which I&#39;ve done.<br>&gt;<br>&gt; Check the /var/log/messages or kern.log files to see what they contain.<br>
&gt;<br>&gt; Or, if the system isn&#39;t booting, remove the module from your<br>&gt; /lib/modules/`uname -r`/kernel/drivers/media/video/cx23885 dir then boot<br>&gt; again.<br>&gt;<br>&gt; The card won&#39;t get initialised by the driver won&#39;t exist, then you can<br>
&gt; install the driver with &#39;make install&#39; which will install it from your<br>&gt; linux-dvb/v4l test tree, then load it at your own leisure with modprobe<br>&gt; cx23885 debug=1.<br>&gt;<br>&gt;<br>&gt; - Steve<br>
&gt;</span></div><div><span class="Apple-style-span" style="border-collapse: collapse;"><br></span></div>Using your instructions, I figured out that the driver will not load using modprobe.&nbsp;That is why the computer has trouble booting with that driver and the HVR-1500 card selected.<div>
I also tried copying the relevant code and putting it into the DViCO FusionHDTV7 Dual Express area to see if that worked.&nbsp;I had the same results as when I tried loading the card as a HVR-1500.&nbsp;I cannot get any signal from the card that way. &nbsp;I know the card is getting a signal because it shows a signal when loaded as a digital card. &nbsp;If you have any suggestions I would appreciate them. &nbsp;Thank you.</div>
<div><br></div><div>-- <br> --Tim<br>
</div></div>

------=_Part_62760_22233465.1220570751987--


--===============1566724572==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1566724572==--
