Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep20-int.chello.at ([62.179.121.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <basq@bitklub.hu>) id 1KxLIl-0002LT-25
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 13:46:31 +0100
Received: from edge01.upc.biz ([192.168.13.236]) by viefep20-int.chello.at
	(InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
	id <20081104124557.QKKJ15604.viefep20-int.chello.at@edge01.upc.biz>
	for <linux-dvb@linuxtv.org>; Tue, 4 Nov 2008 13:45:57 +0100
Date: Tue, 4 Nov 2008 13:45:39 +0100
From: Kovacs Balazs <basq@bitklub.hu>
Message-ID: <42260639.20081104134539@bitklub.hu>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <c74595dc0811040131w5e3342cbq8242d0d2422c2ee0@mail.gmail.com>
References: <167586304.20081103115116@bitklub.hu>
	<20081103155903.245267fe@bk.ru>
	<54283792.20081104090010@bitklub.hu>
	<b42fca4d0811040108x4e71f95ds141942b35d505c72@mail.gmail.com>
	<c74595dc0811040131w5e3342cbq8242d0d2422c2ee0@mail.gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] S2API + TT3200 + Amos4w 10.723 S2 problem
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

I tried almost all what I know:

v4l-dvb with szap-s2 and scan-s2

liplianin-dvb with older szap2

s2-liplianin with szap-s2 and scan-s2

and the results the same in almost all the case: sometimes locks, but it's very rare for me.

Maybe is it because of the 2.6.24 kernel? I don't know.

Please, somebody with TT3200 with success on these TP's reply me what version of driver + utilities (szap, scan) do you use?

thanks,

Basq


> Just to add my 2 cents, in lyngsat that transponder is shown as
> 10722 and not 10723, so Oleg was probably not the only one who
> reduced the frequency to lock on that channel.

> On Tue, Nov 4, 2008 at 11:08 AM, oleg roitburd <oroitburd@gmail.com> wrote:
> I have decreased frequenz ( -4MHz)
> And I can scan both transpoders with SR 30000

> [0001];:10719:vS1C23M5:S0.0W:30000:179:177=hun:180:0:1:0:0:0
> [0002];:10719:vS1C23M5:S0.0W:30000:174:172=hun:175:0:2:0:0:0
> [0003];:10719:vS1C23M5:S0.0W:30000:169:0:170:0:3:0:0:0
> [0004];:10719:vS1C23M5:S0.0W:30000:164:0:165:0:4:0:0:0
> [0005];:10719:vS1C23M5:S0.0W:30000:159:0:0:0:5:0:0:0
> [0006];:10719:vS1C23M5:S0.0W:30000:154:0:0:0:6:0:0:0
> [0007];:10719:vS1C23M5:S0.0W:30000:149:0:0:0:7:0:0:0
> [0008];:10719:vS1C23M5:S0.0W:30000:144:0:0:0:8:0:0:0
> [000a];:10719:vS1C23M5:S0.0W:30000:134:0:0:0:10:0:0:0
> [000b];:10719:vS1C23M5:S0.0W:30000:129:0:0:0:11:0:0:0
> [000c];:10719:vS1C23M5:S0.0W:30000:124:0:0:0:12:0:0:0
> [000e];:10719:vS1C23M5:S0.0W:30000:114:0:0:0:14:0:0:0
> [000f];:10719:vS1C23M5:S0.0W:30000:109:0:0:0:15:0:0:0
> [0010];:10719:vS1C23M5:S0.0W:30000:104:0:0:0:16:0:0:0
> [0011];:10719:vS1C23M5:S0.0W:30000:99:0:0:0:17:0:0:0
> [0012];:10719:vS1C23M5:S0.0W:30000:94:0:0:0:18:0:0:0
> [0013];:10719:vS1C23M5:S0.0W:30000:89:0:0:0:19:0:0:0
> [0014];:10719:vS1C23M5:S0.0W:30000:84:0:0:0:20:0:0:0
> [0015];:10719:vS1C23M5:S0.0W:30000:79:0:0:0:21:0:0:0
> [0016];:10719:vS1C23M5:S0.0W:30000:74:0:0:0:22:0:0:0
> [0017];:10719:vS1C23M5:S0.0W:30000:69:0:0:0:23:0:0:0
> [0018];:10719:vS1C23M5:S0.0W:30000:64:0:0:0:24:0:0:0
> [0019];:10719:vS1C23M5:S0.0W:30000:59:0:0:0:25:0:0:0
> [001a];:10719:vS1C23M5:S0.0W:30000:54:0:0:0:26:0:0:0
> [001d];:10719:vS1C23M5:S0.0W:30000:39:0:0:0:29:0:0:0
> [001e];:10719:vS1C23M5:S0.0W:30000:34:0:0:0:30:0:0:0
> [001f];:10754:vS1C23M5:S0.0W:30000:90:0:0:0:31:0:0:0
> [0020];:10754:vS1C23M5:S0.0W:30000:85:0:0:0:32:0:0:0
> [0021];:10754:vS1C23M5:S0.0W:30000:80:0:0:0:33:0:0:0
> [0023];:10754:vS1C23M5:S0.0W:30000:70:0:71:0:35:0:0:0
> [0024];:10754:vS1C23M5:S0.0W:30000:65:0:66:0:36:0:0:0
> [0025];:10754:vS1C23M5:S0.0W:30000:60:0:0:0:37:0:0:0
> [0026];:10754:vS1C23M5:S0.0W:30000:55:0:0:0:38:0:0:0
> [0065];:10754:vS1C23M5:S0.0W:30000:46:44=hun:0:0:101:0:0:0
> [0066];:10754:vS1C23M5:S0.0W:30000:42:40=eng:0:0:102:0:0:0
> [0067];:10754:vS1C23M5:S0.0W:30000:38:36;36:0:0:103:0:0:0
> [0068];:10754:vS1C23M5:S0.0W:30000:34:32=eng:0:0:104:0:0:0

> It's old bug and old quick&dirty trick. My card is TT S2-3200

> Regards
> Oleg Roitburd


> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
