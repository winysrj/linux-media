Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-d06.mx.aol.com ([205.188.157.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dbox2alpha@netscape.net>) id 1L5Oso-0001R5-4n
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 19:13:02 +0100
Received: from dbox2alpha@netscape.net
	by imo-d06.mx.aol.com  (mail_out_v39.1.) id m.d52.38d5870f (37528)
	for <linux-dvb@linuxtv.org>; Wed, 26 Nov 2008 13:12:20 -0500 (EST)
References: <8CB1E0702B1E199-12D0-A6@mblk-d24.sysops.aol.com>
To: linux-dvb@linuxtv.org
Date: Wed, 26 Nov 2008 13:12:17 -0500
In-Reply-To: <8CB1E0702B1E199-12D0-A6@mblk-d24.sysops.aol.com>
MIME-Version: 1.0
From: dbox2alpha@netscape.net
Message-Id: <8CB1E09A6760FFD-12D0-1D8@mblk-d24.sysops.aol.com>
Subject: [linux-dvb] tt s2-3600 driver: big endian bug?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2045463265=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============2045463265==
Content-Type: multipart/alternative;
 boundary="--------MB_8CB1E09A67D3717_12D0_3DD_mblk-d24.sysops.aol.com"


----------MB_8CB1E09A67D3717_12D0_3DD_mblk-d24.sysops.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"

hi, 
looks like the driver for tt s2-3600 is not working on big endian systems like ps3.


I get:



pctv452e_power_ctrl: 1

stb6100_set_bandwidth: Bandwidth=61262500

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_frequency: Frequency=1236000

stb6100_get_frequency: Frequency=1235988

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_bandwidth: Bandwidth=61262500

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_frequency: Frequency=1236000

stb6100_get_frequency: Frequency=1235988

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_bandwidth: Bandwidth=61262500

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_frequency: Frequency=1236000

stb6100_get_frequency: Frequency=1235988

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_bandwidth: Bandwidth=61262500

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_frequency: Frequency=1236000

stb6100_get_frequency: Frequency=1235988

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_bandwidth: Bandwidth=61262500

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_frequency: Frequency=1236000

stb6100_get_frequency: Frequency=1235988

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_bandwidth: Bandwidth=61262500

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_get_bandwidth: Bandwidth=62000000

stb6100_set_frequency: Frequency=1236000

stb6100_get_frequency: Frequency=1235988

stb6100_get_bandwidth: Bandwidth=62000000



when trying to tune with szap... sometimes also lots of i2c error messages and other stuff shows up...

any suggestions?

thanks.









 Tis the season to save your money!  Get the new AOL Holiday Toolbar for money saving offers and gift ideas. 



 


----------MB_8CB1E09A67D3717_12D0_3DD_mblk-d24.sysops.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/html; charset="us-ascii"

<font face="Arial, Helvetica, sans-serif">hi, <br>
</font>looks like the driver for tt s2-3600 is not working on big endian systems like ps3.<br>

<div id="AOLMsgPart_2_98c63f7b-1339-475a-9c5b-02eb1449ec57"><font face="Arial, Helvetica, sans-serif">
I get:<br>

<br>

pctv452e_power_ctrl: 1<br>

stb6100_set_bandwidth: Bandwidth=61262500<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_frequency: Frequency=1236000<br>

stb6100_get_frequency: Frequency=1235988<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_bandwidth: Bandwidth=61262500<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_frequency: Frequency=1236000<br>

stb6100_get_frequency: Frequency=1235988<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_bandwidth: Bandwidth=61262500<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_frequency: Frequency=1236000<br>

stb6100_get_frequency: Frequency=1235988<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_bandwidth: Bandwidth=61262500<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_frequency: Frequency=1236000<br>

stb6100_get_frequency: Frequency=1235988<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_bandwidth: Bandwidth=61262500<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_frequency: Frequency=1236000<br>

stb6100_get_frequency: Frequency=1235988<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_bandwidth: Bandwidth=61262500<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

stb6100_set_frequency: Frequency=1236000<br>

stb6100_get_frequency: Frequency=1235988<br>

stb6100_get_bandwidth: Bandwidth=62000000<br>

<br>

when trying to tune with szap... sometimes also lots of i2c error messages and other stuff shows up...<br>

any suggestions?<br>

thanks.<br>

<br>

<br>

</font>
<div id="MAILCIAMA025-5bbf492d8d1238b" class="aol_ad_footer"><br>
<font style="color: black; font-family: ARIAL,SAN-SERIF; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal; -x-system-font: none;"></font><hr style="margin-top: 10px;"><font style="color: black; font-family: ARIAL,SAN-SERIF; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal; -x-system-font: none;"> Tis the season to save your money!  <a target="_blank" href="http://toolbar.aol.com/holiday/download.html?ncid=emlweusdown00000008">Get the new AOL Holiday Toolbar</a> for money saving offers and gift ideas. </font></div>


</div>
<font style="color: black; font-family: ARIAL,SAN-SERIF; font-style: normal; font-variant: normal; font-weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch: normal; -x-system-font: none;"> <!-- end of AOLMsgPart_2_98c63f7b-1339-475a-9c5b-02eb1449ec57 -->

</font><div id='MAILCIAMB011-5c57492d918038a' class='aol_ad_footer'><BR/><FONT style="color: black; font: normal 10pt ARIAL, SAN-SERIF;"><HR style="MARGIN-TOP: 10px"></HR> Tis the season to save your money!  <a href="http://toolbar.aol.com/holiday/download.html?ncid=emlweusdown00000008">Get the new AOL Holiday Toolbar</a> for money saving offers and gift ideas. </div>

----------MB_8CB1E09A67D3717_12D0_3DD_mblk-d24.sysops.aol.com--


--===============2045463265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2045463265==--
