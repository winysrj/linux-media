Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <pghben@yahoo.com>) id 1LvuZj-0007H9-Ld
	for linux-dvb@linuxtv.org; Mon, 20 Apr 2009 16:34:24 +0200
From: Benster & Jeremy <pghben@yahoo.com>
To: linux-dvb@linuxtv.org
Date: Mon, 20 Apr 2009 10:33:44 -0400
Message-Id: <1240238024.5388.21.camel@mountainboyzlinux0>
Mime-Version: 1.0
Subject: [linux-dvb] Is HP rebranded Hauppauge HVR-1500 ok on 64bit versions
 of stable distributions?
Reply-To: linux-media@vger.kernel.org, pghben@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1184357509=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1184357509==
Content-Type: multipart/alternative; boundary="=-czn81+vwzDkKUCEb1/UL"


--=-czn81+vwzDkKUCEb1/UL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I have the hp expresscard version of the hauppauge VHR-1500 tuner. I am
having problems getting it to operate under the latest 64bit versions of
ubuntu and  suse.

Has anyone had one of these combinations working? 

I've looked back over the archive on this list and found several
threads, but being a recent convert to linux, I couldn't recognize if  I
needed to download and recompile modules more recent than those shipped
with 2.6.27 kernels. Nor did I know how to tell if the people that had
it working were running 32 or 64 bit versions. 

 I'm wondering if this may only be an issue with 64 bit, only because
I've had a few things that took some work to get going that were related
to using 64bit.

Any suggestions as to what to look for or where to go for help?

Looking at dmesg, the card is recognized, the firmware is
in /lib/firmware, but no messages indicating it is being shipped to the
card. 

When I try to scan for channels with either metv or w_scan, it goes
through the motions, but finds no channels. The light on the card does
not come on.

Thanks in advance,
Ben (pghben@yahoo.com)

--=-czn81+vwzDkKUCEb1/UL
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.24.1.1">
</HEAD>
<BODY>
I have the hp expresscard version of the hauppauge VHR-1500 tuner. I am having problems getting it to operate under the latest 64bit versions of ubuntu and&nbsp; suse.<BR>
<BR>
Has anyone had one of these combinations working? <BR>
<BR>
I've looked back over the archive on this list and found several threads, but being a recent convert to linux, I couldn't recognize if&nbsp; I needed to download and recompile modules more recent than those shipped with 2.6.27 kernels. Nor did I know how to tell if the people that had it working were running 32 or 64 bit versions. <BR>
<BR>
 I'm wondering if this may only be an issue with 64 bit, only because I've had a few things that took some work to get going that were related to using 64bit.<BR>
<BR>
Any suggestions as to what to look for or where to go for help?<BR>
<BR>
Looking at dmesg, the card is recognized, the firmware is in /lib/firmware, but no messages indicating it is being shipped to the card. <BR>
<BR>
When I try to scan for channels with either metv or w_scan, it goes through the motions, but finds no channels. The light on the card does not come on.<BR>
<BR>
Thanks in advance,<BR>
Ben (<A HREF="mailto:pghben@yahoo.com">pghben@yahoo.com</A>)
</BODY>
</HTML>

--=-czn81+vwzDkKUCEb1/UL--




--===============1184357509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1184357509==--
