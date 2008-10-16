Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ashesmtp02.verizonbusiness.com ([198.4.8.166])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark.paulus@verizonbusiness.com>) id 1KqSlg-0004gj-Hk
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 15:19:59 +0200
Received: from dgismtp01.wcomnet.com ([166.38.58.141])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0K8U00C5X2C8ZD00@firewall.verizonbusiness.com> for
	linux-dvb@linuxtv.org; Thu, 16 Oct 2008 13:19:20 +0000 (GMT)
Received: from dgismtp01.wcomnet.com ([127.0.0.1])
	by dgismtp01.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0K8U00E662C8CO@dgismtp01.mcilink.com> for
	linux-dvb@linuxtv.org; Thu, 16 Oct 2008 13:19:20 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.133.101])
	by dgismtp01.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0K8U00D9W2C7SU@dgismtp01.mcilink.com> for
	linux-dvb@linuxtv.org; Thu, 16 Oct 2008 13:19:19 +0000 (GMT)
Date: Thu, 16 Oct 2008 07:19:18 -0600
From: Mark Paulus <mark.paulus@verizonbusiness.com>
In-reply-to: <20081015232121.GA8831@geppetto>
To: linux-dvb@linuxtv.org
Message-id: <48F73F56.7060805@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------070308010809000005030405
References: <20081014212402.GB11745@geppetto> <20081015232121.GA8831@geppetto>
Subject: Re: [linux-dvb] Unable to query frontend status with dvbscan
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
--------------070308010809000005030405
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Stefano Sabatini wrote:
> On date Tuesday 2008-10-14 23:24:02 +0200, Stefano Sabatini wrote:
>> Hi all,
>>
>> can you say what's the meaning of such a message?
>>
>> I'm using it with:
>> dvbscan  /usr/share/dvb/dvb-t/it-MyCity
>> Unable to query frontend status
>>
>> using a TerraTec Electronic GmbH with dvb-usb-dib0700 driver.
>>
>> The module seems to be loaded correctly, indeed I get this in the
>> kernel log:
>>
>> [ 1834.456051] dib0700: loaded with support for 7 different device-types
>> [ 1834.456051] dvb-usb: found a 'Terratec Cinergy HT USB XE' in cold state, will try to load a firmware
>> [ 1834.456051] firmware: requesting dvb-usb-dib0700-1.10.fw
>> [ 1834.464197] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
>> [ 1834.662979] dib0700: firmware started successfully.
>> [ 1835.168928] dvb-usb: found a 'Terratec Cinergy HT USB XE' in warm state.
>> [ 1835.168997] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
>> [ 1835.169355] DVB: registering new adapter (Terratec Cinergy HT USB XE)
>> [ 1835.419963] DVB: registering frontend 0 (DiBcom 7000PC)...
>> [ 1835.499932] xc2028 1-0061: creating new instance
>> [ 1835.499932] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>> [ 1835.499932] input: IR-receiver inside an USB DVB receiver as /class/input/input7
>> [ 1835.510406] dvb-usb: schedule remote query interval to 150 msecs.
>> [ 1835.510416] dvb-usb: Terratec Cinergy HT USB XE successfully initialized and connected.
>> [ 1835.510696] usbcore: registered new interface driver dvb_usb_dib0700
>>
>> The led on the device switched on when I performed the first scan.
> 
> Other meaningful info:
> stefano@geppetto ~> dvbscan  /usr/share/dvb/dvb-t/it-Cagliari
> Unable to query frontend status
> stefano@geppetto ~> sudo dvbscan  /usr/share/dvb/dvb-t/it-Cagliari
> Unable to query frontend status
> stefano@geppetto ~> ls -l /dev/dvb/adapter0/
> total 0
> crw-rw---- 1 root video 212, 1 2008-09-23 00:04 audio0
> crw-rw---- 1 root video 212, 6 2008-09-23 00:04 ca0
> crw-rw---- 1 root video 212, 4 2008-09-23 00:04 demux0
> crw-rw---- 1 root video 212, 5 2008-09-23 00:04 dvr0
> crw-rw---- 1 root video 212, 3 2008-09-23 00:04 frontend0
> crw-rw---- 1 root video 212, 7 2008-09-23 00:04 net0
> crw-rw---- 1 root video 212, 8 2008-09-23 00:04 osd0
> crw-rw---- 1 root video 212, 0 2008-09-23 00:04 video0
> 
> stefano@geppetto ~> uname -a
> Linux geppetto 2.6.26-1-686 #1 SMP Thu Oct 9 15:18:09 UTC 2008 i686 GNU/Linux
> 
> The device is reported to be supported on the DVB wiki:
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_HT_USB_XE
> 
> Help or hints will be appreciated.
> 
> Regards.

I believe I have seen a message like this when something else
is talking to the card already.  For instance, I run 
my cards in a Mythtv system, and in mythtv there is a setting 
to only attach to the card when actually using the card.  If that
setting is set incorrectly, mythtv will attach to the card 
at startup, and keep exclusive use of the card, not allowing
anyone else to access the card at all.


 

--------------070308010809000005030405
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
--------------070308010809000005030405
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070308010809000005030405--
