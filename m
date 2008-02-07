Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp108.rog.mail.re2.yahoo.com ([68.142.225.206])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JN9ZT-0002Wc-K3
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 17:25:55 +0100
Message-ID: <47AB30EF.7020209@rogers.com>
Date: Thu, 07 Feb 2008 11:25:19 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: LinuxDVB Mailing List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] get_dvb_firmware perl script and the present Xceive
 firmware extraction scripts
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Just a thought about some possible "consolidation / elimination of 
fragmentation / consistency " meant to benefit the end user.  How about 
adding to the get_dvb_firmware script ( 
http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/dvb/get_dvb_firmware 
)  a section for:

a) XC5000 firmware
- add a download of the firmware ... "wget 
http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip"
- and actually add/merge Steve's forty_some_line XC5000 firmware 
extraction script, "extract.sh" ( presently found here: 
http://www.steventoth.net/linux/xc5000/  )

b) XC2028/3208 firmware
- add a download of the firmware ... "wget 
http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip"
- then add a call to Mauro's XC2028/3208 extraction script, 
"extract_xc3028.pl" (found here: 
http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/video4linux/extract_xc3028.pl 
) for the actual extraction ... all seamless, and behind the scenes).

That way, DVB users would only need know/worry about the one script --> 
get_dvb_firmware  i.e.:
# path/get_dvb_firmware xc5000
# path/get_dvb_firmware xc3028  

Any licensing/distribution point of restriction I'm overlooking?  
Nothing mentioned on stoth's site to suggest otherwise.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
