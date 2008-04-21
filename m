Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <amitay@gmail.com>) id 1JnoIJ-0000Fc-UN
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 07:10:30 +0200
Received: by yw-out-2324.google.com with SMTP id 5so910883ywh.41
	for <linux-dvb@linuxtv.org>; Sun, 20 Apr 2008 22:10:05 -0700 (PDT)
Message-ID: <75a6c8000804202210l7edb82c1v604513f4780e17c3@mail.gmail.com>
Date: Mon, 21 Apr 2008 15:10:04 +1000
From: "Amitay Isaacs" <amitay@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <909585.95795.qm@web55613.mail.re4.yahoo.com>
MIME-Version: 1.0
References: <909585.95795.qm@web55613.mail.re4.yahoo.com>
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0971601214=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0971601214==
Content-Type: multipart/alternative;
	boundary="----=_Part_6990_1229354.1208754605011"

------=_Part_6990_1229354.1208754605011
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Trevor

On Mon, Apr 21, 2008 at 1:02 PM, Trevor Boon <trevor_boon@yahoo.com> wrote:

> Hi,
>
> I have a Leadtek DTV1000s, which uses the tda10048,
> and after compiling the latest build of v4l-dvb which
> include the tda10048 support, the driver crashes upon
> boot.
>
> I know the DTV100s is not yet officially supported,
> however now that the nxp18271 and the tda10048 drivers
> have been implemented, I thought I'd give it a go.
>
> Using Kernel 2.6.25 on Ubuntu Hardy 8.04
>
> I've already tried blacklisting the saa7134-alsa from
> a previous driver crash. (I believe that has been
> fixed however?)
>
> As the dmesg output shows, I specified card=21 as this
> worked for composite input previously. I've tried
> other card numbers as well with the same result. No
> card number just returns 0=autodetected (as expected)
> but it doesn't try to load the tda10048 module and
> therefore doesn't crash.
>
> Is there anything else I can do to try and help
> troubleshoot this issue/ expediate official dtv1000s
> support?


Leadtek card Winfast DTV1000S is currently not added in the DVB code.
I am attempting to add support for the card using the TDA10048 driver
committed by Steven. Since there is no other information available about
the DTV1000S card (other than it uses SAA7130, TDA18271 and TDA10048)
it's going to be a bit tricky getting all the bits together.

I could not find any documentation/details on adding support for new PCI
cards.
So going through various drivers to figure out the details. Can any one
point out
to a reference driver or any documentation which can be used to support a
new
PCI card?

Thanks.

Amitay.

------=_Part_6990_1229354.1208754605011
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Trevor<br><br><div class="gmail_quote">On Mon, Apr 21, 2008 at 1:02 PM, Trevor Boon &lt;<a href="mailto:trevor_boon@yahoo.com">trevor_boon@yahoo.com</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
I have a Leadtek DTV1000s, which uses the tda10048,<br>
and after compiling the latest build of v4l-dvb which<br>
include the tda10048 support, the driver crashes upon<br>
boot.<br>
<br>
I know the DTV100s is not yet officially supported,<br>
however now that the nxp18271 and the tda10048 drivers<br>
have been implemented, I thought I&#39;d give it a go.<br>
<br>
Using Kernel 2.6.25 on Ubuntu Hardy 8.04<br>
<br>
I&#39;ve already tried blacklisting the saa7134-alsa from<br>
a previous driver crash. (I believe that has been<br>
fixed however?)<br>
<br>
As the dmesg output shows, I specified card=21 as this<br>
worked for composite input previously. I&#39;ve tried<br>
other card numbers as well with the same result. No<br>
card number just returns 0=autodetected (as expected)<br>
but it doesn&#39;t try to load the tda10048 module and<br>
therefore doesn&#39;t crash.<br>
<br>
Is there anything else I can do to try and help<br>
troubleshoot this issue/ expediate official dtv1000s<br>
support?</blockquote><div><br>Leadtek card Winfast DTV1000S is currently not added in the DVB code.<br>I am attempting to add support for the card using the TDA10048 driver <br>committed by Steven. Since there is no other information available about <br>
the DTV1000S card (other than it uses SAA7130, TDA18271 and TDA10048)<br>it&#39;s going to be a bit tricky getting all the bits together. <br><br>I could not find any documentation/details on adding support for new PCI cards. <br>
So going through various drivers to figure out the details. Can any one point out <br>to a reference driver or any documentation which can be used to support a new<br>PCI card?<br><br>Thanks.<br><br>Amitay.<br><br><br></div>
</div>

------=_Part_6990_1229354.1208754605011--


--===============0971601214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0971601214==--
