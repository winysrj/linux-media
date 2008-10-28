Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kupey-0005U3-BS
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 15:35:05 +0100
From: Darron Broad <darron@kewl.org>
To: "pierre gronlier" <ticapix@gmail.com>
In-reply-to: <ecc945da0810280605n7608617dla7a9673f38853583@mail.gmail.com> 
References: <ecc945da0810280605n7608617dla7a9673f38853583@mail.gmail.com>
Date: Tue, 28 Oct 2008 14:34:58 +0000
Message-ID: <26073.1225204498@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx24116 and FE_DISEQC_SEND_MASTER_CMD
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <ecc945da0810280605n7608617dla7a9673f38853583@mail.gmail.com>, "pierre gronlier" wrote:
>Hi,

hello

>I just bought a hvr4000 dvb-s card. I have a dish with a quattro
>monobloc lnb head. The first head is pointing towards Astra-19.2E and
>the second one towards Hotbird-13.0E. There is no motor.
>
>I'm using a 2.6.26 kernel with the v4l-dvb (mercurial) driver.
>
>I can scan Astra with this command
>scan -s 0 /usr/share/dvb/dvb-s/Astra-19.2E
>and Hotbird with
>scan -s 1 /usr/share/dvb/dvb-s/Hotbird-13.0E
>
<snip>
>Is that normal to have to repeat the command twince ?

No, but the cx24116 contains some hacks to help when
applications do not indicate the burst mode bit
explicitly. Your LNB appears to depend on tone burst
and dvbstream is not supporting simple switches
by the look of it. There is another IOCTL for
toneburst. If you add that to the code it may work
as expected.

Alternatively, look at the `toneburst' setting
for the cx24116 and change it, however, the default
mode which should derive the toneburst from the message
appears not to be working in this case. Your setup
may just need repeated commands.

If you want to explore problems like this then
you need to enable debugging for the cx24116
and show what dvbstream in delivering directly
to the driver so we can see for sure what's
happening and that we make no false assumptions.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
