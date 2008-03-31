Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anluoma@gmail.com>) id 1JgPwB-0003ju-B7
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 21:45:01 +0200
Received: by wr-out-0506.google.com with SMTP id c30so891384wra.14
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 12:44:52 -0700 (PDT)
Message-ID: <754a11be0803311244w319537f6s10c4f3028bb8117a@mail.gmail.com>
Date: Mon, 31 Mar 2008 22:44:50 +0300
From: "Antti Luoma" <anluoma@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <bbf19b3d0803291756q743eca07t4b2f8290dd47c3e4@mail.gmail.com>
MIME-Version: 1.0
References: <1206139910.12138.34.camel@youkaida>
	<af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
	<47EC13BE.6020600@simmons.titandsl.co.uk>
	<1206655986.17233.8.camel@youkaida>
	<8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
	<1206719797.14161.8.camel@acropora>
	<8ad9209c0803280936k2cba9115laa49f828ffda55bf@mail.gmail.com>
	<1206722837.12480.3.camel@acropora>
	<8ad9209c0803280951y7d4f2eb3k8368b43c2a666e3e@mail.gmail.com>
	<bbf19b3d0803291756q743eca07t4b2f8290dd47c3e4@mail.gmail.com>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0373738294=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0373738294==
Content-Type: multipart/alternative;
	boundary="----=_Part_26229_16820428.1206992690939"

------=_Part_26229_16820428.1206992690939
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

it's the the kernel version that causes the problem, you should compile it
yourself or get it from gentoo somehow.
I Think issue affects all USB-DVB-T users with kernel 2.6.24

see this post:
https://bugs.launchpad.net/ubuntu/+bug/209603

or

this list (solved post)

-antti-

2008/3/30, Ian Cullinan <cibyr@cibyr.com>:
>
> I've got one of these (which is described on it's mythTV wiki page as
> "fully and reliably supported") in a server that I'm trying to use as
> a mythtv backend. It seems I have become one of the many people having
> problems with this card and linux. mythtv tells me it can't get a
> channel lock, and dmesg tells me:
>
> usb 3-1: USB disconnect, address 2
> mt2060 I2C write failed
> dvb-usb: error while stopping stream.
>
> Interestingly, trying to run lsusb at this point seems to get stuck
> inside a system call or something because it never exits and kill -9
> doesn't kill it. Restarting mythbackend gets everything back.
>
> This is on kernel 2.6.24-gentoo-r3, with hardware:
> Gigabyte G33-DS3R motherboard (Intel G33 chipset)
> Intel Q6600
> 2GB RAM (dual channel DDR2-800)
>
> I'm using the dvb-usb-dib0700-1.10.fw firmware.
>
> I saw somewhere on the archives that someone found the problem went
> away with the following options to modprobe:
>
> options dvb-usb-dib0700 debug=1
> options mt2060 debug=1
> options dibx000_common debug=1
> options dvb_core debug=1
> options dvb_core dvbdev_debug=1
> options dvb_core frontend_debug=1
> options dvb_usb debug=1
> options dib3000mc debug=1
>
>
> Problem hasn't gone away (but seems less frequent), and I figure
> someone here could use the debugging data so here's the relevant part
> of my syslog:
> http://pastebin.com/f34ed8e20
> (disconnect even is pretty much at the top, and down the bottom is
> where I restarted mythbackend).
>
>
> Ian Cullinan
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
-Antti-

------=_Part_26229_16820428.1206992690939
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>it&#39;s the the kernel version that causes the problem, you should compile it yourself or get it from gentoo somehow.<br>I Think issue affects all USB-DVB-T users with kernel 2.6.24<br><br>see this post: <br><a href="https://bugs.launchpad.net/ubuntu/+bug/209603">https://bugs.launchpad.net/ubuntu/+bug/209603</a> <br>
<br>or <br><br>this list (solved post)<br><br>-antti-<br><br><div><span class="gmail_quote">2008/3/30, Ian Cullinan &lt;<a href="mailto:cibyr@cibyr.com">cibyr@cibyr.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;ve got one of these (which is described on it&#39;s mythTV wiki page as<br> &quot;fully and reliably supported&quot;) in a server that I&#39;m trying to use as<br> a mythtv backend. It seems I have become one of the many people having<br>
 problems with this card and linux. mythtv tells me it can&#39;t get a<br> channel lock, and dmesg tells me:<br> <br> usb 3-1: USB disconnect, address 2<br> mt2060 I2C write failed<br> dvb-usb: error while stopping stream.<br>
 <br> Interestingly, trying to run lsusb at this point seems to get stuck<br> inside a system call or something because it never exits and kill -9<br> doesn&#39;t kill it. Restarting mythbackend gets everything back.<br> <br>
 This is on kernel 2.6.24-gentoo-r3, with hardware:<br> Gigabyte G33-DS3R motherboard (Intel G33 chipset)<br> Intel Q6600<br> 2GB RAM (dual channel DDR2-800)<br> <br> I&#39;m using the dvb-usb-dib0700-1.10.fw firmware.<br>
 <br> I saw somewhere on the archives that someone found the problem went<br> away with the following options to modprobe:<br> <br>options dvb-usb-dib0700 debug=1<br> options mt2060 debug=1<br> options dibx000_common debug=1<br>
 options dvb_core debug=1<br> options dvb_core dvbdev_debug=1<br> options dvb_core frontend_debug=1<br> options dvb_usb debug=1<br> options dib3000mc debug=1<br> <br> <br>Problem hasn&#39;t gone away (but seems less frequent), and I figure<br>
 someone here could use the debugging data so here&#39;s the relevant part<br> of my syslog:<br> <a href="http://pastebin.com/f34ed8e20">http://pastebin.com/f34ed8e20</a><br> (disconnect even is pretty much at the top, and down the bottom is<br>
 where I restarted mythbackend).<br> <br><br> Ian Cullinan<br> <br><br> _______________________________________________<br> linux-dvb mailing list<br> <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
 </blockquote></div><br><br clear="all"><br>-- <br>-Antti-

------=_Part_26229_16820428.1206992690939--


--===============0373738294==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0373738294==--
