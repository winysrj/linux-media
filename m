Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ashesmtp01.verizonbusiness.com ([198.4.8.163])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark.paulus@verizonbusiness.com>) id 1KSZgB-0005MD-5w
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 17:51:36 +0200
Received: from pmismtp05.wcomnet.com ([166.37.158.165])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0K5G007B01CFHU00@firewall.verizonbusiness.com> for
	linux-dvb@linuxtv.org; Mon, 11 Aug 2008 15:50:39 +0000 (GMT)
Received: from pmismtp05.wcomnet.com ([127.0.0.1])
	by pmismtp05.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0K5G005RO1CETC@pmismtp05.mcilink.com> for
	linux-dvb@linuxtv.org; Mon, 11 Aug 2008 15:50:38 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.132.9])
	by pmismtp05.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0K5G0059P1913Q@pmismtp05.mcilink.com> for
	linux-dvb@linuxtv.org; Mon, 11 Aug 2008 15:50:38 +0000 (GMT)
Date: Mon, 11 Aug 2008 09:48:40 -0600
From: Mark Paulus <mark.paulus@verizonbusiness.com>
To: linux-dvb@linuxtv.org
Message-id: <48A05F58.8090405@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------080306010309090409070307
Subject: [linux-dvb] [Fwd: Help with recent DVB/QAM problem please.]
Reply-To: mark.paulus@verizonbusiness.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080306010309090409070307
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Redirecting to linux-dvb on suggestion from
Video4Linux user.

-------- Original Message --------
Subject: Help with recent DVB/QAM problem please.

Hi all,

Background:
I have a machine in my basement with:
Hauppauge PVR-150 (connected to DCT2524)
Air2PC ATSC/OTA card (connected to antenna in attic)
Avermedia A180 (connected to comcast cable)
Dvico FusionHDTV RT 5 Lite (connectec comcast cable)
Debian using 2.6.24-x64 kernel

Situation:
Up until a week ago, I was able to use azap to tune in
a bunch of mplexids, and get good locks on both the 
A180 and the Dvico card.  However, starting on Monday,
I am not able to get locks on either of my DVB cards.
I have been able, and am still able to get good locks
on my air2pc OTA card.

Can anyone help me figure out why I can't seem to see
anything from my 2 QAM cards?  I've tried running a
dvbscan and neither card can make a good lock.  What
other debugging tools can I use to try to find any QAM
signals?  I've also tried doing a VSB-8 scan on the cable
cards, and also don't get any locks.

Thanks.



--------------080306010309090409070307
Content-Type: text/x-vcard; charset=utf-8;
 name="mark_paulus.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mark_paulus.vcf"

YmVnaW46dmNhcmQNCmZuOk1hcmsgUGF1bHVzDQpuOlBhdWx1cztNYXJrDQpvcmc6TUNJO0xl
YyBJbnRlcmZhY2VzIC8gNDA0MTkNCmFkcjtkb206OzsyNDI0IEdhcmRlbiBvZiB0aGUgR29k
cyBSZDtDb2xvcmFkbyBTcHJpbmdzO0NPOzgwOTE5DQplbWFpbDtpbnRlcm5ldDptYXJrLnBh
dWx1c0B2ZXJpem9uYnVzaW5lc3MuY29tDQp0aXRsZTpNYXJrIFBhdWx1cw0KdGVsO3dvcms6
NzE5LTUzNS01NTc4DQp0ZWw7cGFnZXI6ODAwLXBhZ2VtY2kgLyAxNDA2MDUyDQp0ZWw7aG9t
ZTp2NjIyLTU1NzgNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------080306010309090409070307
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080306010309090409070307--
